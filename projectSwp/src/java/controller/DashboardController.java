/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.DashboardDAO;
import dal.AccountDAO;
import dal.GradeDAO;
import dal.ImageDAO;
import dal.StudentDAO;
import dal.StudyPackageDAO;
import dal.StudentPackageDAO;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Student;
import util.AuthUtil;
import util.RoleConstants;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ankha
 */
/**
 * Dedicated controller for handling dashboard operations Separated from
 * AccountController for better security and organization
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    private DashboardDAO dashboardDAO = new DashboardDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private GradeDAO gradeDAO = new GradeDAO();
    private ImageDAO imageDAO = new ImageDAO(accountDAO.getConnection());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "default";
        }

        try {
            switch (action) {
                case "admin":
                    showAdminDashboard(request, response);
                    break;
                case "teacher":
                    showTeacherDashboard(request, response);
                    break;
                case "parent":
                    showParentDashboard(request, response);
                    break;
                case "student":
                    showStudentDashboard(request, response);
                    break;
                default:
                    redirectToRoleDashboard(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in dashboard", e);
        }
    }

    /**
     * Redirect user to appropriate dashboard based on their role
     */
    private void redirectToRoleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        Student student = (Student) session.getAttribute("student");

        // Student dashboard
        if (student != null) {
            response.sendRedirect("dashboard?action=student");
            return;
        }

        // Account-based dashboards
        if (account != null) {
            switch (account.getRole().toLowerCase()) {
                case "admin":
                    response.sendRedirect("dashboard?action=admin");
                    break;
                case "teacher":
                    response.sendRedirect("dashboard?action=teacher");
                    break;
                case "parent":
                    response.sendRedirect("dashboard?action=parent");
                    break;
                default:
                    response.sendRedirect("/error.jsp");
                    break;
            }
        } else {
            response.sendRedirect("/login.jsp");
        }
    }

    /**
     * Show admin dashboard with comprehensive system statistics
     */
    private void showAdminDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Security check
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            System.out.println("Loading admin dashboard data...");

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

            System.out.println("Admin dashboard data loaded successfully, forwarding to JSP...");
            request.getRequestDispatcher("/admin/home.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Critical error in showAdminDashboard: " + e.getMessage());
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

    /**
     * Show teacher dashboard with teaching-related statistics
     */
    private void showTeacherDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Security check
        if (!AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            HttpSession session = request.getSession();
            Account teacher = (Account) session.getAttribute("account");

            if (teacher == null) {
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

    /**
     * Show parent dashboard with children's performance data
     */
    private void showParentDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Security check
        if (!AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            HttpSession session = request.getSession();
            Account parent = (Account) session.getAttribute("account");

            if (parent == null) {
                response.sendRedirect("/error.jsp");
                return;
            }

            System.out.println("Loading parent dashboard data for parent: " + parent.getFull_name());

            // Get comprehensive dashboard data
            Map<String, Object> dashboardData = dashboardDAO.getParentDashboardData(parent.getId());

            // Convert data to JSON for charts
            Gson gson = new Gson();

            // Monthly progress chart data
            List<Map<String, Object>> monthlyProgress = (List<Map<String, Object>>) dashboardData.get("monthlyProgress");
            String monthlyProgressJson = gson.toJson(monthlyProgress != null ? monthlyProgress : new ArrayList<>());

            // Subject performance chart data
            List<Map<String, Object>> subjectPerformance = (List<Map<String, Object>>) dashboardData.get("subjectPerformance");
            String subjectPerformanceJson = gson.toJson(subjectPerformance != null ? subjectPerformance : new ArrayList<>());

            // Grade distribution chart data
            Map<String, Object> gradeDistribution = (Map<String, Object>) dashboardData.get("gradeDistribution");
            String gradeDistributionJson = gson.toJson(gradeDistribution != null ? gradeDistribution : new HashMap<>());

            // Test performance chart data
            List<Map<String, Object>> testPerformance = (List<Map<String, Object>>) dashboardData.get("testPerformance");
            String testPerformanceJson = gson.toJson(testPerformance != null ? testPerformance : new ArrayList<>());

            // Set all attributes
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("parent", parent);

            // JSON data for charts
            request.setAttribute("monthlyProgressJson", monthlyProgressJson);
            request.setAttribute("subjectPerformanceJson", subjectPerformanceJson);
            request.setAttribute("gradeDistributionJson", gradeDistributionJson);
            request.setAttribute("testPerformanceJson", testPerformanceJson);

            System.out.println("Parent dashboard data loaded successfully");
            request.getRequestDispatcher("/parent/home.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in showParentDashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading parent dashboard: " + e.getMessage());

            // Set empty default values to prevent JSP errors
            request.setAttribute("dashboardData", new HashMap<String, Object>());
            request.setAttribute("monthlyProgressJson", "[]");
            request.setAttribute("subjectPerformanceJson", "[]");
            request.setAttribute("gradeDistributionJson", "{}");
            request.setAttribute("testPerformanceJson", "[]");

            request.getRequestDispatcher("/parent/home.jsp").forward(request, response);
        }
    }

    /**
     * Show student dashboard with learning progress and performance
     */
    private void showStudentDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // Security check
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/login.jsp");
            return;
        }

        try {
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");

            if (student == null) {
                response.sendRedirect("/login.jsp");
                return;
            }

            System.out.println("Loading student dashboard data for student: " + student.getFull_name());

            // Get comprehensive dashboard data for student
            Map<String, Object> dashboardData = dashboardDAO.getStudentDashboardData(student.getId());

            // Convert data to JSON for charts
            Gson gson = new Gson();

            // Test performance over time chart data
            List<Map<String, Object>> testPerformance = (List<Map<String, Object>>) dashboardData.get("testPerformance");
            String testPerformanceJson = gson.toJson(testPerformance != null ? testPerformance : new ArrayList<>());

            // Subject performance chart data
            List<Map<String, Object>> subjectPerformance = (List<Map<String, Object>>) dashboardData.get("subjectPerformance");
            String subjectPerformanceJson = gson.toJson(subjectPerformance != null ? subjectPerformance : new ArrayList<>());

            // Monthly activity chart data
            List<Map<String, Object>> monthlyActivity = (List<Map<String, Object>>) dashboardData.get("monthlyActivity");
            String monthlyActivityJson = gson.toJson(monthlyActivity != null ? monthlyActivity : new ArrayList<>());

            // Test type distribution chart data
            Map<String, Object> testTypeDistribution = (Map<String, Object>) dashboardData.get("testTypeDistribution");
            String testTypeDistributionJson = gson.toJson(testTypeDistribution != null ? testTypeDistribution : new HashMap<>());

            // Set all attributes
            request.setAttribute("dashboardData", dashboardData);
            request.setAttribute("student", student);

            // JSON data for charts
            request.setAttribute("testPerformanceJson", testPerformanceJson);
            request.setAttribute("subjectPerformanceJson", subjectPerformanceJson);
            request.setAttribute("monthlyActivityJson", monthlyActivityJson);
            request.setAttribute("testTypeDistributionJson", testTypeDistributionJson);

            System.out.println("Student dashboard data loaded successfully");
            request.getRequestDispatcher("/student/home.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in showStudentDashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading student dashboard: " + e.getMessage());

            // Set empty default values to prevent JSP errors
            request.setAttribute("dashboardData", new HashMap<String, Object>());
            request.setAttribute("testPerformanceJson", "[]");
            request.setAttribute("subjectPerformanceJson", "[]");
            request.setAttribute("monthlyActivityJson", "[]");
            request.setAttribute("testTypeDistributionJson", "{}");

            request.getRequestDispatcher("/student/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Dashboard is read-only, redirect POST requests to GET
        doGet(request, response);
    }
}