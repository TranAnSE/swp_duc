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

@WebServlet(name = "GradeController", urlPatterns = {"/Grade"})
public class GradeController extends HttpServlet {

    private GradeDAO gradeDAO = new GradeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.STUDENT) && !AuthUtil.hasRole(request, RoleConstants.TEACHER) ) {
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

                            // Lấy danh sách giáo viên để đưa vào form select
                            List<Account> teacher = new AccountDAO().findAll();
                            request.setAttribute("accounts", teacher);

                            request.getRequestDispatcher("grade/updateGrade.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("error", "Không tìm thấy grade với ID " + id);
                        }
                    } else {
                        request.setAttribute("error", "ID không hợp lệ");
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
                        request.setAttribute("error", "ID không hợp lệ để xóa");
                    }
                    break;

                default:
                    String name = request.getParameter("name");
                    List<Grade> gradeList;
                    if (name != null && !name.trim().isEmpty()) {
                        gradeList = gradeDAO.findByName(name.trim());
                        if (gradeList == null || gradeList.isEmpty()) {
                            request.setAttribute("error", "Không tìm thấy grade nào với tên " + name.trim());
                        }
                    } else {
                        gradeList = gradeDAO.findAllFromGrade();
                    }
                    AccountDAO acc = new AccountDAO();
                    List<Account> accounts = acc.findAll();
                    request.setAttribute("accounts", accounts);
                    request.setAttribute("gradeList", gradeList);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
        }

        request.getRequestDispatcher("grade/gradeList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)&&!AuthUtil.hasRole(request, RoleConstants.STUDENT) ) {
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
