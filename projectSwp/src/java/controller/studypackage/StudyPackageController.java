/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.StudyPackage;

import dal.AccountDAO;
import dal.DAOSubject;
import dal.InvoiceDAO;
import dal.StudyPackageDAO;
import dal.StudentPackageDAO;
import dal.GradeDAO;
import dal.PackageSubjectDAO;
import dal.StudentDAO;
import model.StudyPackage;
import model.StudentPackage;
import model.Grade;
import model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Invoice;
import model.Subject;
import util.AuthUtil;
import util.RoleConstants;

/**
 *
 * @author Na
 */
@WebServlet(name = "StudyPackageController", urlPatterns = {"/study_package"})
public class StudyPackageController extends HttpServlet {

    private StudyPackageDAO dao;
    private StudentPackageDAO studentPackageDAO;
    private GradeDAO gradeDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        dao = new StudyPackageDAO();
        studentPackageDAO = new StudentPackageDAO();
        gradeDAO = new GradeDAO();
        studentDAO = new StudentDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.PARENT)
                && !AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        response.setContentType("text/html;charset=UTF-8");

        String service = request.getParameter("service");

        if (service == null) {
            service = "";
        }

        try {
            switch (service) {
                case "add":
                    if (request.getMethod().equalsIgnoreCase("GET")) {
                        showAddForm(request, response);
                    } else {
                        addStudyPackage(request, response);
                    }
                    break;
                case "edit":
                    if (request.getMethod().equalsIgnoreCase("GET")) {
                        showEditForm(request, response);
                    } else {
                        updateStudyPackage(request, response);
                    }
                    break;
                case "update":
                    updateStudyPackage(request, response);
                    break;
                case "delete":
                    deleteStudyPackage(request, response);
                    break;
                case "search":
                    searchStudyPackage(request, response);
                    break;
                case "checkout":
                    checkoutStudyPackage(request, response);
                    break;
                case "detail":
                    showDetail(request, response);
                    break;
                case "myPackages":
                    showMyPackages(request, response);
                    break;
                case "assignStudent":
                    assignStudentToPackage(request, response);
                    break;
                case "getSubjectsByPackage":
                    handleGetSubjectsByPackage(request, response);
                    return;
                case "getAvailableSubjects":
                    handleGetAvailableSubjects(request, response);
                    return;
                case "getSubjectsByGrade":
                    handleGetSubjectsByGrade(request, response);
                    return;
                case "assignPackage":
                    assignPackageToStudent(request, response);
                    break;
                case "manageAssignments":
                    showManageAssignments(request, response);
                    break;
                case "assignToParent":
                    if (request.getMethod().equalsIgnoreCase("GET")) {
                        showAssignToParentForm(request, response);
                    } else {
                        processAssignToParent(request, response);
                    }
                    break;
                case "deactivateAssignment":
                    deactivateStudentPackage(request, response);
                    break;
                case "getAssignmentDetails":
                    getAssignmentDetails(request, response);
                    break;
                case "getStudentsByParent":
                    handleGetStudentsByParent(request, response);
                    return;
                case "myPackagesDetailed":
                    showMyPackagesDetailed(request, response);
                    break;

                case "managePackageAssignments":
                    managePackageAssignments(request, response);
                    break;

                case "assignAdditionalStudent":
                    assignAdditionalStudent(request, response);
                    break;

                case "removeStudentAssignment":
                    removeStudentAssignment(request, response);
                    break;

                case "getUnassignedChildren":
                    handleGetUnassignedChildren(request, response);
                    return;
                case "getParentPackageStats":
                    handleGetParentPackageStats(request, response);
                    return;
                case "getParentAssignmentHistory":
                    handleGetParentAssignmentHistory(request, response);
                    return;
                case "activate":
                    activateStudyPackage(request, response);
                    break;
                default:
                    listStudyPackage(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Processing error: " + e.getMessage());
            request.setAttribute("listStudyPackage", List.of());
            request.getRequestDispatcher("/studypackage/listStudyPackage.jsp").forward(request, response);
        }
    }

    private void listStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        List<StudyPackage> list;
        if (account != null && RoleConstants.PARENT.equals(account.getRole())) {
            // For parents, show active packages only
            list = dao.getActivePackages();
        } else {
            // For admin/teacher, show ALL packages (both active and inactive)
            list = dao.getStudyPackage("SELECT * FROM study_package ORDER BY is_active DESC, created_at DESC");
        }

        // Load grades for display
        try {
            List<Grade> grades = gradeDAO.findAllFromGrade();
            request.setAttribute("grades", grades);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("listStudyPackage", list != null ? list : List.of());
        request.getRequestDispatcher("/studypackage/listStudyPackage.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Grade> grades = gradeDAO.findAllFromGrade();
            request.setAttribute("grades", grades);

            // Load all subjects for selection
            DAOSubject subjectDAO = new DAOSubject();
            List<Subject> allSubjects = subjectDAO.findAll();
            request.setAttribute("allSubjects", allSubjects);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("allSubjects", new ArrayList<>());
        }
        request.getRequestDispatcher("/studypackage/form.jsp").forward(request, response);
    }

    private void addStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            StudyPackage stuPackage = getStudyPackageFromRequest(request);
            int result = dao.addStudyPackage(stuPackage);

            if (result > 0) {
                // Handle subject assignments for SUBJECT_COMBO type
                if ("SUBJECT_COMBO".equals(stuPackage.getType())) {
                    String[] subjectIds = request.getParameterValues("subject_ids");
                    if (subjectIds != null && subjectIds.length > 0) {
                        PackageSubjectDAO packageSubjectDAO = new PackageSubjectDAO();
                        for (String subjectIdStr : subjectIds) {
                            try {
                                int subjectId = Integer.parseInt(subjectIdStr);
                                packageSubjectDAO.addSubjectToPackage(stuPackage.getId(), subjectId);
                            } catch (NumberFormatException e) {
                                // Skip invalid subject IDs
                            }
                        }
                    }
                }

                request.setAttribute("message", "Study package added successfully!");
                response.sendRedirect("study_package");
            } else {
                request.setAttribute("errorMessage", "Cannot add study package. Please check the information.");
                showAddForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format!");
            showAddForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int editId = Integer.parseInt(request.getParameter("editId"));
            StudyPackage studyPackage = dao.findStudyPackageById(editId);
            List<Grade> grades = gradeDAO.findAllFromGrade();

            if (studyPackage != null) {
                request.setAttribute("studyPackageToEdit", studyPackage);
                request.setAttribute("grades", grades);

                // Load subjects for SUBJECT_COMBO packages
                if ("SUBJECT_COMBO".equals(studyPackage.getType())) {
                    PackageSubjectDAO packageSubjectDAO = new PackageSubjectDAO();
                    List<Integer> selectedSubjectIds = packageSubjectDAO.getPackageSubjects(editId);
                    request.setAttribute("selectedSubjectIds", selectedSubjectIds);
                }

                // Load all subjects for selection
                try {
                    DAOSubject subjectDAO = new DAOSubject();
                    List<Subject> allSubjects = subjectDAO.findAll();
                    request.setAttribute("allSubjects", allSubjects);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                request.setAttribute("errorMessage", "Study package not found with ID: " + editId);
            }
            request.getRequestDispatcher("/studypackage/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format!");
            listStudyPackage(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading study package: " + e.getMessage());
            listStudyPackage(request, response);
        }
    }

    private void updateStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            StudyPackage stuPackage = getStudyPackageFromRequest(request);
            int result = dao.updateStudyPackage(stuPackage);

            if (result > 0) {
                // Handle subject assignments for SUBJECT_COMBO type
                if ("SUBJECT_COMBO".equals(stuPackage.getType())) {
                    PackageSubjectDAO packageSubjectDAO = new PackageSubjectDAO();

                    // Remove all existing subjects for this package
                    List<Integer> existingSubjects = packageSubjectDAO.getPackageSubjects(stuPackage.getId());
                    for (Integer subjectId : existingSubjects) {
                        packageSubjectDAO.removeSubjectFromPackage(stuPackage.getId(), subjectId);
                    }

                    // Add new subjects
                    String[] subjectIds = request.getParameterValues("subject_ids");
                    if (subjectIds != null && subjectIds.length > 0) {
                        for (String subjectIdStr : subjectIds) {
                            try {
                                int subjectId = Integer.parseInt(subjectIdStr);
                                packageSubjectDAO.addSubjectToPackage(stuPackage.getId(), subjectId);
                            } catch (NumberFormatException e) {
                                // Skip invalid subject IDs
                            }
                        }
                    }
                }

                request.setAttribute("message", "Study package updated successfully!");
                response.sendRedirect("study_package");
            } else {
                request.setAttribute("errorMessage", "Cannot update study package. Please check the information.");
                request.setAttribute("studyPackageToEdit", stuPackage);
                showEditForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format!");
            listStudyPackage(request, response);
        }
    }

    private void deleteStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int result = dao.deleteStudyPackage(id);
            if (result > 0) {
                request.setAttribute("message", "Study package deactivated successfully!");
            } else {
                request.setAttribute("errorMessage", "Cannot deactivate study package!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format!");
        }
        response.sendRedirect("study_package");
    }

    private void searchStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String nameParam = request.getParameter("name");
        String priceParam = request.getParameter("price");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                StudyPackage stuPackage = dao.findStudyPackageById(id);
                if (stuPackage != null) {
                    request.setAttribute("listStudyPackage", List.of(stuPackage));
                } else {
                    request.setAttribute("listStudyPackage", List.of());
                    request.setAttribute("message", "No study package found with id = " + id);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("listStudyPackage", List.of());
                request.setAttribute("message", "Invalid id format!");
            }
        } else if (nameParam != null && !nameParam.trim().isEmpty()) {
            List<StudyPackage> list = dao.findStudyPackageByName(nameParam);
            request.setAttribute("listStudyPackage", list);
            if (list.isEmpty()) {
                request.setAttribute("message", "No study package found with name containing: " + nameParam);
            }
        } else if (priceParam != null && !priceParam.trim().isEmpty()) {
            List<StudyPackage> list = dao.findStudyPackageByPrice(priceParam);
            request.setAttribute("listStudyPackage", list);
            if (list.isEmpty()) {
                request.setAttribute("message", "No study package found with price: " + priceParam);
            }
        } else {
            request.setAttribute("message", "No search criteria entered");
            request.setAttribute("listStudyPackage", List.of());
        }

        request.getRequestDispatcher("/studypackage/listStudyPackage.jsp").forward(request, response);
    }

    private void checkoutStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            StudyPackage sp = dao.findStudyPackageById(id);

            if (sp != null) {
                HttpSession session = request.getSession();
                Account account = (Account) session.getAttribute("account");

                if (account != null && RoleConstants.PARENT.equals(account.getRole())) {
                    // Check parent's current assignments for this specific package
                    int currentParentAssignments = studentPackageDAO.countParentAssignedStudents(account.getId(), id);
                    int maxStudentsPerParent = sp.getMax_students();
                    int availableSlots = maxStudentsPerParent - currentParentAssignments;

                    // Always allow purchase if parent has available slots
                    if (availableSlots > 0) {
                        request.setAttribute("packageId", id);
                        request.setAttribute("packageName", sp.getName());
                        request.setAttribute("amount", Double.parseDouble(sp.getPrice()));
                        request.setAttribute("userId", account.getId());
                        request.setAttribute("studyPackage", sp);

                        // Add parent-specific package statistics
                        request.setAttribute("currentParentAssignments", currentParentAssignments);
                        request.setAttribute("availableSlots", availableSlots);
                        request.setAttribute("maxStudentsPerParent", maxStudentsPerParent);

                        // Get parent's children and separate available vs unavailable
                        try {
                            List<Student> allChildren = studentDAO.getStudentsByParentId(account.getId());
                            List<Integer> studentsWithPackage = studentPackageDAO.getStudentsWithActivePackage(id);

                            List<Student> availableChildren = new ArrayList<>();
                            List<Student> unavailableChildren = new ArrayList<>();

                            for (Student child : allChildren) {
                                if (studentsWithPackage.contains(child.getId())) {
                                    unavailableChildren.add(child);
                                } else {
                                    availableChildren.add(child);
                                }
                            }

                            request.setAttribute("children", availableChildren);
                            request.setAttribute("unavailableChildren", unavailableChildren);

                            // Also get grades for display
                            List<Grade> grades = gradeDAO.findAllFromGrade();
                            request.setAttribute("gradeList", grades);

                            // Add informational message if some children already have the package
                            if (!unavailableChildren.isEmpty()) {
                                request.setAttribute("infoMessage",
                                        unavailableChildren.size() + " of your children already have this package and cannot be selected again.");
                            }

                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        request.getRequestDispatcher("/studypackage/purchase.jsp").forward(request, response);
                    } else {
                        // Parent has reached maximum limit for this package
                        request.setAttribute("errorMessage",
                                "You have reached the maximum limit for this package (" + maxStudentsPerParent + " students per parent). "
                                + "You currently have " + currentParentAssignments + " students assigned to this package. "
                                + "To assign more students, you would need to remove existing assignments first.");
                        listStudyPackage(request, response);
                    }
                } else {
                    request.setAttribute("errorMessage", "Only parents can purchase study packages.");
                    listStudyPackage(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Study package not found for payment.");
                listStudyPackage(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Processing error: " + e.getMessage());
            listStudyPackage(request, response);
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            StudyPackage studyPackage = dao.findStudyPackageById(id);
            if (studyPackage != null) {
                // Get assigned students count
                int assignedCount = studentPackageDAO.countAssignedStudents(id);
                request.setAttribute("studyPackageDetail", studyPackage);
                request.setAttribute("assignedCount", assignedCount);

                // Also load grades for display
                try {
                    List<Grade> grades = gradeDAO.findAllFromGrade();
                    request.setAttribute("grades", grades);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                request.getRequestDispatcher("/studypackage/studyPackageDetail.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Study package not found with ID: " + id);
                listStudyPackage(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format!");
            listStudyPackage(request, response);
        }
    }

    private void showMyPackages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        Student student = (Student) session.getAttribute("student");

        List<StudentPackage> studentPackages = new ArrayList<>();

        if (account != null && RoleConstants.PARENT.equals(account.getRole())) {
            studentPackages = studentPackageDAO.getStudentPackagesByParent(account.getId());
            request.setAttribute("studentPackages", studentPackages);
            request.getRequestDispatcher("/studypackage/myPackages.jsp").forward(request, response);
            return;
        }

        if (student != null) {
            // Sử dụng phương thức mới sẽ được tạo ở Bước 3
            studentPackages = studentPackageDAO.getStudentPackagesByStudentId(student.getId());
            request.setAttribute("studentPackages", studentPackages);
            request.getRequestDispatcher("/studypackage/myPackages.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("/error.jsp");
    }

    private void assignStudentToPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account != null && RoleConstants.PARENT.equals(account.getRole())) {
            try {
                int packageId = Integer.parseInt(request.getParameter("packageId"));
                int studentId = Integer.parseInt(request.getParameter("studentId"));

                StudyPackage studyPackage = dao.findStudyPackageById(packageId);
                if (studyPackage != null) {
                    // Check if package has available slots
                    if (studentPackageDAO.hasAvailableSlots(packageId)) {
                        boolean success = studentPackageDAO.assignPackageToStudent(
                                studentId, packageId, account.getId(), studyPackage.getDuration_days()
                        );

                        if (success) {
                            request.setAttribute("message", "Package assigned to student successfully!");
                        } else {
                            request.setAttribute("errorMessage", "Failed to assign package to student.");
                        }
                    } else {
                        request.setAttribute("errorMessage", "This package has reached maximum student limit.");
                    }
                } else {
                    request.setAttribute("errorMessage", "Study package not found.");
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error assigning package: " + e.getMessage());
            }
        }

        showMyPackages(request, response);
    }

    private StudyPackage getStudyPackageFromRequest(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String type = request.getParameter("type");
        String gradeIdStr = request.getParameter("grade_id");
        Integer gradeId = (gradeIdStr != null && !gradeIdStr.isEmpty()) ? Integer.parseInt(gradeIdStr) : null;
        String maxStudentsStr = request.getParameter("max_students");
        int maxStudents = (maxStudentsStr != null && !maxStudentsStr.isEmpty()) ? Integer.parseInt(maxStudentsStr) : 1;
        String durationDaysStr = request.getParameter("duration_days");
        int durationDays = (durationDaysStr != null && !durationDaysStr.isEmpty()) ? Integer.parseInt(durationDaysStr) : 365;
        String description = request.getParameter("description");

        return new StudyPackage(id, name, price, type, gradeId, maxStudents, durationDays, description);
    }

    // New method to get subjects for a specific package
    private void handleGetSubjectsByPackage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            PackageSubjectDAO packageSubjectDAO = new PackageSubjectDAO();
            List<Integer> subjectIds = packageSubjectDAO.getPackageSubjects(packageId);

            DAOSubject subjectDAO = new DAOSubject();
            List<Subject> allSubjects = subjectDAO.findAll();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Subject subject : allSubjects) {
                if (subjectIds.contains(subject.getId())) {
                    if (!first) {
                        json.append(",");
                    }
                    json.append("{\"id\":").append(subject.getId())
                            .append(",\"name\":\"").append(escapeJson(subject.getName()))
                            .append("\",\"grade_id\":").append(subject.getGrade_id())
                            .append("}");
                    first = false;
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

// New method to get all available subjects for selection
    private void handleGetAvailableSubjects(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            DAOSubject subjectDAO = new DAOSubject();
            List<Subject> subjects = subjectDAO.findAll();

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < subjects.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Subject subject = subjects.get(i);
                json.append("{\"id\":").append(subject.getId())
                        .append(",\"name\":\"").append(escapeJson(subject.getName()))
                        .append("\",\"grade_id\":").append(subject.getGrade_id())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private void handleGetSubjectsByGrade(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int gradeId = Integer.parseInt(request.getParameter("gradeId"));
            DAOSubject subjectDAO = new DAOSubject();
            List<Subject> subjects = subjectDAO.findAll();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Subject subject : subjects) {
                if (subject.getGrade_id() == gradeId) {
                    if (!first) {
                        json.append(",");
                    }
                    json.append("{\"id\":").append(subject.getId())
                            .append(",\"name\":\"").append(escapeJson(subject.getName()))
                            .append("\"}");
                    first = false;
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

// Helper method to escape JSON strings
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private void showManageAssignments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get filter parameters
            String packageName = request.getParameter("packageName");
            String studentName = request.getParameter("studentName");
            String status = request.getParameter("status");

            // Get all packages with their assignments (with filtering)
            List<Map<String, Object>> packageAssignments = new ArrayList<>();
            List<StudyPackage> allPackages;

            if (packageName != null && !packageName.trim().isEmpty()) {
                allPackages = dao.findStudyPackageByName(packageName.trim());
            } else {
                allPackages = dao.getStudyPackage("SELECT * FROM study_package WHERE is_active = 1");
            }

            for (StudyPackage pkg : allPackages) {
                Map<String, Object> packageData = new HashMap<>();
                packageData.put("packageId", pkg.getId());
                packageData.put("packageName", pkg.getName());
                packageData.put("packageType", pkg.getType());
                packageData.put("maxStudents", pkg.getMax_students());

                // Get assignments for this package with filtering
                List<StudentPackage> assignments = studentPackageDAO.getFilteredStudentPackagesByPackage(
                        pkg.getId(), studentName, status);

                // Calculate statistics
                int activeCount = 0;
                int totalCount = assignments.size();

                for (StudentPackage assignment : assignments) {
                    if (assignment.isActive()) {
                        activeCount++;
                    }
                }

                packageData.put("assignments", assignments);
                packageData.put("assignmentCount", totalCount);
                packageData.put("activeCount", activeCount);

                packageAssignments.add(packageData);
            }

            // Get statistics using the new method
            Map<String, Object> dashboardData = studentPackageDAO.getDashboardData();

            // Get package statistics
            int totalPackages = allPackages.size();

            request.setAttribute("packageAssignments", packageAssignments);
            request.setAttribute("totalPackages", totalPackages);
            request.setAttribute("activeAssignments", dashboardData.get("activeAssignments"));
            request.setAttribute("expiredAssignments", dashboardData.get("expiredAssignments"));
            request.setAttribute("totalStudents", dashboardData.get("totalStudents"));

            // Set filter parameters for form
            request.setAttribute("filterPackageName", packageName);
            request.setAttribute("filterStudentName", studentName);
            request.setAttribute("filterStatus", status);

            request.getRequestDispatcher("/studypackage/manageAssignments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading assignments: " + e.getMessage());
            listStudyPackage(request, response);
        }
    }

    private void showAssignToParentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all active packages
            List<StudyPackage> packages = dao.getActivePackages();
            request.setAttribute("packages", packages);

            // Get all parents
            AccountDAO accountDAO = new AccountDAO();
            List<Account> parents = accountDAO.getAccountsByRole("parent");
            request.setAttribute("parents", parents);

            // Debug logging
            System.out.println("DEBUG: Found " + packages.size() + " packages");
            System.out.println("DEBUG: Found " + parents.size() + " parents");

            // Add additional attributes for better form handling
            request.setAttribute("pageTitle", "Assign Study Package to Parent");
            request.setAttribute("formAction", "assignToParent");

            request.getRequestDispatcher("/studypackage/assignToParent.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading assignment form: " + e.getMessage());
            listStudyPackage(request, response);
        }
    }

    private void processAssignToParent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user has admin or teacher role
        HttpSession session = request.getSession();
        Account currentUser = (Account) session.getAttribute("account");
        if (currentUser == null
                || (!RoleConstants.ADMIN.equals(currentUser.getRole())
                && !RoleConstants.TEACHER.equals(currentUser.getRole()))) {
            response.sendRedirect("/error.jsp");
            return;
        }
        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            int parentId = Integer.parseInt(request.getParameter("parentId"));
            String[] studentIds = request.getParameterValues("studentIds");

            System.out.println("DEBUG: Admin assignment - Package: " + packageId
                    + ", Parent: " + parentId + ", Students: "
                    + (studentIds != null ? studentIds.length : 0)
                    + ", Assigned by: " + currentUser.getFull_name());

            // Validation
            if (studentIds == null || studentIds.length == 0) {
                request.setAttribute("errorMessage", "Please select at least one student.");
                showAssignToParentForm(request, response);
                return;
            }

            // Verify parent exists and is active
            AccountDAO accountDAO = new AccountDAO();
            Account parent = accountDAO.findById(parentId);
            if (parent == null || !RoleConstants.PARENT.equals(parent.getRole())
                    || !"active".equalsIgnoreCase(parent.getStatus())) {
                request.setAttribute("errorMessage", "Invalid or inactive parent account.");
                showAssignToParentForm(request, response);
                return;
            }

            StudyPackage studyPackage = dao.findStudyPackageById(packageId);
            if (studyPackage == null || !studyPackage.isIs_active()) {
                request.setAttribute("errorMessage", "Study package not found or inactive.");
                showAssignToParentForm(request, response);
                return;
            }

            // Check current parent assignments for this package
            int currentParentAssignments = studentPackageDAO.countParentAssignedStudents(parentId, packageId);
            int maxPerParent = studyPackage.getMax_students();
            int availableSlots = maxPerParent - currentParentAssignments;

            System.out.println("DEBUG: Parent " + parentId + " has " + currentParentAssignments
                    + " assignments, max " + maxPerParent + ", available " + availableSlots);

            // Check if parent has enough available slots
            if (studentIds.length > availableSlots) {
                request.setAttribute("errorMessage",
                        "Cannot assign " + studentIds.length + " student(s). Parent has only " + availableSlots
                        + " available slot(s) for this package. (Current: " + currentParentAssignments
                        + "/" + maxPerParent + ")");
                showAssignToParentForm(request, response);
                return;
            }

            // Verify all students belong to the selected parent and don't already have the package
            StudentDAO studentDAO = new StudentDAO();
            List<Integer> studentsWithPackage = studentPackageDAO.getStudentsWithActivePackage(packageId);

            for (String studentIdStr : studentIds) {
                try {
                    int studentId = Integer.parseInt(studentIdStr);
                    Student student = studentDAO.findById(studentId);

                    if (student == null || student.getParent_id() != parentId) {
                        request.setAttribute("errorMessage",
                                "Invalid student selection. Student does not belong to selected parent.");
                        showAssignToParentForm(request, response);
                        return;
                    }

                    if (studentsWithPackage.contains(studentId)) {
                        request.setAttribute("errorMessage",
                                "Student '" + student.getFull_name() + "' already has this package.");
                        showAssignToParentForm(request, response);
                        return;
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Invalid student ID: " + studentIdStr);
                    showAssignToParentForm(request, response);
                    return;
                }
            }

            // Create invoice for the assignment
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice invoice = new Invoice();
            invoice.setTotal_amount(studyPackage.getPrice());
            invoice.setParent_id(parentId);
            invoice.setCreated_at(LocalDate.now());
            invoice.setStatus("Completed"); // Admin assignment is automatically completed
            invoice.setPay_at(LocalDate.now());

            int invoiceId = invoiceDAO.insertInvoice(invoice);

            if (invoiceId > 0) {
                // Add invoice line
                invoiceDAO.insertInvoiceLine(invoiceId, packageId);

                // Assign package to each selected student
                boolean allAssigned = true;
                int successCount = 0;
                List<String> failedStudents = new ArrayList<>();

                for (String studentIdStr : studentIds) {
                    try {
                        int studentId = Integer.parseInt(studentIdStr);
                        boolean assigned = studentPackageDAO.assignPackageToStudent(
                                studentId, packageId, parentId, studyPackage.getDuration_days()
                        );

                        if (assigned) {
                            successCount++;
                            // Update invoice line with student assignment
                            invoiceDAO.updateInvoiceLineWithStudent(invoiceId, studentId);
                            System.out.println("DEBUG: Successfully assigned package " + packageId
                                    + " to student " + studentId);
                        } else {
                            allAssigned = false;
                            Student student = studentDAO.findById(studentId);
                            failedStudents.add(student != null ? student.getFull_name() : "ID:" + studentId);
                            System.out.println("DEBUG: Failed to assign package " + packageId
                                    + " to student " + studentId);
                        }
                    } catch (NumberFormatException e) {
                        allAssigned = false;
                        failedStudents.add("Invalid ID: " + studentIdStr);
                    } catch (Exception e) {
                        allAssigned = false;
                        failedStudents.add("Error with student: " + studentIdStr);
                        e.printStackTrace();
                    }
                }

                // Set result messages
                if (successCount > 0) {
                    String successMessage = "Successfully assigned package \"" + studyPackage.getName()
                            + "\" to " + successCount + " student(s)!";
                    request.setAttribute("message", successMessage);
                    System.out.println("DEBUG: " + successMessage);
                }

                if (!allAssigned && !failedStudents.isEmpty()) {
                    String errorMessage = "Some assignments failed for: " + String.join(", ", failedStudents);
                    request.setAttribute("errorMessage", errorMessage);
                    System.out.println("DEBUG: " + errorMessage);
                }

                // Redirect to manage assignments to see results
                showManageAssignments(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to create invoice for assignment.");
                showAssignToParentForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing assignment: " + e.getMessage());
            showAssignToParentForm(request, response);
        }
    }

    private void deactivateStudentPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            boolean success = studentPackageDAO.deactivateStudentPackage(assignmentId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Assignment deactivated successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to deactivate assignment\"}");
            }
        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void getAssignmentDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));

            // Get assignment details with all related information
            Map<String, Object> details = studentPackageDAO.getAssignmentDetails(assignmentId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert to JSON manually or use a JSON library
            StringBuilder json = new StringBuilder("{");
            for (Map.Entry<String, Object> entry : details.entrySet()) {
                if (json.length() > 1) {
                    json.append(",");
                }
                json.append("\"").append(entry.getKey()).append("\":\"")
                        .append(entry.getValue().toString().replace("\"", "\\\"")).append("\"");
            }
            json.append("}");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Failed to load assignment details\"}");
        }
    }

    private void handleGetStudentsByParent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int parentId = Integer.parseInt(request.getParameter("parentId"));
            String packageIdParam = request.getParameter("packageId");

            // Get students by parent ID
            StudentDAO studentDAO = new StudentDAO();
            List<Student> allStudents = studentDAO.getStudentsByParentId(parentId);

            // Get grades for display
            GradeDAO gradeDAO = new GradeDAO();
            List<Grade> grades = gradeDAO.findAllFromGrade();

            // Create grade map for quick lookup
            Map<Integer, String> gradeMap = new HashMap<>();
            for (Grade grade : grades) {
                gradeMap.put(grade.getId(), grade.getName());
            }

            // Check which students already have this package (if packageId is provided)
            List<Integer> studentsWithPackage = new ArrayList<>();
            if (packageIdParam != null && !packageIdParam.isEmpty()) {
                try {
                    int packageId = Integer.parseInt(packageIdParam);
                    studentsWithPackage = studentPackageDAO.getStudentsWithActivePackage(packageId);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid package ID: " + packageIdParam);
                }
            }

            // Build JSON response with availability status
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < allStudents.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Student student = allStudents.get(i);
                String gradeName = gradeMap.getOrDefault(student.getGrade_id(), "Unknown");
                boolean hasPackage = studentsWithPackage.contains(student.getId());

                json.append("{")
                        .append("\"id\":").append(student.getId())
                        .append(",\"full_name\":\"").append(escapeJson(student.getFull_name()))
                        .append("\",\"username\":\"").append(escapeJson(student.getUsername()))
                        .append("\",\"grade_name\":\"").append(escapeJson(gradeName)) // Fix: Added closing quote
                        .append("\",\"has_package\":").append(hasPackage)
                        .append(",\"status\":\"").append(hasPackage ? "unavailable" : "available")
                        .append("\"}");
            }
            json.append("]");

            System.out.println("DEBUG: Returning JSON for parent " + parentId
                    + (packageIdParam != null ? " and package " + packageIdParam : "")
                    + ": " + json.toString());
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR in handleGetStudentsByParent: " + e.getMessage());
            response.getWriter().write("[]");
        }
    }

    private void assignPackageToStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account != null && RoleConstants.PARENT.equals(account.getRole())) {
            try {
                int packageId = Integer.parseInt(request.getParameter("packageId"));
                String[] studentIds = request.getParameterValues("studentIds");

                if (studentIds == null || studentIds.length == 0) {
                    request.setAttribute("errorMessage", "Please select at least one student.");
                    checkoutStudyPackage(request, response);
                    return;
                }

                StudyPackage studyPackage = dao.findStudyPackageById(packageId);
                if (studyPackage == null) {
                    request.setAttribute("errorMessage", "Study package not found.");
                    listStudyPackage(request, response);
                    return;
                }

                // Check parent's available slots (per-parent limit)
                int currentParentAssignments = studentPackageDAO.countParentAssignedStudents(account.getId(), packageId);
                int maxPerParent = studyPackage.getMax_students();
                int availableSlots = maxPerParent - currentParentAssignments;

                if (studentIds.length > availableSlots) {
                    request.setAttribute("errorMessage",
                            "Cannot assign " + studentIds.length + " student(s). You have only " + availableSlots
                            + " available slot(s) for this package. (Current: " + currentParentAssignments
                            + "/" + maxPerParent + ")");
                    checkoutStudyPackage(request, response);
                    return;
                }

                // Verify students don't already have the package
                List<Integer> studentsWithPackage = studentPackageDAO.getStudentsWithActivePackage(packageId);
                for (String studentIdStr : studentIds) {
                    try {
                        int studentId = Integer.parseInt(studentIdStr);
                        if (studentsWithPackage.contains(studentId)) {
                            Student student = studentDAO.findById(studentId);
                            request.setAttribute("errorMessage",
                                    "Student '" + (student != null ? student.getFull_name() : "ID:" + studentId)
                                    + "' already has this package.");
                            checkoutStudyPackage(request, response);
                            return;
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "Invalid student ID: " + studentIdStr);
                        checkoutStudyPackage(request, response);
                        return;
                    }
                }

                // Create invoice with fixed package price
                InvoiceDAO invoiceDAO = new InvoiceDAO();
                Invoice invoice = new Invoice();
                invoice.setTotal_amount(studyPackage.getPrice()); // Fixed price regardless of student count
                invoice.setParent_id(account.getId());
                invoice.setCreated_at(LocalDate.now());
                invoice.setStatus("Completed"); // Direct assignment without payment gateway
                invoice.setPay_at(LocalDate.now());

                int invoiceId = invoiceDAO.insertInvoice(invoice);

                if (invoiceId > 0) {
                    // Add invoice line
                    invoiceDAO.insertInvoiceLine(invoiceId, packageId);

                    // Assign package to each selected student
                    boolean allAssigned = true;
                    int successCount = 0;
                    for (String studentIdStr : studentIds) {
                        try {
                            int studentId = Integer.parseInt(studentIdStr);
                            boolean assigned = studentPackageDAO.assignPackageToStudent(
                                    studentId,
                                    packageId,
                                    account.getId(),
                                    studyPackage.getDuration_days()
                            );

                            if (assigned) {
                                successCount++;
                                // Update invoice line with student assignment
                                invoiceDAO.updateInvoiceLineWithStudent(invoiceId, studentId);
                            } else {
                                allAssigned = false;
                                System.err.println("Failed to assign package " + packageId + " to student " + studentId);
                            }
                        } catch (NumberFormatException e) {
                            allAssigned = false;
                            System.err.println("Invalid student ID: " + studentIdStr);
                        }
                    }

                    if (successCount > 0) {
                        request.setAttribute("message",
                                "Study package successfully assigned to " + successCount + " student(s)! "
                                + "You now have " + (currentParentAssignments + successCount) + "/" + maxPerParent
                                + " students assigned to this package.");
                        showMyPackages(request, response);
                    } else {
                        request.setAttribute("errorMessage",
                                "Assignment failed. Please check and try again.");
                        checkoutStudyPackage(request, response);
                    }
                } else {
                    request.setAttribute("errorMessage", "Failed to create invoice.");
                    checkoutStudyPackage(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error assigning package: " + e.getMessage());
                checkoutStudyPackage(request, response);
            }
        } else {
            response.sendRedirect("/error.jsp");
        }
    }

    private void showMyPackagesDetailed(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !RoleConstants.PARENT.equals(account.getRole())) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            List<Map<String, Object>> parentPackages = dao.getParentPackagesWithAssignments(account.getId());
            request.setAttribute("parentPackages", parentPackages);
            request.setAttribute("parent", account);

            request.getRequestDispatcher("/studypackage/myPackagesDetailed.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading package details: " + e.getMessage());
            showMyPackages(request, response);
        }
    }

    private void managePackageAssignments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !RoleConstants.PARENT.equals(account.getRole())) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            // Get package details
            StudyPackage studyPackage = dao.findStudyPackageById(packageId);
            if (studyPackage == null) {
                request.setAttribute("errorMessage", "Package not found.");
                showMyPackagesDetailed(request, response);
                return;
            }

            // Get parent's package statistics
            Map<String, Object> packageStats = dao.getParentPackageStats(account.getId(), packageId);

            // Get current assignments for this parent
            List<Map<String, Object>> assignments = dao.getPackageAssignmentDetails(packageId, account.getId());

            // Get unassigned children (considering parent's available slots)
            List<Map<String, Object>> unassignedChildren = studentPackageDAO.getUnassignedChildrenForPackage(account.getId(), packageId);

            // Get available slots for this parent
            int availableSlots = dao.getAvailableSlotsForParent(account.getId(), packageId);

            request.setAttribute("studyPackage", studyPackage);
            request.setAttribute("packageStats", packageStats);
            request.setAttribute("assignments", assignments);
            request.setAttribute("unassignedChildren", unassignedChildren);
            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("packageId", packageId);

            request.getRequestDispatcher("/studypackage/managePackageAssignments.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error managing assignments: " + e.getMessage());
            showMyPackagesDetailed(request, response);
        }
    }

    public int getAvailableSlotsForParent(int parentId, int packageId) {
        return dao.getAvailableSlotsForParent(parentId, packageId);
    }

    private void assignAdditionalStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !RoleConstants.PARENT.equals(account.getRole())) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));

            StudyPackage studyPackage = dao.findStudyPackageById(packageId);
            if (studyPackage == null) {
                request.setAttribute("errorMessage", "Package not found.");
                managePackageAssignments(request, response);
                return;
            }

            boolean success = studentPackageDAO.assignAdditionalStudentToPackage(
                    studentId, packageId, account.getId(), studyPackage.getDuration_days()
            );

            if (success) {
                request.setAttribute("message", "Student assigned successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to assign student. Please check if you have available slots or if the student already has this package.");
            }

            // Redirect back to manage assignments page
            response.sendRedirect("study_package?service=managePackageAssignments&packageId=" + packageId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error assigning student: " + e.getMessage());
            showMyPackagesDetailed(request, response);
        }
    }

    private void removeStudentAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !RoleConstants.PARENT.equals(account.getRole())) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            boolean success = studentPackageDAO.removeStudentFromPackage(assignmentId, account.getId());

            if (success) {
                request.setAttribute("message", "Student assignment removed successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to remove student assignment.");
            }

            // Redirect back to manage assignments page
            response.sendRedirect("study_package?service=managePackageAssignments&packageId=" + packageId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error removing assignment: " + e.getMessage());
            showMyPackagesDetailed(request, response);
        }
    }

    private void handleGetUnassignedChildren(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || !RoleConstants.PARENT.equals(account.getRole())) {
            response.getWriter().write("[]");
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            List<Map<String, Object>> children = studentPackageDAO.getUnassignedChildrenForPackage(account.getId(), packageId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < children.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Map<String, Object> child = children.get(i);
                json.append("{")
                        .append("\"id\":").append(child.get("id"))
                        .append(",\"fullName\":\"").append(escapeJson(child.get("fullName").toString()))
                        .append("\",\"username\":\"").append(escapeJson(child.get("username").toString()))
                        .append("\",\"gradeName\":\"").append(escapeJson(child.get("gradeName").toString()))
                        .append("\"}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    private void handleGetParentPackageStats(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int parentId = Integer.parseInt(request.getParameter("parentId"));
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            Map<String, Object> stats = studentPackageDAO.getParentPackageStats(parentId, packageId);

            // Convert to JSON manually
            StringBuilder json = new StringBuilder("{");
            boolean first = true;
            for (Map.Entry<String, Object> entry : stats.entrySet()) {
                if (!first) {
                    json.append(",");
                }
                json.append("\"").append(entry.getKey()).append("\":");

                Object value = entry.getValue();
                if (value instanceof String) {
                    json.append("\"").append(escapeJson(value.toString())).append("\"");
                } else {
                    json.append(value);
                }
                first = false;
            }
            json.append("}");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{}");
        }
    }

    private void handleGetParentAssignmentHistory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int parentId = Integer.parseInt(request.getParameter("parentId"));
            int limit = Integer.parseInt(request.getParameter("limit"));

            List<Map<String, Object>> history = studentPackageDAO.getParentAssignmentHistory(parentId, limit);

            // Convert to JSON
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < history.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Map<String, Object> item = history.get(i);
                json.append("{")
                        .append("\"packageName\":\"").append(escapeJson(item.get("packageName").toString())).append("\"")
                        .append(",\"studentName\":\"").append(escapeJson(item.get("studentName").toString())).append("\"")
                        .append(",\"assignmentDate\":\"").append(escapeJson(item.get("assignmentDate").toString())).append("\"")
                        .append(",\"status\":\"").append(escapeJson(item.get("status").toString())).append("\"")
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    private void activateStudyPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int result = dao.activateStudyPackage(id);
            if (result > 0) {
                request.setAttribute("message", "Study package activated successfully!");
            } else {
                request.setAttribute("errorMessage", "Cannot activate study package!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format!");
        }
        response.sendRedirect("study_package");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Study Package Controller with package management";
    }
}
