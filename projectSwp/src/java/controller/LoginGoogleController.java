/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import config.GoogleLogin;
import dal.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Account;
import model.GoogleAccount;

/**
 *
 * @author BuiNgocLinh
 */
@WebServlet(name = "LoginGoogleController", urlPatterns = {"/logingoogle"})
public class LoginGoogleController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginGoogle</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginGoogle at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        String code = request.getParameter("code");
        String accessToken = GoogleLogin.getToken(code);
        GoogleAccount account = GoogleLogin.getUserInfo(accessToken);
        String email = null;
        if (account != null) {
            email = account.getEmail();
        }
        if (account != null) {
            AccountDAO accountDAO = new AccountDAO();
            if (accountDAO.existEmail(email)) {
                Account account1 = accountDAO.selectByAccount(email);
                if (account1.getStatus().equalsIgnoreCase("ACTIVE")) {
                    request.getSession().setAttribute("account", account1);
                    redirectBasedOnRole(response, request, account1.getRole());
                }
            } else {
                request.setAttribute("error", "Email or Account not exist!");
                request.getRequestDispatcher("login").forward(request, response);
            }
        }
    }

    private void redirectBasedOnRole(HttpServletResponse response, HttpServletRequest request, String role) throws IOException {
        switch (role) {
            case "admin":
                redirectToPage(response, request, "/admin");
                break;
            case "teacher":
                redirectToPage(response, request, "/teacher/home.jsp");
                break;
            case "parent":
                redirectToPage(response, request, "/parent/home.jsp");
                break;
//            case "student":
//                redirectToPage(response, request, "/student/home.jsp");
//                break;
            default:
                redirectToPage(response, request, "error-403");
                break;
        }
    }

    private void redirectToPage(HttpServletResponse response, HttpServletRequest request, String page) throws IOException {
        response.sendRedirect(request.getContextPath() + page);
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
