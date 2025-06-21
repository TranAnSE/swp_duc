/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.StudyPackage;

import dal.InvoiceDAO;
import dal.StudyPackageDAO;
import model.StudyPackage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import model.Account;
import model.Invoice;
import util.AuthUtil;
import util.RoleConstants;

/**
 *
 * @author Na
 */
@WebServlet(name = "StudyPackageController", urlPatterns = {"/study_package"})
public class StudyPackageController extends HttpServlet {

    private StudyPackageDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new StudyPackageDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER) && !AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        response.setContentType("text/html;charset=UTF-8");

        String service = request.getParameter("service");

        if (service == null) {
            service = "";
        }

        try {
            switch (service) {
                case "add":
                    if (request.getMethod().equalsIgnoreCase("GET")) {
                        showAddForm(request, response);
                    } else {
                        addStudyPackage(request, response);
                    }
                    break;
                case "edit":
                    if (request.getMethod().equalsIgnoreCase("GET")) {
                        showEditForm(request, response);
                    } else {
                        updateStudyPackage(request, response);
                    }
                    break;
                case "update":
                    updateStudyPackage(request, response);
                    break;
                case "delete":
                    deleteStudyPackage(request, response);
                    break;
                case "search":
                    searchStudyPackage(request, response);
                    break;
                 case "checkout":
                    checkoutStudyPackage(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;

                 
                default:
                    listStudyPackage(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi xử lý: " + e.getMessage());
            request.setAttribute("listStudyPackage", List.of());
            request.getRequestDispatcher("/studypackage/listStudyPackage.jsp").forward(request, response);
        }
    }

    private void listStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<StudyPackage> list = dao.getStudyPackage("SELECT * FROM study_package");
        request.setAttribute("listStudyPackage", list != null ? list : List.of());
        request.getRequestDispatcher("/studypackage/listStudyPackage.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/studypackage/form.jsp").forward(request, response);
    }

    private void addStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String price = request.getParameter("price");

            StudyPackage stuPackage = new StudyPackage(id, name, price);
            int result = dao.addStudyPackage(stuPackage);

            if (result > 0) {
                request.setAttribute("message", "Thêm gói học thành công!");
                response.sendRedirect("study_package");
            } else {
                request.setAttribute("errorMessage", "Không thể thêm gói học!");
                showAddForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Định dạng ID không hợp lệ!");
            showAddForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int editId = Integer.parseInt(request.getParameter("editId"));
            StudyPackage studyPackage = dao.findStudyPackageById(editId);
            if (studyPackage != null) {
                request.setAttribute("studyPackageToEdit", studyPackage);
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy gói học với ID: " + editId);
            }
            request.getRequestDispatcher("/studypackage/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Định dạng ID không hợp lệ!");
            listStudyPackage(request, response);
        }
    }

    private void updateStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String price = request.getParameter("price");

            StudyPackage stuPackage = new StudyPackage(id, name, price);
            int result = dao.updateStudyPackage(stuPackage);

            if (result > 0) {
                request.setAttribute("message", "Cập nhật gói học thành công!");
                response.sendRedirect("study_package");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật gói học!");
                request.setAttribute("studyPackageToEdit", stuPackage);
                request.getRequestDispatcher("/studypackage/form.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Định dạng ID không hợp lệ!");
            listStudyPackage(request, response);
        }
    }

    private void deleteStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int result = dao.deleteStudyPackage(id);
            if (result > 0) {
                request.setAttribute("message", "Xóa gói học thành công!");
            } else {
                request.setAttribute("errorMessage", "Không thể xóa gói học!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Định dạng ID không hợp lệ!");
        }
        response.sendRedirect("study_package");
    }

    private void searchStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String nameParam = request.getParameter("name");
        String priceParam = request.getParameter("price");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                StudyPackage stuPackage = dao.findStudyPackageById(id);
                if (stuPackage != null) {
                    request.setAttribute("listStudyPackage", List.of(stuPackage));
                } else {
                    request.setAttribute("listStudyPackage", List.of());
                    request.setAttribute("message", "Không tìm thấy gói học với id = " + id);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("listStudyPackage", List.of());
                request.setAttribute("message", "Định dạng id không hợp lệ!");
            }
        } else if (nameParam != null && !nameParam.trim().isEmpty()) {
            List<StudyPackage> list = dao.findStudyPackageByName(nameParam);
            request.setAttribute("listStudyPackage", list);
            if (list.isEmpty()) {
                request.setAttribute("message", "Không tìm thấy gói học với tên chứa: " + nameParam);
            }
        } else if (priceParam != null && !priceParam.trim().isEmpty()) {
            List<StudyPackage> list = dao.findStudyPackageByPrice(priceParam);
            request.setAttribute("listStudyPackage", list);
            if (list.isEmpty()) {
                request.setAttribute("message", "Không tìm thấy gói học với giá: " + priceParam);
            }
        } else {
            request.setAttribute("message", "Chưa nhập tiêu chí tìm kiếm");
            request.setAttribute("listStudyPackage", List.of());
        }

        request.getRequestDispatcher("/studypackage/listStudyPackage.jsp").forward(request, response);
    }
   private void checkoutStudyPackage(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        StudyPackage sp = dao.findStudyPackageById(id);

        if (sp != null) {
            // Lấy thông tin người dùng từ session hoặc sử dụng userId mặc định nếu phát triển thử nghiệm
            int userId = 1; 
            // Kiểm tra nếu người dùng đã đăng nhập và là parent
            Object accountObj = request.getSession().getAttribute("account");
            if (accountObj instanceof Account) {
                Account account = (Account) accountObj;
                if (account.getRole() != null && account.getRole().equalsIgnoreCase(RoleConstants.PARENT)) {
                    userId = account.getId();
                }
            }
            
            // Tạo form để gọi PaymentServlet thay vì tạo invoice trực tiếp
            request.setAttribute("packageId", id);
            request.setAttribute("packageName", sp.getName());
            request.setAttribute("amount", Double.parseDouble(sp.getPrice()));
            request.setAttribute("userId", userId);
            
            // Chuyển hướng đến trang chọn phương thức thanh toán
            request.getRequestDispatcher("/studypackage/payment.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy gói học để thanh toán.");
            listStudyPackage(request, response);
        }
    } catch (Exception e) {
        request.setAttribute("errorMessage", "Lỗi xử lý: " + e.getMessage());
        listStudyPackage(request, response);
    }
}

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        StudyPackage studyPackage = dao.findStudyPackageById(id);
        if (studyPackage != null) {
            request.setAttribute("studyPackageDetail", studyPackage);
            request.getRequestDispatcher("/studypackage/studyPackageDetail.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy gói học với ID: " + id);
            listStudyPackage(request, response);
        }
    } catch (NumberFormatException e) {
        request.setAttribute("errorMessage", "Định dạng ID không hợp lệ!");
        listStudyPackage(request, response);
    }
}


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
