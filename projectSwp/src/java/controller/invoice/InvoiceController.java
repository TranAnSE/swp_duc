/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.invoice;

import dal.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Invoice;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import util.AuthUtil;
import util.RoleConstants;

@WebServlet(name = "InvoiceController", urlPatterns = {"/invoice"})
public class InvoiceController extends HttpServlet {

    private InvoiceDAO invoiceDAO;

    @Override
    public void init() {
        invoiceDAO = new InvoiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.PARENT) && !AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            invoiceDAO.deleteInvoice(id);
            response.sendRedirect("invoice");
            return;
        }

        if ("create".equals(action)) {
            // Chuyển đến trang thêm hóa đơn
            request.getRequestDispatcher("Invoice/addInvoice.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Invoice invoice = invoiceDAO.getInvoiceById(id);
            if (invoice != null) {
                request.setAttribute("invoice", invoice);
                request.getRequestDispatcher("Invoice/editInvoice.jsp").forward(request, response);
            } else {
                // Không tìm thấy hóa đơn, chuyển về danh sách hoặc báo lỗi
                response.sendRedirect("invoice");
            }
            return;
        }

        // Mặc định hiển thị danh sách
        List<Invoice> invoices = invoiceDAO.getAllInvoices();
        request.setAttribute("invoices", invoices);
        request.getRequestDispatcher("Invoice/listInvoices.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.PARENT)) { // chỉ phụ huynh thực hiện thanh toán
            response.sendRedirect("/error.jsp");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        String totalAmount = request.getParameter("total_amount");
        int parentId = Integer.parseInt(request.getParameter("parent_id"));
        LocalDate createdAt = LocalDate.parse(request.getParameter("created_at"));
        String status = request.getParameter("status");
        String payAtParam = request.getParameter("pay_at");
        LocalDate payAt = (payAtParam == null || payAtParam.isEmpty()) ? null : LocalDate.parse(payAtParam);

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Invoice invoice = new Invoice(id, totalAmount, parentId, createdAt, status, payAt);
            invoiceDAO.updateInvoice(invoice);
        } else if ("insert".equals(action)) {
            Invoice invoice = new Invoice(0, totalAmount, parentId, createdAt, status, payAt);
            invoiceDAO.insertInvoice(invoice);
        }

        response.sendRedirect("invoice");
    }
}
