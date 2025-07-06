package controller.grade;

import dal.GradeDAO;
import dal.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Grade;
import model.Account;

import java.io.IOException;
import java.util.List;
import util.AuthUtil;
import util.RoleConstants;
import java.sql.SQLException;

@WebServlet(name = "GradeController", urlPatterns = {"/Grade"})
public class GradeController extends HttpServlet {

    private GradeDAO gradeDAO = new GradeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.STUDENT) && !AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "addForm":
                    List<Account> teachers = new AccountDAO().findAll();
                    request.setAttribute("accounts", teachers);
                    request.getRequestDispatcher("grade/addGrade.jsp").forward(request, response);
                    return;

                case "updateForm":
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        Grade grade = gradeDAO.getGradeById(id);
                        if (grade != null) {
                            request.setAttribute("grade", grade);

                            // Get teacher list for form select
                            List<Account> teacher = new AccountDAO().findAll();
                            request.setAttribute("accounts", teacher);

                            request.getRequestDispatcher("grade/updateGrade.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("error", "Grade not found with ID " + id);
                        }
                    } else {
                        request.setAttribute("error", "Invalid ID");
                    }
                    break;

                case "delete":
                    String delIdStr = request.getParameter("id");
                    if (delIdStr != null) {
                        int delId = Integer.parseInt(delIdStr);
                        gradeDAO.delete(delId);
                        request.setAttribute("message", "Grade deleted successfully");
                        response.sendRedirect("Grade");
                        return;
                    } else {
                        request.setAttribute("error", "Invalid ID for deletion");
                    }
                    break;

                default:
                    listGradesWithPagination(request, response);
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing request: " + e.getMessage());
        }

        request.getRequestDispatcher("grade/gradeList.jsp").forward(request, response);
    }

    private void listGradesWithPagination(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 5) {
                    pageSize = 5;
                }
                if (pageSize > 50) {
                    pageSize = 50;
                }
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }

        // Get filter parameters
        String name = request.getParameter("name");
        String teacherIdParam = request.getParameter("teacherId");
        Integer teacherId = null;

        if (teacherIdParam != null && !teacherIdParam.isEmpty()) {
            try {
                teacherId = Integer.parseInt(teacherIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid teacher ID
            }
        }

        // Get grades with pagination
        List<Grade> gradeList = gradeDAO.findGradesWithPagination(name, teacherId, page, pageSize);
        int totalGrades = gradeDAO.getTotalGradesCount(name, teacherId);

        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalGrades / pageSize);
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);

        // Calculate display range
        int displayStart = (page - 1) * pageSize + 1;
        int displayEnd = Math.min(page * pageSize, totalGrades);

        // Load accounts for filter and display
        AccountDAO acc = new AccountDAO();
        List<Account> accounts = acc.findAll();

        // Set attributes
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("accounts", accounts);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalGrades", totalGrades);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);

        request.setAttribute("displayStart", displayStart);
        request.setAttribute("displayEnd", displayEnd);

        // Preserve filter parameters
        request.setAttribute("selectedName", name);
        request.setAttribute("selectedTeacherId", teacherId);

        request.getRequestDispatcher("grade/gradeList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                String name = request.getParameter("name");
                String description = request.getParameter("description");

                String teacherIdStr = request.getParameter("teacher_id");
                if (teacherIdStr == null || teacherIdStr.trim().isEmpty()) {
                    request.setAttribute("error", "Bạn phải chọn giáo viên.");
                    request.getRequestDispatcher("grade/addGrade.jsp").forward(request, response);
                    return;
                }
                int teacherId = Integer.parseInt(teacherIdStr);

                Grade grade = new Grade(name, description, teacherId);
                gradeDAO.insert(grade);
                request.setAttribute("message", "Grade inserted successfully");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                int teacherId = Integer.parseInt(request.getParameter("teacher_id"));

                Grade grade = new Grade(id, name, description, teacherId);
                gradeDAO.update(grade);
                request.setAttribute("message", "Grade updated successfully");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                gradeDAO.delete(id);
                request.setAttribute("message", "Grade deleted successfully");
            }

            // Sau khi thao tác xong, load lại danh sách grade và account
            List<Grade> gradeList = gradeDAO.findAllFromGrade();
            List<Account> accounts = new AccountDAO().findAll();

            request.setAttribute("gradeList", gradeList);
            request.setAttribute("accounts", accounts);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error while processing request: " + e.getMessage());
        }

        // Trả về trang danh sách
        request.getRequestDispatcher("grade/gradeList.jsp").forward(request, response);
    }
}
