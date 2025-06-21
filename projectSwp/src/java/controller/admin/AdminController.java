package controller.admin;

import dal.*;
import config.FileUploadUlti;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import util.AuthUtil;
import util.RoleConstants;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminController.class.getName());

    private AccountDAO accountDAO;
    private StudentDAO studentDAO;
    private TestDAO testDAO;
    private TestRecordDAO testRecordDAO;
    private InvoiceDAO invoiceDAO;
    private GradeDAO gradeDAO;
    private DAOSubject subjectDAO;
    private LessonDAO lessonDAO;
    private QuestionDAO questionDAO;
    private ImageDAO imageDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize DAOs
        accountDAO = new AccountDAO();
        studentDAO = new StudentDAO();
        testDAO = new TestDAO();
        testRecordDAO = new TestRecordDAO();
        invoiceDAO = new InvoiceDAO();
        gradeDAO = new GradeDAO();
        subjectDAO = new DAOSubject();
        lessonDAO = new LessonDAO();
        questionDAO = new QuestionDAO();
        imageDAO = new ImageDAO(accountDAO.getConnection());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authorization
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            showDashboard(request, response);
            return;
        }

        try {
            switch (action) {
                case "dashboard":
                    showDashboard(request, response);
                    break;
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
                case "analytics":
                    showAnalytics(request, response);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in AdminController", e);
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }

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
            LOGGER.log(Level.SEVERE, "Database error in AdminController POST", e);
            throw new ServletException(e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get dashboard statistics
            Map<String, Object> dashboardData = getDashboardData();

            // Set attributes for JSP
            request.setAttribute("dashboardData", dashboardData);

            // Forward to dashboard JSP
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading dashboard data", e);
            // Set empty data to prevent JSP errors
            request.setAttribute("dashboardData", getEmptyDashboardData());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    private Map<String, Object> getDashboardData() throws SQLException {
        Map<String, Object> data = new HashMap<>();

        try {
            // Basic counts
            data.put("totalUsers", accountDAO.countAccounts());
            data.put("totalStudents", studentDAO.countStudents());
            data.put("totalTests", testDAO.countTests());
            data.put("totalQuestions", questionDAO.countQuestions());
            data.put("totalLessons", lessonDAO.countLessons());
            data.put("totalSubjects", subjectDAO.countSubjects());
            data.put("totalGrades", gradeDAO.countGrades());

            // User distribution by role
            data.put("usersByRole", accountDAO.getUserCountByRole());

            // Recent activities
            data.put("recentTests", testRecordDAO.getRecentTestRecords(10));
            data.put("recentRegistrations", accountDAO.getRecentRegistrations(10));

            // Monthly statistics
            data.put("monthlyTestData", getMonthlyTestData());
            data.put("monthlyUserData", getMonthlyUserData());

            // Performance metrics
            data.put("averageTestScore", testRecordDAO.getAverageTestScore());
            data.put("testCompletionRate", testRecordDAO.getTestCompletionRate());

            // Revenue data (if applicable)
            data.put("monthlyRevenue", invoiceDAO.getMonthlyRevenue());
            data.put("totalRevenue", invoiceDAO.getTotalRevenue());

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting dashboard data", e);
            return getEmptyDashboardData();
        }

        return data;
    }

    private Map<String, Object> getEmptyDashboardData() {
        Map<String, Object> data = new HashMap<>();
        data.put("totalUsers", 0);
        data.put("totalStudents", 0);
        data.put("totalTests", 0);
        data.put("totalQuestions", 0);
        data.put("totalLessons", 0);
        data.put("totalSubjects", 0);
        data.put("totalGrades", 0);
        data.put("usersByRole", new HashMap<String, Integer>());
        data.put("recentTests", new ArrayList<>());
        data.put("recentRegistrations", new ArrayList<>());
        data.put("monthlyTestData", new ArrayList<>());
        data.put("monthlyUserData", new ArrayList<>());
        data.put("averageTestScore", 0.0);
        data.put("testCompletionRate", 0.0);
        data.put("monthlyRevenue", new ArrayList<>());
        data.put("totalRevenue", 0.0);
        return data;
    }

    private List<Map<String, Object>> getMonthlyTestData() {
        List<Map<String, Object>> monthlyData = new ArrayList<>();
        try {
            // Get test data for last 12 months
            LocalDate now = LocalDate.now();
            for (int i = 11; i >= 0; i--) {
                LocalDate month = now.minusMonths(i);
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("month", month.format(DateTimeFormatter.ofPattern("MMM yyyy")));
                monthData.put("tests", testRecordDAO.getTestCountByMonth(month));
                monthData.put("completions", testRecordDAO.getCompletedTestCountByMonth(month));
                monthlyData.add(monthData);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting monthly test data", e);
        }
        return monthlyData;
    }

    private List<Map<String, Object>> getMonthlyUserData() {
        List<Map<String, Object>> monthlyData = new ArrayList<>();
        try {
            // Get user registration data for last 12 months
            LocalDate now = LocalDate.now();
            for (int i = 11; i >= 0; i--) {
                LocalDate month = now.minusMonths(i);
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("month", month.format(DateTimeFormatter.ofPattern("MMM yyyy")));
                monthData.put("registrations", accountDAO.getRegistrationCountByMonth(month));
                monthlyData.add(monthData);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting monthly user data", e);
        }
        return monthlyData;
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

        try {
            List<Account> accountList = accountDAO.getAccountsByPage(offset, recordsPerPage);
            int totalRecords = accountDAO.countAccounts();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            List<Image> imageList = imageDAO.findAll();
            request.setAttribute("accountList", accountList);
            request.setAttribute("imageList", imageList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/accountList.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listing accounts", e);
            throw e;
        }
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            List<Image> imageList = imageDAO.findAll();
            int id = Integer.parseInt(request.getParameter("id"));
            Account accountView = accountDAO.viewProfile(id);
            request.setAttribute("imageList", imageList);
            request.setAttribute("view", accountView);
            request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error viewing profile", e);
            throw e;
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/insertAccount.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Account account = accountDAO.findById(id);
            Image image = imageDAO.findImageById(account.getImage_id());
            request.setAttribute("account", account);
            request.setAttribute("image", image);
            request.getRequestDispatcher("/accountForm.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error showing edit form", e);
            throw e;
        }
    }

    private void insertAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        try {
            Account account = getAccountFromRequest(request);
            String avatarName = "avatar_" + System.currentTimeMillis();

            String imgURL = FileUploadUlti.uploadAvatarImage(request, avatarName);

            if (imgURL != null) {
                Image image = new Image();
                image.setImage_data(imgURL);

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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting account", e);
            throw e;
        }
    }

    private void updateAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        try {
            Account oldAccount = accountDAO.findById(Integer.parseInt(request.getParameter("id")));
            Account account = getAccountFromRequest(request);
            String avatarName = "avatar_" + System.currentTimeMillis();
            String imgURL = FileUploadUlti.uploadAvatarImage(request, avatarName);

            // Validate old password if provided (edit mode)
            String oldPassword = request.getParameter("oldPassword");
            if (oldPassword != null && !oldPassword.isEmpty()) {
                if (!accountDAO.validatePassword(oldAccount, oldPassword)) {
                    request.setAttribute("passwordError", "Current password is incorrect");
                    Image image = imageDAO.findImageById(oldAccount.getImage_id());
                    request.setAttribute("account", oldAccount);
                    request.setAttribute("image", image);
                    request.getRequestDispatcher("/accountForm.jsp").forward(request, response);
                    return;
                }
            }

            if (imgURL != null) {
                Image image = new Image();
                image.setImage_data(imgURL);

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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating account", e);
            throw e;
        }
    }

    private void deleteAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
//        accountDAO.deleteAccount(id);
        response.sendRedirect("/accountList.jsp");
    }

    private void searchAccount(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            String email = request.getParameter("email");
            List<Account> accountList;
            if (email != null && !email.trim().isEmpty()) {
                accountList = accountDAO.findByEmail(email.trim());
                if (accountList == null || accountList.isEmpty()) {
                    request.setAttribute("error", "Nothing found for " + email.trim());
                }
            } else {
                accountList = accountDAO.findAll();
            }
            List<Image> imageList = imageDAO.findAll();
            request.setAttribute("imageList", imageList);
            request.setAttribute("accountList", accountList);
            request.getRequestDispatcher("/accountList.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching account", e);
            throw e;
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            Account account = accountDAO.findById(id);

            if (account == null) {
                request.setAttribute("passwordError", "Account not found.");
                List<Image> imageList = imageDAO.findAll();
                request.setAttribute("imageList", imageList);
                request.setAttribute("view", account);
                request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
                return;
            } else if (!accountDAO.validatePassword(account, oldPassword)) {
                request.setAttribute("passwordError", "Current password is incorrect.");
                List<Image> imageList = imageDAO.findAll();
                request.setAttribute("imageList", imageList);
                request.setAttribute("view", account);
                request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
                return;
            } else if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("passwordError", "New password must be at least 6 characters.");
                List<Image> imageList = imageDAO.findAll();
                request.setAttribute("imageList", imageList);
                request.setAttribute("view", account);
                request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
                return;
            } else {
                account.setPassword(newPassword);
                accountDAO.update(account);
                request.setAttribute("passwordSuccess", "Password changed successfully.");
                List<Image> imageList = imageDAO.findAll();
                request.setAttribute("imageList", imageList);
                request.setAttribute("view", account);
                request.getRequestDispatcher("profileAccount.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error changing password", e);
            throw e;
        }
    }

    private void showAnalytics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Placeholder for analytics page
        request.getRequestDispatcher("/admin/analytics.jsp").forward(request, response);
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
}
