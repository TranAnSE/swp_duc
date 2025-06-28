/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.payment;

import dal.InvoiceDAO;
import dal.StudentPackageDAO;
import dal.StudyPackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import model.Account;
import model.StudyPackage;

/**
 *
 * @author ankha
 */
@WebServlet(name = "PaymentResultController", urlPatterns = {"/payment-result"})
public class PaymentResultController extends HttpServlet {

    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private StudentPackageDAO studentPackageDAO = new StudentPackageDAO();
    private StudyPackageDAO studyPackageDAO = new StudyPackageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if ("00".equals(vnp_ResponseCode)) {
            // Payment successful
            try {
                // Get invoice details
                int invoiceId = Integer.parseInt(vnp_TxnRef);

                // Get selected student IDs from session
                String[] studentIds = (String[]) session.getAttribute("selectedStudentIds");

                if (studentIds != null && studentIds.length > 0 && account != null) {
                    // Get package ID from invoice
                    int packageId = getPackageIdFromInvoice(invoiceId);
                    StudyPackage studyPackage = studyPackageDAO.findStudyPackageById(packageId);

                    if (studyPackage != null) {
                        // Assign package to each selected student
                        for (String studentIdStr : studentIds) {
                            int studentId = Integer.parseInt(studentIdStr);
                            boolean assigned = studentPackageDAO.assignPackageToStudent(
                                    studentId,
                                    packageId,
                                    account.getId(),
                                    studyPackage.getDuration_days()
                            );

                            if (!assigned) {
                                // Log error but continue with other students
                                System.err.println("Failed to assign package " + packageId + " to student " + studentId);
                            }
                        }

                        // Update invoice with student assignments
                        updateInvoiceWithStudents(invoiceId, studentIds);

                        // Clear session data
                        session.removeAttribute("selectedStudentIds");

                        request.setAttribute("message", "Payment successful! Study package has been assigned to selected students.");
                        request.setAttribute("packageName", studyPackage.getName());
                        request.setAttribute("studentCount", studentIds.length);
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Payment was successful but there was an error assigning the package. Please contact support.");
            }

        } else {
            // Payment failed
            request.setAttribute("errorMessage", "Payment failed. Please try again.");
        }

        request.getRequestDispatcher("/payment/result.jsp").forward(request, response);
    }

    private int getPackageIdFromInvoice(int invoiceId) {
        // Implementation to get package ID from invoice
        // This depends on your invoice structure
        try {
            // Assuming you have a method in InvoiceDAO to get invoice details
            return invoiceDAO.getPackageIdByInvoiceId(invoiceId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private void updateInvoiceWithStudents(int invoiceId, String[] studentIds) {
        // Update invoice_line table with student assignments
        try {
            for (String studentIdStr : studentIds) {
                int studentId = Integer.parseInt(studentIdStr);
                invoiceDAO.updateInvoiceLineWithStudent(invoiceId, studentId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
