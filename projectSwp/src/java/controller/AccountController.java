/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.AccountDAO;
import dal.ImageDAO;
import config.FileUploadUlti;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.Image;
import dal.DashboardDAO;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author BuiNgocLinh
 */
@MultipartConfig
@WebServlet(name = "AccountController", urlPatterns = {"/admin"})
public class AccountController extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();
    private ImageDAO ImageDAO = new ImageDAO(accountDAO.getConnection());
    private DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            List<Account> accountList = null;
            try {
                accountList = accountDAO.findAll();
            } catch (SQLException ex) {
                Logger.getLogger(AccountController.class.getName()).log(Level.SEVERE, null, ex);
            }
            request.setAttribute("accountList", accountList);
            request.getRequestDispatcher("/admin/home.jsp").forward(request, response);
            return;
        }

        try {
            switch (action) {
                case "listAccount":
                    listAccounts(request, response);
                    break;
                case "viewProfile":
                    viewProfile(request, response);
                    break;
                case "createAccount":
                    showCreateForm(request, response);
                    break;
                case "editAccount":
                    showEditForm(request, response);
                    break;
                case "deleteAccount":
                    deleteAccount(request, response);
                    break;
                case "searchAccount":
                    searchAccount(request, response);
                    break;
                case "dashboard":
                    showDashboard(request, response);
                    break;
                case "teacherDashboard":
                    showTeacherDashboard(request, response);
                    break;
                default:
                    response.sendRedirect("/index.html");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("admin");
            return;
        }
        try {
            switch (action) {
                case "createAccount":
                    insertAccount(request, response);
                    break;
                case "editAccount":
                    updateAccount(request, response);
                    break;
                case "changePassword":
                    changePassword(request, response);
                    break;
                default:
                    response.sendRedirect("admin");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int page = 1;
        int recordsPerPage = 5;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;

        List<Account> accountList = accountDAO.getAccountsByPage(offset, recordsPerPage);
        int totalRecords = accountDAO.countAccounts();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        List<Image> imageList = ImageDAO.findAll();
        request.setAttribute("accountList", accountList);
        request.setAttribute("imageList", imageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/accountList.jsp").forward(request, response);
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Image> imageList = ImageDAO.findAll();
        int id = Integer.parseInt(request.getParameter("id"));
        Account accountView = accountDAO.viewProfile(id);
        request.setAttribute("imageList", imageList);
        request.setAttribute("view", accountView);
        request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/insertAccount.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Account account = accountDAO.findById(id);
        Image image = ImageDAO.findImageById(account.getImage_id());
        request.setAttribute("account", account);
        request.setAttribute("image", image);
        request.getRequestDispatcher("/accountForm.jsp").forward(request, response);
    }

    private void insertAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        Account account = getAccountFromRequest(request);
        String avatarName = "avatar_" + System.currentTimeMillis();

        String imgURL = FileUploadUlti.uploadAvatarImage(request, avatarName);

        if (imgURL != null) {
            Image image = new Image();
            image.setImage_data(imgURL);

            ImageDAO imageDAO = new ImageDAO(accountDAO.getConnection());
            int imageId = imageDAO.insertImage(image);
            if (imageId > 0) {
                account.setImage_id(imageId);
            }
        }
        boolean inserted = accountDAO.insert(account);
        if (inserted) {
            response.sendRedirect("admin?action=listAccount");
        } else {
            request.setAttribute("error", "Failed to insert account");
            request.getRequestDispatcher("/insertAccount.jsp").forward(request, response);
        }
    }

    private void updateAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        Account oldAccount = accountDAO.findById(Integer.parseInt(request.getParameter("id")));
        Account account = getAccountFromRequest(request);
        String avatarName = "avatar_" + System.currentTimeMillis();
        String imgURL = FileUploadUlti.uploadAvatarImage(request, avatarName);

        // Validate old password if provided (edit mode)
        String oldPassword = request.getParameter("oldPassword");
        if (oldPassword != null && !oldPassword.isEmpty()) {
            if (!accountDAO.validatePassword(oldAccount, oldPassword)) {
                request.setAttribute("passwordError", "Current password is incorrect");
                Image image = ImageDAO.findImageById(oldAccount.getImage_id());
                request.setAttribute("account", oldAccount);
                request.setAttribute("image", image);
                request.getRequestDispatcher("/accountForm.jsp").forward(request, response);
                return;
            }
        }

        if (imgURL != null) {
            Image image = new Image();
            image.setImage_data(imgURL);

            ImageDAO imageDAO = new ImageDAO(accountDAO.getConnection());
            int imageId = imageDAO.insertImage(image);
            if (imageId > 0) {
                account.setImage_id(imageId);
            } else {
                account.setImage_id(oldAccount.getImage_id());
            }
        } else {
            account.setImage_id(oldAccount.getImage_id());
        }

        // If new password is empty, keep the old password
        String newPassword = request.getParameter("password");
        if (newPassword == null || newPassword.isEmpty()) {
            account.setPassword(oldAccount.getPassword());
        }

        accountDAO.update(account);
        response.sendRedirect("admin?action=viewProfile&id=" + account.getId());
    }

    private void deleteAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
//        accountDAO.deleteAccount(id);
        response.sendRedirect("/accountList.jsp");
    }

    private void searchAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String email = request.getParameter("email");
        List<Account> accountList;
        if (email != null && !email.trim().isEmpty()) {
            accountList = accountDAO.findByEmail(email.trim());
            if (accountList == null || accountList.isEmpty()) {
                request.setAttribute("error", "Nothing " + email.trim());
            }
        } else {
            accountList = accountDAO.findAll();
        }
        List<Image> imageList = ImageDAO.findAll();
        request.setAttribute("imageList", imageList);
        request.setAttribute("accountList", accountList);
        request.getRequestDispatcher("/accountList.jsp").forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        Account account = accountDAO.findById(id);
        if (account == null) {
            request.setAttribute("passwordError", "Account not found.");
            List<Image> imageList = ImageDAO.findAll();
            request.setAttribute("imageList", imageList);
            request.setAttribute("view", account);
            request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
            return;
        } else if (!accountDAO.validatePassword(account, oldPassword)) {
            request.setAttribute("passwordError", "Current password is incorrect.");
            List<Image> imageList = ImageDAO.findAll();
            request.setAttribute("imageList", imageList);
            request.setAttribute("view", account);
            request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
            return;
        } else if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("passwordError", "New password must be at least 6 characters.");
            List<Image> imageList = ImageDAO.findAll();
            request.setAttribute("imageList", imageList);
            request.setAttribute("view", account);
            request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
            return;
        } else {
            account.setPassword(newPassword);
            accountDAO.update(account);
            request.setAttribute("passwordSuccess", "Password changed successfully.");
            List<Image> imageList = ImageDAO.findAll();
            request.setAttribute("imageList", imageList);
            request.setAttribute("view", account);
            request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
        }
    }

    private Account getAccountFromRequest(HttpServletRequest request) {
        String idStr = request.getParameter("id");
        int id = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : 0;
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String status = request.getParameter("status");
        String role = request.getParameter("role");
        String fullName = request.getParameter("full_name");
        Integer sex = (request.getParameter("sex") != null && !request.getParameter("sex").isEmpty())
                ? Integer.parseInt(request.getParameter("sex")) : null;
        String dobStr = request.getParameter("dob");
        LocalDate dob = (dobStr != null && !dobStr.isEmpty()) ? LocalDate.parse(dobStr) : null;
        Integer imageId = (request.getParameter("image_id") != null && !request.getParameter("image_id").isEmpty())
                ? Integer.parseInt(request.getParameter("image_id")) : null;

        Account account = new Account();
        account.setId(id);
        account.setEmail(email);
        account.setPassword(password);
        account.setStatus(status);
        account.setRole(role);
        account.setFull_name(fullName);
        account.setSex(sex);
        account.setDob(dob);
        account.setImage_id(imageId);

        return account;
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            System.out.println("Loading dashboard data...");

            // Get all dashboard data with error handling
            Map<String, Integer> totalCounts = new HashMap<>();
            Map<String, Integer> usersByRole = new HashMap<>();
            Map<String, Object> testStatistics = new HashMap<>();
            List<Map<String, Object>> recentActivities = new ArrayList<>();
            List<Map<String, Object>> monthlyCompletions = new ArrayList<>();
            List<Map<String, Object>> gradeDistribution = new ArrayList<>();
            Map<String, Object> packageStats = new HashMap<>();

            try {
                totalCounts = dashboardDAO.getTotalCounts();
                System.out.println("Total counts loaded: " + totalCounts);
            } catch (Exception e) {
                System.err.println("Error loading total counts: " + e.getMessage());
            }

            try {
                usersByRole = dashboardDAO.getUsersByRole();
                System.out.println("Users by role loaded: " + usersByRole);
            } catch (Exception e) {
                System.err.println("Error loading users by role: " + e.getMessage());
            }

            try {
                testStatistics = dashboardDAO.getTestStatistics();
                System.out.println("Test statistics loaded: " + testStatistics);
            } catch (Exception e) {
                System.err.println("Error loading test statistics: " + e.getMessage());
            }

            try {
                recentActivities = dashboardDAO.getRecentTestActivities();
                System.out.println("Recent activities loaded: " + recentActivities.size() + " items");
            } catch (Exception e) {
                System.err.println("Error loading recent activities: " + e.getMessage());
            }

            try {
                monthlyCompletions = dashboardDAO.getMonthlyTestCompletions();
                System.out.println("Monthly completions loaded: " + monthlyCompletions.size() + " items");
            } catch (Exception e) {
                System.err.println("Error loading monthly completions: " + e.getMessage());
            }

            try {
                gradeDistribution = dashboardDAO.getGradeDistribution();
                System.out.println("Grade distribution loaded: " + gradeDistribution.size() + " items");
            } catch (Exception e) {
                System.err.println("Error loading grade distribution: " + e.getMessage());
            }

            try {
                packageStats = dashboardDAO.getPackageStatistics();
                System.out.println("Package stats loaded: " + packageStats);
            } catch (Exception e) {
                System.err.println("Error loading package stats: " + e.getMessage());
            }

            // Convert data to JSON for charts
            Gson gson = new Gson();
            String usersByRoleJson = gson.toJson(usersByRole);
            String monthlyCompletionsJson = gson.toJson(monthlyCompletions);
            String gradeDistributionJson = gson.toJson(gradeDistribution);
            String testStatisticsJson = gson.toJson(testStatistics);

            // Set attributes
            request.setAttribute("totalCounts", totalCounts);
            request.setAttribute("usersByRole", usersByRole);
            request.setAttribute("testStatistics", testStatistics);
            request.setAttribute("recentActivities", recentActivities);
            request.setAttribute("packageStats", packageStats);

            // JSON data for charts
            request.setAttribute("usersByRoleJson", usersByRoleJson);
            request.setAttribute("monthlyCompletionsJson", monthlyCompletionsJson);
            request.setAttribute("gradeDistributionJson", gradeDistributionJson);
            request.setAttribute("testStatisticsJson", testStatisticsJson);

            System.out.println("Dashboard data loaded successfully, forwarding to JSP...");
            request.getRequestDispatcher("/admin/home.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Critical error in showDashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());

            // Set empty default values to prevent JSP errors
            request.setAttribute("totalCounts", new HashMap<String, Integer>());
            request.setAttribute("usersByRole", new HashMap<String, Integer>());
            request.setAttribute("testStatistics", new HashMap<String, Object>());
            request.setAttribute("recentActivities", new ArrayList<>());
            request.setAttribute("packageStats", new HashMap<String, Object>());
            request.setAttribute("usersByRoleJson", "{}");
            request.setAttribute("monthlyCompletionsJson", "[]");
            request.setAttribute("gradeDistributionJson", "[]");
            request.setAttribute("testStatisticsJson", "{}");

            request.getRequestDispatcher("/admin/home.jsp").forward(request, response);
        }
    }

    private void showTeacherDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Account teacher = (Account) session.getAttribute("account");

            if (teacher == null || !"teacher".equals(teacher.getRole())) {
                response.sendRedirect("/error.jsp");
                return;
            }

            System.out.println("Loading teacher dashboard data for teacher: " + teacher.getFull_name());

            Map<String, Integer> teacherData = dashboardDAO.getTotalCounts();
            List<Map<String, Object>> studentPerformance = dashboardDAO.getGradeDistribution();
            List<Map<String, Object>> recentActivities = dashboardDAO.getRecentTestActivities();
            List<Map<String, Object>> monthlyCompletions = dashboardDAO.getMonthlyTestCompletions();
            List<Map<String, Object>> subjectDistribution = dashboardDAO.getSubjectDistribution();

            // Convert data to JSON for charts with null safety
            Gson gson = new Gson();
            String studentPerformanceJson = gson.toJson(studentPerformance != null ? studentPerformance : new ArrayList<>());
            String monthlyCompletionsJson = gson.toJson(monthlyCompletions != null ? monthlyCompletions : new ArrayList<>());
            String subjectDistributionJson = gson.toJson(subjectDistribution != null ? subjectDistribution : new ArrayList<>());

            // Set attributes with null safety
            request.setAttribute("teacherData", teacherData != null ? teacherData : new HashMap<>());
            request.setAttribute("studentPerformance", studentPerformance != null ? studentPerformance : new ArrayList<>());
            request.setAttribute("recentActivities", recentActivities != null ? recentActivities : new ArrayList<>());
            request.setAttribute("teacher", teacher);

            // JSON data for charts
            request.setAttribute("studentPerformanceJson", studentPerformanceJson);
            request.setAttribute("monthlyCompletionsJson", monthlyCompletionsJson);
            request.setAttribute("subjectDistributionJson", subjectDistributionJson);

            System.out.println("Teacher dashboard data loaded successfully");
            request.getRequestDispatcher("/teacher/home.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in showTeacherDashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading teacher dashboard: " + e.getMessage());

            // Set empty default values to prevent JSP errors
            request.setAttribute("teacherData", new HashMap<String, Object>());
            request.setAttribute("studentPerformance", new ArrayList<>());
            request.setAttribute("recentActivities", new ArrayList<>());
            request.setAttribute("studentPerformanceJson", "[]");
            request.setAttribute("monthlyCompletionsJson", "[]");
            request.setAttribute("subjectDistributionJson", "[]");

            request.getRequestDispatcher("/teacher/home.jsp").forward(request, response);
        }
    }
}
