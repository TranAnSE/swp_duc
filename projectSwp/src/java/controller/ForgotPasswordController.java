package controller;

import at.favre.lib.crypto.bcrypt.BCrypt;
import config.PasswordUtil;
import dal.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import model.Account;

/**
 *
 * @author BuiNgocLinh
 */
@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();
    private final PasswordUtil passwordUtil = new PasswordUtil();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            // Show forgot password form
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        if ("verify".equals(action)) {
            String hashedOtp = request.getParameter("code");
            if (hashedOtp == null || hashedOtp.isEmpty()) {
                request.setAttribute("error", "Invalid verification link");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Get OTP from cookie
            String otp = getOtpFromCookie(request);
            if (otp == null) {
                request.setAttribute("error", "OTP has expired or not found");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Verify OTP hash
            if (BCrypt.verifyer().verify(otp.toCharArray(), hashedOtp).verified) {
                // OTP verified, allow password reset
                request.setAttribute("email", request.getParameter("email"));
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Invalid verification code");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            // Process forgot password form
            String email = request.getParameter("email");
            StringBuilder logMessages = new StringBuilder();
            
            try {
                logMessages.append("Processing forgot password for email: " + email + "\\n");
                System.out.println("Processing forgot password for email: " + email);
                
                // Check if email exists
                boolean emailExists = accountDAO.existEmail(email);
                logMessages.append("Email exists in database: " + emailExists + "\\n");
                System.out.println("Email exists in database: " + emailExists);
                
                if (!emailExists) {
                    request.setAttribute("error", "Email not found in our system");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                    return;
                }
                
                // Generate OTP
                String otp = generateOTP();
                logMessages.append("Generated OTP: " + otp + "\\n");
                System.out.println("Generated OTP: " + otp);
                
                // Store OTP in cookie with expiration time
                storeOtpInCookie(response, otp);
                logMessages.append("OTP stored in cookie\\n");
                System.out.println("OTP stored in cookie");
                
                // Hash OTP for link
                String hashedOtp = BCrypt.withDefaults().hashToString(10, otp.toCharArray());
                logMessages.append("Hashed OTP: " + hashedOtp + "\\n");
                System.out.println("Hashed OTP: " + hashedOtp);
                
                String resetLink = "";
                try {
                    // Send email with reset link
                    sendResetPasswordEmail(email, hashedOtp, request);
                    logMessages.append("Email sent successfully\\n");
                    System.out.println("Email sent successfully");
                } catch (Exception e) {
                    // Ghi log lỗi gửi email nhưng vẫn cho phép tiếp tục quy trình
                    logMessages.append("Error sending email: " + e.getMessage() + "\\n");
                    System.out.println("Error sending email: " + e.getMessage());
                    e.printStackTrace();
                    
                    // Hiển thị link trực tiếp trong console để có thể test
                    String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + 
                            request.getServerPort() + request.getContextPath();
                    resetLink = baseUrl + "/forgot-password?action=verify&code=" + hashedOtp + "&email=" + email;
                    
                    logMessages.append("============================================================\\n");
                    logMessages.append("RESET PASSWORD LINK (Copy this to your browser to test):\\n");
                    logMessages.append(resetLink + "\\n");
                    logMessages.append("============================================================\\n");
                    
                    System.out.println("============================================================");
                    System.out.println("RESET PASSWORD LINK (Copy this to your browser to test):");
                    System.out.println(resetLink);
                    System.out.println("============================================================");
                }
                
                // Thêm script để hiển thị link trong console của trình duyệt
                if (!resetLink.isEmpty()) {
                    request.setAttribute("consoleScript", 
                        "<script>\n" +
                        "console.log('============================================================');\n" +
                        "console.log('RESET PASSWORD LINK (Copy this to your browser to test):');\n" +
                        "console.log('" + resetLink + "');\n" +
                        "console.log('============================================================');\n" +
                        "console.log('" + logMessages.toString().replace("'", "\\'") + "');\n" +
                        "</script>"
                    );
                } else {
                    request.setAttribute("consoleScript", 
                        "<script>\n" +
                        "console.log('" + logMessages.toString().replace("'", "\\'") + "');\n" +
                        "</script>"
                    );
                }
                
                // Show success message
                request.setAttribute("success", "Password reset link has been sent. Please check your email or browser console for link.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error in forgot password process: " + e.getMessage());
                logMessages.append("Error in forgot password process: " + e.getMessage() + "\\n");
                e.printStackTrace();
                
                request.setAttribute("consoleScript", 
                    "<script>\n" +
                    "console.log('" + logMessages.toString().replace("'", "\\'") + "');\n" +
                    "console.error('Error: " + e.getMessage().replace("'", "\\'") + "');\n" +
                    "</script>"
                );
                
                request.setAttribute("error", "An error occurred. Please check browser console for details.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            }
        } else if ("reset".equals(action)) {
            // Process password reset form
            String email = request.getParameter("email");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");
            
            // Validate passwords
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.setAttribute("email", email);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            
            StringBuilder logMessages = new StringBuilder();
            try {
                logMessages.append("Processing password reset for email: " + email + "\\n");
                System.out.println("Processing password reset for email: " + email);
                
                // Get account by email
                Account account = accountDAO.selectByAccount(email);
                if (account != null) {
                    // Update password
                    account.setPassword(newPassword);
                    accountDAO.update(account);
                    logMessages.append("Password updated successfully\\n");
                    System.out.println("Password updated successfully");
                    
                    // Clear OTP cookie
                    clearOtpCookie(response);
                    logMessages.append("OTP cookie cleared\\n");
                    System.out.println("OTP cookie cleared");
                    
                    // Thêm script console log trước khi redirect
                    request.setAttribute("consoleScript", 
                        "<script>\n" +
                        "console.log('" + logMessages.toString().replace("'", "\\'") + "');\n" +
                        "setTimeout(function() { window.location.href = 'login?message=Password has been reset successfully'; }, 1000);\n" +
                        "</script>"
                    );
                    request.setAttribute("success", "Password has been reset successfully. Redirecting to login page...");
                    request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                } else {
                    logMessages.append("Account not found for email: " + email + "\\n");
                    System.out.println("Account not found for email: " + email);
                    
                    request.setAttribute("consoleScript", 
                        "<script>\n" +
                        "console.log('" + logMessages.toString().replace("'", "\\'") + "');\n" +
                        "</script>"
                    );
                    
                    request.setAttribute("error", "Account not found");
                    request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                }
            } catch (Exception e) {
                logMessages.append("Error in password reset process: " + e.getMessage() + "\\n");
                System.out.println("Error in password reset process: " + e.getMessage());
                e.printStackTrace();
                
                request.setAttribute("consoleScript", 
                    "<script>\n" +
                    "console.log('" + logMessages.toString().replace("'", "\\'") + "');\n" +
                    "console.error('Error: " + e.getMessage().replace("'", "\\'") + "');\n" +
                    "</script>"
                );
                
                request.setAttribute("error", "An error occurred. Please check browser console for details.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
        }
    }
    
    private String generateOTP() {
        // Generate a 6-digit OTP
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private void storeOtpInCookie(HttpServletResponse response, String otp) {
        // Store OTP in cookie with 15 minutes expiration
        Cookie otpCookie = new Cookie("reset_otp", otp);
        otpCookie.setMaxAge(15 * 60); // 15 minutes
        otpCookie.setHttpOnly(true); // For security
        response.addCookie(otpCookie);
    }
    
    private String getOtpFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("reset_otp".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
    
    private void clearOtpCookie(HttpServletResponse response) {
        Cookie otpCookie = new Cookie("reset_otp", "");
        otpCookie.setMaxAge(0); // Delete cookie
        response.addCookie(otpCookie);
    }
    
    private void sendResetPasswordEmail(String email, String hashedOtp, HttpServletRequest request) {
        // Cập nhật thông tin email của bạn
        final String username = "ngoclinhh29@gmail.com";
        final String password = "dzzy clae jmts huij";   // App Password bạn đã tạo
        
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        
        Session session = Session.getInstance(props,
            new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });
        
        try {
            // Create reset link with hashed OTP
            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + 
                    request.getServerPort() + request.getContextPath();
            String resetLink = baseUrl + "/forgot-password?action=verify&code=" + hashedOtp + "&email=" + email;
            
            // Create email message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Password Reset Request");
            
            String emailContent = "Dear User,<br><br>"
                    + "You have requested to reset your password. Please click the link below to reset your password:<br><br>"
                    + "<a href=\"" + resetLink + "\">Reset Password</a><br><br>"
                    + "This link will expire in 15 minutes.<br><br>"
                    + "If you did not request a password reset, please ignore this email.<br><br>"
                    + "Best regards,<br>"
                    + "Support Team";
            
            message.setContent(emailContent, "text/html");
            
            // Send email
            Transport.send(message);
            
        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to send password reset email", e);
        }
    }
}