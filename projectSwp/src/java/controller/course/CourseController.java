/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.course;

import dal.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.AuthUtil;
import util.RoleConstants;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

/**
 *
 * @author ankha
 */
@WebServlet("/course")
public class CourseController extends HttpServlet {

    private StudyPackageDAO courseDAO = new StudyPackageDAO();
    private DAOSubject subjectDAO = new DAOSubject();
    private GradeDAO gradeDAO = new GradeDAO();
    private ChapterDAO chapterDAO = new ChapterDAO();
    private LessonDAO lessonDAO = new LessonDAO();
    private CourseDAO courseManagementDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.PARENT)
                && !AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "create":
                    showCreateForm(request, response);
                    break;
                case "build":
                    showBuildCourse(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "detail":
                    showCourseDetail(request, response);
                    break;
                case "submit":
                    submitForApproval(request, response);
                    break;
                case "approve":
                    approveCourse(request, response);
                    break;
                case "reject":
                    rejectCourse(request, response);
                    break;
                case "activate":
                    activateCourse(request, response);
                    break;
                case "deactivate":
                    deactivateCourse(request, response);
                    break;
                case "getChapters":
                    getChaptersBySubject(request, response);
                    return;
                case "getLessons":
                    getLessonsByChapter(request, response);
                    return;
                default:
                    listCourses(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            listCourses(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authorization first
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)) {

            // For AJAX requests, return JSON error
            if (isAjaxRequest(request)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Access denied\"}");
                return;
            } else {
                response.sendRedirect("/error.jsp");
                return;
            }
        }

        String action = request.getParameter("action");
        System.out.println("CourseController POST - Action: " + action); // Debug log

        try {
            switch (action) {
                case "create":
                    createCourse(request, response);
                    break;
                case "update":
                    updateCourse(request, response);
                    break;
                case "addChapter":
                    System.out.println("Processing addChapter request"); // Debug log
                    addChapterToCourse(request, response);
                    break;
                case "removeChapter":
                    removeChapterFromCourse(request, response);
                    break;
                case "addLesson":
                    addLessonToCourse(request, response);
                    break;
                case "removeLesson":
                    removeLessonFromCourse(request, response);
                    break;
                case "reorderContent":
                    reorderCourseContent(request, response);
                    break;
                case "saveDraft":
                    saveDraft(request, response);
                    break;
                case "submit":
                    submitForApprovalPost(request, response);
                    break;
                default:
                    System.out.println("Unknown action: " + action); // Debug log
                    if (isAjaxRequest(request)) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\": false, \"message\": \"Unknown action: " + action + "\"}");
                    } else {
                        response.sendRedirect("course");
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in CourseController POST: " + e.getMessage()); // Debug log

            // Return JSON error response for AJAX requests
            if (isAjaxRequest(request)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
            } else {
                request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
                response.sendRedirect("course");
            }
        }
    }

    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");

            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 5) {
                        pageSize = 5;
                    }
                    if (pageSize > 50) {
                        pageSize = 50;
                    }
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }

            // Get filter parameters
            String subjectIdParam = request.getParameter("subjectId");
            String gradeIdParam = request.getParameter("gradeId");
            String statusFilter = request.getParameter("status");
            String searchKeyword = request.getParameter("search");

            Integer subjectId = null;
            Integer gradeId = null;

            if (subjectIdParam != null && !subjectIdParam.isEmpty()) {
                try {
                    subjectId = Integer.parseInt(subjectIdParam);
                } catch (NumberFormatException e) {
                    // Ignore invalid subject ID
                }
            }

            if (gradeIdParam != null && !gradeIdParam.isEmpty()) {
                try {
                    gradeId = Integer.parseInt(gradeIdParam);
                } catch (NumberFormatException e) {
                    // Ignore invalid grade ID
                }
            }

            List<Map<String, Object>> courses;
            int totalCourses = 0;

            if (AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
                // Admin can see all courses with filters
                courses = courseManagementDAO.getAllCoursesWithFiltersAndPagination(
                        subjectId, gradeId, statusFilter, searchKeyword, page, pageSize);
                totalCourses = courseManagementDAO.getTotalCoursesCount(
                        subjectId, gradeId, statusFilter, searchKeyword);
            } else if (AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
                // Teacher can only see their own courses with filters
                courses = courseManagementDAO.getCoursesByTeacherWithFiltersAndPagination(
                        account.getId(), subjectId, gradeId, statusFilter, searchKeyword, page, pageSize);
                totalCourses = courseManagementDAO.getTotalCoursesByTeacherCount(
                        account.getId(), subjectId, gradeId, statusFilter, searchKeyword);
            } else {
                // Parent and Student can only see approved and active courses
                courses = courseManagementDAO.getApprovedCoursesWithFiltersAndPagination(
                        subjectId, gradeId, searchKeyword, page, pageSize);
                totalCourses = courseManagementDAO.getTotalApprovedCoursesCount(
                        subjectId, gradeId, searchKeyword);
            }

            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalCourses / pageSize);
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);

            // Calculate display range
            int displayStart = (page - 1) * pageSize + 1;
            int displayEnd = Math.min(page * pageSize, totalCourses);

            // Load filter options
            List<Grade> grades = gradeDAO.findAllFromGrade();
            List<Subject> subjects = subjectDAO.findAll();

            // Set attributes
            request.setAttribute("courses", courses);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("grades", grades);
            request.setAttribute("subjects", subjects);

            request.setAttribute("displayStart", displayStart);
            request.setAttribute("displayEnd", displayEnd);

            // Preserve filter parameters
            request.setAttribute("selectedSubjectId", subjectId);
            request.setAttribute("selectedGradeId", gradeId);
            request.setAttribute("selectedStatus", statusFilter);
            request.setAttribute("searchKeyword", searchKeyword);

            request.getRequestDispatcher("/course/courseList.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading courses: " + e.getMessage());
            request.getRequestDispatcher("/course/courseList.jsp").forward(request, response);
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Check if coming from subject creation
            HttpSession session = request.getSession();
            Boolean subjectCreated = (Boolean) session.getAttribute("subjectCreated");

            if (subjectCreated != null && subjectCreated) {
                Integer subjectId = (Integer) session.getAttribute("newSubjectId");
                String subjectName = (String) session.getAttribute("newSubjectName");
                Integer gradeId = (Integer) session.getAttribute("newSubjectGradeId");

                if (subjectId != null) {
                    request.setAttribute("preSelectedSubjectId", subjectId);
                    request.setAttribute("preSelectedSubjectName", subjectName);
                    request.setAttribute("preSelectedGradeId", gradeId);
                }

                // Clear session attributes
                session.removeAttribute("subjectCreated");
                session.removeAttribute("newSubjectId");
                session.removeAttribute("newSubjectName");
                session.removeAttribute("newSubjectGradeId");
            }

            // Load grades and subjects for form
            List<Grade> grades = gradeDAO.findAllFromGrade();
            List<Subject> subjects = subjectDAO.findAll();

            request.setAttribute("grades", grades);
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("/course/courseForm.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading form: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void createCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            // Get form parameters
            String courseTitle = request.getParameter("courseTitle");
            String price = request.getParameter("price");
            int durationDays = Integer.parseInt(request.getParameter("durationDays"));
            String description = request.getParameter("description");
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));

            // Create new course (StudyPackage with type COURSE)
            StudyPackage course = new StudyPackage();
            course.setName(courseTitle); // Use name field for course title
            course.setPrice(price);
            course.setType("COURSE");
            course.setDuration_days(durationDays);
            course.setDescription(description);
            course.setMax_students(1); // Always 1 for new system
            course.setIs_active(false); // Inactive until approved

            // Set additional fields through DAO
            int courseId = courseManagementDAO.createCourse(course, subjectId, account.getId());

            if (courseId > 0) {
                request.setAttribute("message", "Course created successfully! You can now build the course content.");
                response.sendRedirect("course?action=build&id=" + courseId);
            } else {
                request.setAttribute("errorMessage", "Failed to create course.");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating course: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void showBuildCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("id"));

            // Get course details
            Map<String, Object> courseDetails = courseManagementDAO.getCourseDetails(courseId);
            if (courseDetails == null) {
                request.setAttribute("errorMessage", "Course not found.");
                response.sendRedirect("course");
                return;
            }

            // Check if user can edit this course
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
                Integer createdBy = (Integer) courseDetails.get("created_by");
                if (createdBy == null || !createdBy.equals(account.getId())) {
                    request.setAttribute("errorMessage", "You don't have permission to edit this course.");
                    response.sendRedirect("course");
                    return;
                }

                // Check if course is in editable state
                String approvalStatus = (String) courseDetails.get("approval_status");
                if ("PENDING_APPROVAL".equals(approvalStatus)) {
                    request.setAttribute("errorMessage", "Course is pending approval and cannot be edited.");
                    response.sendRedirect("course");
                    return;
                }
            }

            // Get course content
            List<Map<String, Object>> courseChapters = courseManagementDAO.getCourseChapters(courseId);
            List<Map<String, Object>> courseLessons = courseManagementDAO.getCourseLessons(courseId);
            List<Map<String, Object>> courseTests = courseManagementDAO.getCourseTests(courseId);

            // Get available chapters for the subject
            Integer subjectId = (Integer) courseDetails.get("subject_id");
            List<Chapter> availableChapters = chapterDAO.findChapterBySubjectId(subjectId);

            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("courseChapters", courseChapters);
            request.setAttribute("courseLessons", courseLessons);
            request.setAttribute("courseTests", courseTests);
            request.setAttribute("availableChapters", availableChapters);
            request.setAttribute("courseId", courseId);

            request.getRequestDispatcher("/course/buildCourse.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading course builder: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("id"));

            Map<String, Object> courseDetails = courseManagementDAO.getCourseDetails(courseId);
            if (courseDetails == null) {
                request.setAttribute("errorMessage", "Course not found.");
                response.sendRedirect("course");
                return;
            }

            // Check permissions
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
                Integer createdBy = (Integer) courseDetails.get("created_by");
                if (createdBy == null || !createdBy.equals(account.getId())) {
                    request.setAttribute("errorMessage", "You don't have permission to edit this course.");
                    response.sendRedirect("course");
                    return;
                }

                String approvalStatus = (String) courseDetails.get("approval_status");
                if ("PENDING_APPROVAL".equals(approvalStatus)) {
                    request.setAttribute("errorMessage", "Course is pending approval and cannot be edited.");
                    response.sendRedirect("course");
                    return;
                }
            }

            // Load grades and subjects for form
            List<Grade> grades = gradeDAO.findAllFromGrade();
            List<Subject> subjects = subjectDAO.findAll();

            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("grades", grades);
            request.setAttribute("subjects", subjects);
            request.setAttribute("isEdit", true);

            request.getRequestDispatcher("/course/courseForm.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading edit form: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void updateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String courseTitle = request.getParameter("courseTitle");
            String price = request.getParameter("price");
            int durationDays = Integer.parseInt(request.getParameter("durationDays"));
            String description = request.getParameter("description");
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));

            boolean success = courseManagementDAO.updateCourse(courseId, courseTitle, price,
                    durationDays, description, subjectId);

            if (success) {
                request.setAttribute("message", "Course updated successfully!");
                response.sendRedirect("course?action=build&id=" + courseId);
            } else {
                request.setAttribute("errorMessage", "Failed to update course.");
                showEditForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating course: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void addChapterToCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("addChapterToCourse method called"); // Debug log

        // Set response type before any processing
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String courseIdParam = request.getParameter("courseId");
            String chapterIdParam = request.getParameter("chapterId");

            System.out.println("Parameters - courseId: " + courseIdParam + ", chapterId: " + chapterIdParam); // Debug log

            if (courseIdParam == null || chapterIdParam == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing required parameters\"}");
                return;
            }

            int courseId = Integer.parseInt(courseIdParam);
            int chapterId = Integer.parseInt(chapterIdParam);

            // Get next display order
            int displayOrder = courseManagementDAO.getNextChapterOrder(courseId);
            System.out.println("Display order: " + displayOrder); // Debug log

            boolean success = courseManagementDAO.addChapterToCourse(courseId, chapterId, displayOrder);
            System.out.println("Add chapter result: " + success); // Debug log

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Chapter added successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to add chapter\"}");
            }

        } catch (NumberFormatException e) {
            System.out.println("Number format error: " + e.getMessage()); // Debug log
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid number format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception in addChapterToCourse: " + e.getMessage()); // Debug log
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void removeChapterFromCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));

            boolean success = courseManagementDAO.removeChapterFromCourse(courseId, chapterId);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Chapter removed successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to remove chapter\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void addLessonToCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String courseIdParam = request.getParameter("courseId");
            String lessonIdParam = request.getParameter("lessonId");
            String chapterIdParam = request.getParameter("chapterId");
            String lessonTypeParam = request.getParameter("lessonType");

            System.out.println("addLessonToCourse - courseId: " + courseIdParam
                    + ", lessonId: " + lessonIdParam
                    + ", chapterId: " + chapterIdParam);

            if (courseIdParam == null || lessonIdParam == null || chapterIdParam == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing required parameters\"}");
                return;
            }

            int courseId = Integer.parseInt(courseIdParam);
            int lessonId = Integer.parseInt(lessonIdParam);
            int chapterId = Integer.parseInt(chapterIdParam);
            String lessonType = lessonTypeParam != null ? lessonTypeParam : "LESSON";

            // Check if lesson already exists in course using DAO
            List<Map<String, Object>> existingLessons = courseManagementDAO.getCourseLessons(courseId);
            boolean lessonExists = existingLessons.stream()
                    .anyMatch(lesson -> (Integer) lesson.get("lesson_id") == lessonId);

            if (lessonExists) {
                response.getWriter().write("{\"success\": false, \"message\": \"Lesson already exists in this course\"}");
                return;
            }

            // Get next display order
            int displayOrder = courseManagementDAO.getNextLessonOrder(courseId, chapterId);

            boolean success = courseManagementDAO.addLessonToCourse(courseId, lessonId, chapterId, displayOrder, lessonType);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Lesson added successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to add lesson\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void removeLessonFromCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));

            boolean success = courseManagementDAO.removeLessonFromCourse(courseId, lessonId);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Lesson removed successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to remove lesson\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void reorderCourseContent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String contentType = request.getParameter("contentType");
            String[] contentIds = request.getParameterValues("contentIds");

            if (contentIds == null || contentIds.length == 0) {
                response.getWriter().write("{\"success\": false, \"message\": \"No content to reorder\"}");
                return;
            }

            boolean success = courseManagementDAO.reorderCourseContent(courseId, contentType, contentIds);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Content reordered successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to reorder content\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void saveDraft(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            // Update course's updated_at timestamp
            boolean success = courseManagementDAO.updateCourseTimestamp(courseId);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Draft saved successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to save draft\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void submitForApprovalPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            boolean success = courseManagementDAO.submitCourseForApproval(courseId);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Course submitted for approval successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to submit course for approval\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void getChaptersBySubject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            List<Chapter> chapters = chapterDAO.findChapterBySubjectId(subjectId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < chapters.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Chapter chapter = chapters.get(i);
                json.append("{\"id\":").append(chapter.getId())
                        .append(",\"name\":\"").append(escapeJson(chapter.getName()))
                        .append("\",\"description\":\"").append(escapeJson(chapter.getDescription()))
                        .append("\"}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private void getLessonsByChapter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            List<Lesson> allLessons = lessonDAO.getAllLessons();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Lesson lesson : allLessons) {
                if (lesson.getChapter_id() == chapterId) {
                    if (!first) {
                        json.append(",");
                    }
                    json.append("{\"id\":").append(lesson.getId())
                            .append(",\"name\":\"").append(escapeJson(lesson.getName()))
                            .append("\",\"content\":\"").append(escapeJson(lesson.getContent()))
                            .append("\"}");
                    first = false;
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private void submitForApproval(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            boolean success = courseManagementDAO.submitCourseForApproval(courseId);

            if (success) {
                request.setAttribute("message", "Course submitted for approval successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to submit course for approval.");
            }
            response.sendRedirect("course");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error submitting course: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void approveCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            HttpSession session = request.getSession();
            Account admin = (Account) session.getAttribute("account");

            boolean success = courseManagementDAO.approveCourse(courseId, admin.getId());

            if (success) {
                request.setAttribute("message", "Course approved successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to approve course.");
            }

            response.sendRedirect("course");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error approving course: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void rejectCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            String rejectionReason = request.getParameter("rejectionReason");

            boolean success = courseManagementDAO.rejectCourse(courseId, rejectionReason);

            if (success) {
                request.setAttribute("message", "Course rejected successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to reject course.");
            }

            response.sendRedirect("course");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error rejecting course: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void activateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            boolean success = courseManagementDAO.activateCourse(courseId);

            if (success) {
                request.setAttribute("message", "Course activated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to activate course.");
            }

            response.sendRedirect("course");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error activating course: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void deactivateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            boolean success = courseManagementDAO.deactivateCourse(courseId);

            if (success) {
                request.setAttribute("message", "Course deactivated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to deactivate course.");
            }

            response.sendRedirect("course");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deactivating course: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void showCourseDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("id"));
            response.sendRedirect("/video-viewer?courseId=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading course detail: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

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

    // Helper method to detect AJAX requests
    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        String contentType = request.getContentType();

        return "XMLHttpRequest".equals(requestedWith)
                || (accept != null && accept.contains("application/json"))
                || (contentType != null && contentType.contains("application/x-www-form-urlencoded"));
    }
}
