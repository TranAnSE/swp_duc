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

                // Check for pending purchase in session
                Integer packageId = (Integer) session.getAttribute("pendingPurchase_packageId");
                Integer studentId = (Integer) session.getAttribute("pendingPurchase_studentId");
                Integer parentId = (Integer) session.getAttribute("pendingPurchase_parentId");
                Integer durationDays = (Integer) session.getAttribute("pendingPurchase_durationDays");

                if (packageId != null && studentId != null && parentId != null && durationDays != null && account != null) {
                    StudyPackageDAO studyPackageDAO = new StudyPackageDAO();
                    StudyPackage studyPackage = studyPackageDAO.findStudyPackageById(packageId);

                    if (studyPackage != null) {
                        // Assign package to the selected student
                        boolean assigned = studentPackageDAO.assignPackageToStudent(
                                studentId,
                                packageId,
                                parentId,
                                durationDays
                        );

                        if (assigned) {
                            // Update invoice with student assignment
                            invoiceDAO.updateInvoiceLineWithStudent(invoiceId, studentId);

                            // Clear pending purchase from session
                            session.removeAttribute("pendingPurchase_packageId");
                            session.removeAttribute("pendingPurchase_studentId");
                            session.removeAttribute("pendingPurchase_parentId");
                            session.removeAttribute("pendingPurchase_durationDays");

                            request.setAttribute("message", "Payment successful! Study package has been assigned to the selected student.");
                            request.setAttribute("packageName", studyPackage.getName());
                            request.setAttribute("studentCount", 1);
                        } else {
                            request.setAttribute("errorMessage", "Payment was successful but there was an error assigning the package. Please contact support.");
                        }
                    } else {
                        request.setAttribute("errorMessage", "Payment was successful but package not found. Please contact support.");
                    }
                } else {
                    // Fallback to old logic for backward compatibility
                    String[] studentIds = (String[]) session.getAttribute("selectedStudentIds");
                    if (studentIds != null && studentIds.length > 0 && account != null) {
                        // Existing logic for multiple students...
                        int packageIdFromInvoice = getPackageIdFromInvoice(invoiceId);
                        StudyPackageDAO studyPackageDAO = new StudyPackageDAO();
                        StudyPackage studyPackage = studyPackageDAO.findStudyPackageById(packageIdFromInvoice);

                        if (studyPackage != null) {
                            for (String studentIdStr : studentIds) {
                                int studentIdInt = Integer.parseInt(studentIdStr);
                                boolean assigned = studentPackageDAO.assignPackageToStudent(
                                        studentIdInt,
                                        packageIdFromInvoice,
                                        account.getId(),
                                        studyPackage.getDuration_days()
                                );

                                if (!assigned) {
                                    System.err.println("Failed to assign package " + packageIdFromInvoice + " to student " + studentIdInt);
                                }
                            }

                            updateInvoiceWithStudents(invoiceId, studentIds);
                            session.removeAttribute("selectedStudentIds");

                            request.setAttribute("message", "Payment successful! Study package has been assigned to selected students.");
                            request.setAttribute("packageName", studyPackage.getName());
                            request.setAttribute("studentCount", studentIds.length);
                        }
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Payment was successful but there was an error assigning the package. Please contact support.");
            }

        } else {
            // Payment failed - clear pending purchase
            session.removeAttribute("pendingPurchase_packageId");
            session.removeAttribute("pendingPurchase_studentId");
            session.removeAttribute("pendingPurchase_parentId");
            session.removeAttribute("pendingPurchase_durationDays");

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
