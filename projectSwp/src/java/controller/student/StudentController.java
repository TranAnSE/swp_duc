/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student;

import dal.AccountDAO;
import dal.GradeDAO;
import dal.ImageDAO;
import dal.StudentDAO;
import config.FileUploadUlti;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Account;
import model.Grade;
import model.Image;
import model.Student;
import util.AuthUtil;
import util.RoleConstants;

/**
 *
 * @author BuiNgocLinh
 */
@MultipartConfig
@WebServlet(name = "StudentController", urlPatterns = {"/student"})

public class StudentController extends HttpServlet {

    private StudentDAO studentDAO = new StudentDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private GradeDAO gradeDAO = new GradeDAO();
    private ImageDAO ImageDAO = new ImageDAO(accountDAO.getConnection());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.STUDENT)
                && !AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "viewProfile":
                    viewProfile(request, response);
                    break;
                case "search":
                    searchStudents(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteStudent(request, response);
                    break;
                case "getByParent":
                    getStudentsByParentAjax(request, response);
                    return;
                default:
                    listStudents(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.STUDENT)
                && !AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    insertStudent(request, response);
                    break;
                case "edit":
                    updateStudent(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int page = 1;
        int recordsPerPage = 5;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;
        List<Account> accList = accountDAO.findAll();
        List<Student> list = studentDAO.getStudentsByPage(offset, recordsPerPage);
        int totalRecords = studentDAO.countStudents();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        List<Grade> gradeList = gradeDAO.findAllFromGrade();
        List<Image> imageList = ImageDAO.findAll();

        request.setAttribute("students", list);
        request.setAttribute("accList", accList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("imageList", imageList);
        request.getRequestDispatcher("/student/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Grade> gradeList = gradeDAO.findAllFromGrade();
        List<Account> accList = accountDAO.findAll();
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("accList", accList);
        request.getRequestDispatcher("/student/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Grade> gradeList = gradeDAO.findAllFromGrade();
        List<Account> accList = accountDAO.findAll();
        int id = Integer.parseInt(request.getParameter("id"));
        Student student = studentDAO.findById(id);
        Image image = ImageDAO.findImageById(student.getImage_id());
        request.setAttribute("student", student);
        request.setAttribute("image", image);
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("accList", accList);

        request.getRequestDispatcher("/student/form.jsp").forward(request, response);
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        Student student = getStudentFromRequest(request);
        String avatarName = "avatar_" + System.currentTimeMillis();

        String imgURL = FileUploadUlti.uploadAvatarImage(request, avatarName);

        if (imgURL != null) {
            Image image = new Image();
            image.setImage_data(imgURL);

            ImageDAO imageDAO = new ImageDAO(studentDAO.getConnection());
            int imageId = imageDAO.insertImage(image);
            if (imageId > 0) {
                student.setImage_id(imageId);
            }
        }
        studentDAO.insert(student);
        response.sendRedirect("student");
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        Student student = getStudentFromRequest(request);
        String avatarName = "avatar_" + System.currentTimeMillis();
        String imgURL = FileUploadUlti.uploadAvatarImage(request, avatarName);

        if (imgURL != null) {
            Image image = new Image();
            image.setImage_data(imgURL);

            ImageDAO imageDAO = new ImageDAO(studentDAO.getConnection());
            int imageId = imageDAO.insertImage(image);
            if (imageId > 0) {
                student.setImage_id(imageId);
            }
        } else {
            Student oldStudent = studentDAO.findById(student.getId());
            student.setImage_id(oldStudent.getImage_id());
        }
        studentDAO.update(student);
        response.sendRedirect("student");
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        studentDAO.delete(id);
        response.sendRedirect("student");
    }

    private void searchStudents(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        List<Student> list = studentDAO.searchByKeyword(keyword);
        List<Account> accList = accountDAO.findAll();
        List<Grade> gradeList = gradeDAO.findAllFromGrade();
        List<Image> imageList = ImageDAO.findAll();

        request.setAttribute("students", list);
        request.setAttribute("accList", accList);
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("imageList", imageList);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/student/list.jsp").forward(request, response);
    }

    private Student getStudentFromRequest(HttpServletRequest request) {
        int id = 0;
        if (request.getParameter("id") != null) {
            id = Integer.parseInt(request.getParameter("id"));
        }
        int gradeId = Integer.parseInt(request.getParameter("grade_id"));
        int parentId = Integer.parseInt(request.getParameter("parent_id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        LocalDate dob = LocalDate.parse(request.getParameter("dob"));
        boolean sex = Boolean.parseBoolean(request.getParameter("sex"));

        String imageIdParam = request.getParameter("image_id");
        int imageId = (imageIdParam == null || imageIdParam.isEmpty()) ? 0 : Integer.parseInt(imageIdParam);

        return new Student(id, gradeId, parentId, username, password, fullName, dob, sex, imageId);
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Image> imageList = ImageDAO.findAll();
        List<Account> accList = accountDAO.findAll();
        List<Grade> gradeList = gradeDAO.findAllFromGrade();
        int id = Integer.parseInt(request.getParameter("id"));
        Student studentView = studentDAO.findById(id);
        request.setAttribute("accList", accList);
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("imageList", imageList);
        request.setAttribute("view", studentView);
        request.getRequestDispatcher("student/viewProfile.jsp").forward(request, response);
    }

    private void getStudentsByParentAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int parentId = Integer.parseInt(request.getParameter("parentId"));
            List<Student> students = studentDAO.getStudentsByParentId(parentId);
            List<Grade> gradeList = gradeDAO.findAllFromGrade();

            // Create JSON response manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < students.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Student student = students.get(i);

                // Find grade name
                String gradeName = "Unknown";
                for (Grade grade : gradeList) {
                    if (grade.getId() == student.getGrade_id()) {
                        gradeName = grade.getName();
                        break;
                    }
                }

                json.append("{")
                        .append("\"id\":").append(student.getId())
                        .append(",\"full_name\":\"").append(escapeJson(student.getFull_name())).append("\"")
                        .append(",\"username\":\"").append(escapeJson(student.getUsername())).append("\"")
                        .append(",\"grade_name\":\"").append(escapeJson(gradeName)).append("\"")
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    // Helper method để escape JSON strings
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
