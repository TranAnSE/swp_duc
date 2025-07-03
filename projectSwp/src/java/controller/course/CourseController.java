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
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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

        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createCourse(request, response);
                    break;
                case "update":
                    updateCourse(request, response);
                    break;
                case "addChapter":
                    addChapterToCourse(request, response);
                    break;
                case "addLesson":
                    addLessonToCourse(request, response);
                    break;
                case "reorderContent":
                    reorderCourseContent(request, response);
                    break;
                default:
                    response.sendRedirect("course");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            List<Map<String, Object>> courses;

            if (AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
                // Admin can see all courses
                courses = courseManagementDAO.getAllCoursesWithDetails();
            } else if (AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
                // Teacher can only see their own courses
                courses = courseManagementDAO.getCoursesByTeacher(account.getId());
            } else {
                // Parent and Student can only see approved and active courses
                courses = courseManagementDAO.getApprovedCourses();
            }

            request.setAttribute("courses", courses);
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

            // Redirect to video viewer for this course
            response.sendRedirect("/video-viewer?courseId=" + courseId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading course detail: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for editing course basic info
        // Similar to showCreateForm but with pre-filled data
    }

    private void updateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for updating course basic info
    }

    private void addChapterToCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for adding chapters to course
    }

    private void addLessonToCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for adding lessons to course
    }

    private void reorderCourseContent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for reordering course content
    }
}