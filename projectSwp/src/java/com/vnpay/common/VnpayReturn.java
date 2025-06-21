package com.vnpay.common;

import dal.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import model.Invoice;

/**
 *
 * @author VNPay
 */
@WebServlet(name = "VnpayReturn", urlPatterns = {"/vnpayReturn"})
public class VnpayReturn extends HttpServlet {
    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Lấy thông tin từ VNPay trả về và xác thực
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }
            
            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            
            // Xác thực hash
            String signValue = Config.hashAllFields(fields);
            if (signValue.equals(vnp_SecureHash)) {
                // Giao dịch hợp lệ
                String orderId = request.getParameter("vnp_TxnRef");
                int invoiceId = Integer.parseInt(orderId);
                
                System.out.println("===== VNPAY RETURN DEBUG =====");
                System.out.println("Invoice ID: " + invoiceId);
                System.out.println("Response Code: " + request.getParameter("vnp_ResponseCode"));
                
                // Cập nhật trạng thái invoice
                Invoice invoice = new Invoice();
                invoice.setId(invoiceId);
                
                boolean transSuccess = false;
                if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                    // Giao dịch thành công
                    System.out.println("Transaction successful! Setting status to Completed");
                    invoice.setStatus("Completed");
                    invoice.setPay_at(LocalDate.now());
                    transSuccess = true;
                    
                    // Lấy packageId từ session và thêm vào bảng invoice_line
                    HttpSession session = request.getSession();
                    Integer packageId = (Integer) session.getAttribute("packageId");
                    System.out.println("Package ID from session: " + packageId);
                    
                    if (packageId != null) {
                        try {
                            invoiceDAO.insertInvoiceLine(invoiceId, packageId);
                            System.out.println("Invoice line inserted successfully");
                        } catch (Exception e) {
                            System.out.println("Error inserting invoice line: " + e.getMessage());
                            e.printStackTrace();
                        }
                    } else {
                        // Nếu packageId không có trong session, thử lấy từ tham số request
                        System.out.println("Package ID not found in session, trying to get from request parameters or invoice data");
                        String vnpOrderInfo = request.getParameter("vnp_OrderInfo");
                        if (vnpOrderInfo != null && vnpOrderInfo.contains("goi hoc")) {
                            try {
                                // Lấy chi tiết hóa đơn từ database nếu có thể
                                // Hoặc có thể gửi packageId qua URL khi redirect từ VNPay
                                System.out.println("Order info from VNPay: " + vnpOrderInfo);
                                // Xử lý tiếp tùy theo logic ứng dụng
                            } catch (Exception e) {
                                System.out.println("Error parsing package ID from order info: " + e.getMessage());
                            }
                        }
                    }
                } else {
                    // Giao dịch thất bại
                    System.out.println("Transaction failed! Setting status to Failed");
                    invoice.setStatus("Failed");
                }
                
                // Cập nhật invoice
                try {
                    invoiceDAO.updateInvoiceStatus(invoice);
                    System.out.println("Invoice status updated to: " + invoice.getStatus());
                    
                    // Kiểm tra sau khi cập nhật
                    Invoice updatedInvoice = invoiceDAO.getInvoiceById(invoiceId);
                    if (updatedInvoice != null) {
                        System.out.println("Invoice after update - ID: " + updatedInvoice.getId() + 
                                          ", Status: " + updatedInvoice.getStatus() + 
                                          ", PayDate: " + updatedInvoice.getPay_at());
                        
                        // Kiểm tra nếu trạng thái vẫn là Pending
                        if ("Pending".equals(updatedInvoice.getStatus())) {
                            System.out.println("ERROR: Invoice status is still Pending after update!");
                            // Thử cập nhật lại một lần nữa
                            invoice.setStatus("Completed");
                            invoice.setPay_at(LocalDate.now());
                            invoiceDAO.updateInvoiceStatus(invoice);
                            
                            // Kiểm tra lại
                            updatedInvoice = invoiceDAO.getInvoiceById(invoiceId);
                            System.out.println("After second update - Status: " + updatedInvoice.getStatus());
                        }
                    } else {
                        System.out.println("ERROR: Could not find invoice after update!");
                    }
                } catch (Exception e) {
                    System.out.println("Error updating invoice status: " + e.getMessage());
                    e.printStackTrace();
                }
                System.out.println("===== VNPAY RETURN DEBUG END =====");
                
                // Chuyển đến trang kết quả
                request.setAttribute("transResult", transSuccess);
                request.getRequestDispatcher("/studypackage/paymentResult.jsp").forward(request, response);
            } else {
                // Giao dịch không hợp lệ
                System.out.println("Invalid transaction (invalid signature)");
                request.setAttribute("transResult", false);
                request.getRequestDispatcher("/studypackage/paymentResult.jsp").forward(request, response);
            }
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