/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.StudyPackage;

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
import java.util.List;
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
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER) && !AuthUtil.hasRole(request, RoleConstants.PARENT)) {
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
            // For admin/teacher, show all packages
            list = dao.getStudyPackage("SELECT * FROM study_package ORDER BY created_at DESC");
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
                    // Check if package has available slots
                    if (!studentPackageDAO.hasAvailableSlots(id)) {
                        request.setAttribute("errorMessage", "This package has reached maximum student limit.");
                        listStudyPackage(request, response);
                        return;
                    }

                    request.setAttribute("packageId", id);
                    request.setAttribute("packageName", sp.getName());
                    request.setAttribute("amount", Double.parseDouble(sp.getPrice()));
                    request.setAttribute("userId", account.getId());
                    request.setAttribute("studyPackage", sp);

                    // Get parent's children for assignment
                    try {
                        List<Student> children = studentDAO.getStudentsByParentId(account.getId());
                        request.setAttribute("children", children);

                        // Also get grades for display
                        List<Grade> grades = gradeDAO.findAllFromGrade();
                        request.setAttribute("gradeList", grades);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    request.getRequestDispatcher("/studypackage/purchase.jsp").forward(request, response);
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

        if (account != null && RoleConstants.PARENT.equals(account.getRole())) {
            List<StudentPackage> studentPackages = studentPackageDAO.getStudentPackagesByParent(account.getId());
            request.setAttribute("studentPackages", studentPackages);
            request.getRequestDispatcher("/studypackage/myPackages.jsp").forward(request, response);
        } else {
            response.sendRedirect("/error.jsp");
        }
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
        return "Study Package Controller with enhanced package management";
    }
}
