/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.payment;
import com.vnpay.common.Config;
import dal.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import model.Invoice;
/**
 *
 * @author ledai
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/payment"})
public class PaymentController extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        // Lấy thông tin từ request
        String packageIdStr = req.getParameter("packageId");
        String amountStr = req.getParameter("amount");
        
        if (packageIdStr == null || amountStr == null) {
            resp.sendRedirect("study_package");
            return;
        }
        
        int packageId = Integer.parseInt(packageIdStr);
        double amountDouble = Double.parseDouble(amountStr);
        
        // Tạo Invoice với trạng thái "Pending"
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice invoice = new Invoice();
        invoice.setTotal_amount(amountStr);
        
        // Lấy parent_id từ session thay vì sử dụng giá trị cố định
        int parentId = 1; // Giá trị mặc định nếu không tìm thấy trong session
        HttpSession session = req.getSession();
        Object accountObj = session.getAttribute("account");
        if (accountObj instanceof model.Account) {
            model.Account account = (model.Account) accountObj;
            if (account.getRole() != null && account.getRole().equalsIgnoreCase("parent")) {
                parentId = account.getId();
            }
        }
        invoice.setParent_id(parentId);
        
        invoice.setCreated_at(LocalDate.now());
        invoice.setStatus("Pending");
        
        int invoiceId = invoiceDAO.insertInvoice(invoice);
        
        if (invoiceId < 1) {
            resp.sendRedirect("study_package");
            return;
        }
        
        // Tạo các tham số VNPay
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String orderType = "other";
        
        // Số tiền thanh toán (nhân 100 theo yêu cầu của VNPay)
        long amount = (long) (amountDouble * 100);
        String vnp_TxnRef = invoiceId + "";
        String vnp_IpAddr = Config.getIpAddress(req);
        String vnp_TmnCode = Config.vnp_TmnCode;
        
        // Xây dựng Map các tham số
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan goi hoc:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        
        // Tạo thời gian giao dịch
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        // Thời gian hết hạn (15 phút)
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        
        // Tạo chuỗi hash và URL thanh toán
        String queryUrl = createPaymentUrl(vnp_Params);
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
        
        // Lưu thông tin package vào session để xử lý sau khi thanh toán
        session.setAttribute("packageId", packageId);
        session.setAttribute("invoiceId", invoiceId);
        
        // Chuyển hướng đến cổng thanh toán
        resp.sendRedirect(paymentUrl);
    }
    
    private String createPaymentUrl(Map<String, String> vnp_Params) {
        try {
            // Sắp xếp và tạo URL với hash
            List fieldNames = new ArrayList(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = (String) vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    // Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    // Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            String queryUrl = query.toString();
            String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            return queryUrl;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
    
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Payment Controller for VNPay Integration";
    }
} 