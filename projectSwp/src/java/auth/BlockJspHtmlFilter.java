/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package auth;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import util.RoleConstants;

import java.io.IOException;

@WebFilter("*.jsp")
public class BlockJspHtmlFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();

        HttpSession session = req.getSession(false);
        Account user = (session != null) ? (Account) session.getAttribute("account") : null;

        if (uri.contains("admin/") && (user == null || !user.getRole().equals(RoleConstants.ADMIN))) {
            res.sendRedirect("/error.jsp");
            return;
        }

        if (uri.contains("teacher/") && (user == null
                || !(user.getRole().equals(RoleConstants.TEACHER) || user.getRole().equals(RoleConstants.ADMIN)))) {
            res.sendRedirect("/error.jsp");
            return;
        }

        if (uri.contains("parent/") && (user == null || !user.getRole().equals(RoleConstants.PARENT))) {
            res.sendRedirect("/error.jsp");
            return;
        }

        if (uri.contains("student/")) {
            Object studentObj = session.getAttribute("student");
            if (!(studentObj instanceof model.Student)) {
                res.sendRedirect("/error.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
