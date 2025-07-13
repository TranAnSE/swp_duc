/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import dal.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
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
@WebServlet("/video-viewer")
public class VideoViewerController extends HttpServlet {

    private CourseDAO courseDAO = new CourseDAO();
    private StudentProgressDAO progressDAO = new StudentProgressDAO();
    private TestRecordDAO testRecordDAO = new TestRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String courseIdParam = request.getParameter("courseId");
        String lessonIdParam = request.getParameter("lessonId");

        try {
            if (courseIdParam != null) {
                // Course-based viewing
                handleCourseViewing(request, response, courseIdParam, lessonIdParam);
            } else if (lessonIdParam != null) {
                // Legacy lesson-based viewing - redirect to course viewer
                redirectToCourseLessonViewer(request, response, lessonIdParam);
            } else {
                // No parameters - show course selection
                showCourseSelection(request, response);
            }
        } catch (NumberFormatException e) {
            handleError(request, response, "Invalid course or lesson ID format", "/dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "An error occurred while loading the course", "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("markTextLessonCompleted".equals(action)) {
            markTextLessonCompleted(request, response);
        }
    }

    private void markTextLessonCompleted(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");

            if (student == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Student not found in session\"}");
                return;
            }

            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            boolean success = progressDAO.markTextLessonAsCompleted(student.getId(), lessonId, courseId);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Lesson marked as completed\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to mark lesson as completed\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }

    private void handleCourseViewing(HttpServletRequest request, HttpServletResponse response,
            String courseIdParam, String lessonIdParam)
            throws ServletException, IOException, SQLException {

        int courseId = Integer.parseInt(courseIdParam);

        // Get course structure
        Map<String, Object> courseStructure = courseDAO.getCourseStructureForViewer(courseId);
        if (courseStructure == null) {
            handleError(request, response, "Course not found", "/dashboard");
            return;
        }

        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("student");
        Account account = (Account) session.getAttribute("account");

        // Check access for students
        if (student != null) {
            if (!courseDAO.hasStudentAccessToCourse(student.getId(), courseId)) {
                handleError(request, response, "You don't have access to this course", "/dashboard");
                return;
            }
        }

        // Get current lesson
        Map<String, Object> currentLesson = null;
        if (lessonIdParam != null) {
            int lessonId = Integer.parseInt(lessonIdParam);
            currentLesson = findLessonInCourse(courseStructure, lessonId);

            if (currentLesson == null) {
                handleError(request, response, "Lesson not found in this course", "/video-viewer?courseId=" + courseId);
                return;
            }
        } else {
            // Get first lesson in course
            currentLesson = getFirstLessonInCourse(courseStructure);
            if (currentLesson == null) {
                handleError(request, response, "No accessible lessons found in this course", "/dashboard");
                return;
            }
        }

        // Get progress data for students
        Map<Integer, StudentLessonProgress> lessonProgressMap = new HashMap<>();
        StudentCourseProgress courseProgress = null;
        Map<Integer, Map<String, Object>> testResults = new HashMap<>();

        if (student != null) {
            lessonProgressMap = progressDAO.getLessonProgressMap(student.getId(), courseId);
            courseProgress = progressDAO.getCourseProgress(student.getId(), courseId);

            // Get test results for this course
            testResults = testRecordDAO.getCourseTestResultsForStudent(student.getId(), courseId);

            // Initialize course progress if not exists
            if (courseProgress == null) {
                progressDAO.updateCourseProgress(student.getId(), courseId);
                courseProgress = progressDAO.getCourseProgress(student.getId(), courseId);
            }
        }

        // Get navigation lessons
        Map<String, Object> navigation = getNavigationLessons(courseStructure,
                (Integer) currentLesson.get("lesson_id"));

        // Set user role for UI
        String userRole = getUserRole(request);
        boolean isTrackingEnabled = student != null; // Only track progress for students

        // Set attributes
        request.setAttribute("courseStructure", courseStructure);
        request.setAttribute("currentLesson", currentLesson);
        request.setAttribute("lessonProgressMap", lessonProgressMap);
        request.setAttribute("courseProgress", courseProgress);
        request.setAttribute("testResults", testResults); // Add test results
        request.setAttribute("navigation", navigation);
        request.setAttribute("userRole", userRole);
        request.setAttribute("isTrackingEnabled", isTrackingEnabled);
        request.setAttribute("courseId", courseId);

        request.getRequestDispatcher("/lesson/videoViewer.jsp").forward(request, response);
    }

    private void redirectToCourseLessonViewer(HttpServletRequest request, HttpServletResponse response,
            String lessonIdParam) throws IOException, SQLException {
        try {
            int lessonId = Integer.parseInt(lessonIdParam);

            // Find course that contains this lesson
            String sql = """
                SELECT DISTINCT cl.course_id 
                FROM course_lesson cl 
                WHERE cl.lesson_id = ? AND cl.is_active = 1
                LIMIT 1
            """;

            try (var ps = courseDAO.getConnection().prepareStatement(sql)) {
                ps.setInt(1, lessonId);
                var rs = ps.executeQuery();

                if (rs.next()) {
                    int courseId = rs.getInt("course_id");
                    response.sendRedirect("/video-viewer?courseId=" + courseId + "&lessonId=" + lessonId);
                    return;
                }
            }

            // If lesson not found in any course, redirect to course selection
            handleError(request, response, "Lesson not found in any course", "/dashboard");

        } catch (NumberFormatException e) {
            handleError(request, response, "Invalid lesson ID", "/dashboard");
        }
    }

    private void showCourseSelection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("student");

        if (student == null) {
            // For non-students, redirect to appropriate home
            String userRole = getUserRole(request);
            switch (userRole) {
                case "admin":
                    response.sendRedirect("/dashboard?action=admin");
                    break;
                case "teacher":
                    response.sendRedirect("/dashboard?action=teacher");
                    break;
                case "parent":
                    response.sendRedirect("/dashboard?action=parent");
                    break;
                default:
                    response.sendRedirect("/login.jsp");
            }
            return;
        }

        // Get accessible courses for student
        List<Map<String, Object>> accessibleCourses = courseDAO.getAccessibleCoursesForStudent(student.getId());

        if (accessibleCourses.isEmpty()) {
            handleError(request, response, "No accessible courses found. Please contact your parent to purchase courses.", "/dashboard");
            return;
        }

        // If only one course, redirect directly to it
        if (accessibleCourses.size() == 1) {
            Map<String, Object> course = accessibleCourses.get(0);
            int courseId = (Integer) course.get("course_id");
            response.sendRedirect("/video-viewer?courseId=" + courseId);
            return;
        }

        // Show course selection page
        request.setAttribute("accessibleCourses", accessibleCourses);
        request.getRequestDispatcher("/studypackage/myPackages.jsp").forward(request, response);
    }

    private Map<String, Object> findLessonInCourse(Map<String, Object> courseStructure, int lessonId) {
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> chapters = (List<Map<String, Object>>) courseStructure.get("chapters");

        for (Map<String, Object> chapter : chapters) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> lessons = (List<Map<String, Object>>) chapter.get("lessons");

            for (Map<String, Object> lesson : lessons) {
                if ((Integer) lesson.get("lesson_id") == lessonId) {
                    // Add chapter info to lesson
                    lesson.put("chapter_name", chapter.get("chapter_name"));
                    lesson.put("chapter_id", chapter.get("chapter_id"));
                    return lesson;
                }
            }
        }
        return null;
    }

    private Map<String, Object> getFirstLessonInCourse(Map<String, Object> courseStructure) {
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> chapters = (List<Map<String, Object>>) courseStructure.get("chapters");

        for (Map<String, Object> chapter : chapters) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> lessons = (List<Map<String, Object>>) chapter.get("lessons");

            if (!lessons.isEmpty()) {
                Map<String, Object> firstLesson = lessons.get(0);
                // Add chapter info to lesson
                firstLesson.put("chapter_name", chapter.get("chapter_name"));
                firstLesson.put("chapter_id", chapter.get("chapter_id"));
                return firstLesson;
            }
        }
        return null;
    }

    private Map<String, Object> getNavigationLessons(Map<String, Object> courseStructure, int currentLessonId) {
        Map<String, Object> navigation = new HashMap<>();

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> chapters = (List<Map<String, Object>>) courseStructure.get("chapters");

        // Build flat list of lessons in order
        List<Map<String, Object>> allLessons = new ArrayList<>();
        for (Map<String, Object> chapter : chapters) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> lessons = (List<Map<String, Object>>) chapter.get("lessons");
            for (Map<String, Object> lesson : lessons) {
                // Add chapter info
                lesson.put("chapter_name", chapter.get("chapter_name"));
                allLessons.add(lesson);
            }
        }

        // Find current lesson index and set navigation
        for (int i = 0; i < allLessons.size(); i++) {
            if ((Integer) allLessons.get(i).get("lesson_id") == currentLessonId) {
                if (i > 0) {
                    navigation.put("previousLesson", allLessons.get(i - 1));
                }
                if (i < allLessons.size() - 1) {
                    navigation.put("nextLesson", allLessons.get(i + 1));
                }
                break;
            }
        }

        return navigation;
    }

    private String getUserRole(HttpServletRequest request) {
        if (AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            return "admin";
        }
        if (AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            return "teacher";
        }
        if (AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            return "parent";
        }
        if (AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            return "student";
        }
        return "guest";
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String errorMessage, String redirectUrl) throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", errorMessage);
        response.sendRedirect(redirectUrl);
    }
}
