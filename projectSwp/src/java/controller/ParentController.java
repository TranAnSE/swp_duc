package controller;

import dal.AccountDAO;
import dal.GradeDAO;
import dal.ImageDAO;
import dal.StudentDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Grade;
import model.Image;
import model.Student;
import util.AuthUtil;
import util.RoleConstants;

@WebServlet("/parent")
public class ParentController extends HttpServlet {
    
    private StudentDAO studentDAO = new StudentDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private GradeDAO gradeDAO = new GradeDAO();
    private ImageDAO imageDAO = new ImageDAO(accountDAO.getConnection());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is parent
        if (!AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "myChildren";
        }
        
        try {
            switch (action) {
                case "myChildren":
                    showMyChildren(request, response);
                    break;
                default:
                    showMyChildren(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private void showMyChildren(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account parent = (Account) session.getAttribute("account");
        
        if (parent == null) {
            response.sendRedirect("/login");
            return;
        }
        
        // Get children of this parent
        List<Student> children = studentDAO.getStudentsByParentId(parent.getId());
        
        // Get supporting data
        List<Grade> gradeList = gradeDAO.findAllFromGrade();
        List<Image> imageList = imageDAO.findAll();
        
        // Set attributes
        request.setAttribute("children", children);
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("imageList", imageList);
        request.setAttribute("parent", parent);
        
        // Forward to JSP
        request.getRequestDispatcher("/parent/myChildren.jsp").forward(request, response);
    }
} 