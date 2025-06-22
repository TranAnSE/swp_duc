/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.AccountDAO;
import dal.StudentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Student;

/**
 *
 * @author BuiNgocLinh
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        req.getRequestDispatcher("login.jsp").forward(req, resp);
//    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        loadCookies(request);
        request.getRequestDispatcher("login.jsp").forward(request, response);
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
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember_me");

        handleCookies(response, email, password, remember, userType);
        handleLogin(request, response, userType, email, username, password);
    }

    private void handleCookies(HttpServletResponse response, String email, String password, String remember, String userType) {
        Cookie[] cookies = {
            new Cookie("email", email),
            new Cookie("password", password),
            new Cookie("remember", remember),
            new Cookie("userType", userType)
        };

        int maxAge = (remember != null) ? 60 * 60 * 24 * 365 : 0; // 1 năm nếu remember được chọn, ngược lại xóa cookie
        for (Cookie cookie : cookies) {
            cookie.setMaxAge(maxAge);
            response.addCookie(cookie);
        }
    }

    private void loadCookies(HttpServletRequest request) {
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            switch (cookie.getName()) {
                case "email":
                    request.setAttribute("email", cookie.getValue());
                    break;
                case "username":
                    request.setAttribute("username", cookie.getValue());
                    break;
                case "password":
                    request.setAttribute("password", cookie.getValue());
                    break;
                case "remember":
                    request.setAttribute("remember", cookie.getValue());
                    break;
                case "userType":
                    request.setAttribute("userType", cookie.getValue());
                    break;
            }
        }
    }
}

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, String userType, String email, String username, String password)
            throws ServletException, IOException {
        AccountDAO accountDAO = new AccountDAO();
        StudentDAO studentDAO = new StudentDAO();
        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(600);

        if ("admin".equalsIgnoreCase(userType)
                || "teacher".equalsIgnoreCase(userType)
                || "parent".equalsIgnoreCase(userType)) {
            Account account = accountDAO.checkLogin(email, password);
            if (account != null && account.getRole().equalsIgnoreCase(userType)) {
                session.setAttribute("account", account);
                session.setAttribute("role", account.getRole());

//                if (password.length() == 5) {
//                    response.sendRedirect(request.getContextPath() + "/changePassword");
//                    return;
//                }

                redirectBasedOnRole(response, request, account.getRole());
                return;
            }
        } else if ("student".equalsIgnoreCase(userType)) {
            Student student = studentDAO.checkLogin(username, password);
            if (student != null) {
                session.setAttribute("student", student);
                session.setAttribute("role", "student");

//                if (password.length() == 5) {
//                    response.sendRedirect(request.getContextPath() + "/changePassword");
//                    return;
//                }

                redirectBasedOnRole(response, request, "student");
                return;
            }
        }

        handleLoginFailure(request, response, userType, email, password);
    }

    private void redirectBasedOnRole(HttpServletResponse response, HttpServletRequest request, String role) throws IOException {
        switch (role) {
            case "admin":
                redirectToPage(response, request, "/admin?action=dashboard");
                break;
            case "teacher":
                redirectToPage(response, request, "/admin?action=teacherDashboard");
                break;
            case "parent":
                redirectToPage(response, request, "/admin?action=parentDashboard");
                break;
            case "student":
                redirectToPage(response, request, "/admin?action=studentDashboard");
                break;
            default:
                redirectToPage(response, request, "error-403");
                break;
        }
    }

    private void redirectToPage(HttpServletResponse response, HttpServletRequest request, String page) throws IOException {
        response.sendRedirect(request.getContextPath() + page);
    }

    private void handleLoginFailure(HttpServletRequest request, HttpServletResponse response, String userType, String email, String password)
            throws ServletException, IOException {
        request.setAttribute("userType", userType);
        request.setAttribute("email", email);
        request.setAttribute("password", password);
        request.setAttribute("error", "Email or Password fail");
        request.getRequestDispatcher("login.jsp").forward(request, response);
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
