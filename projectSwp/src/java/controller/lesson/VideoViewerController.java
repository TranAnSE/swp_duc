/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import dal.LessonDAO;
import dal.ChapterDAO;
import dal.DAOSubject;
import dal.GradeDAO;
import dal.PackageAccessLogDAO;
import dal.PackageSubjectDAO;
import dal.StudentDAO;
import dal.StudentPackageDAO;
import dal.StudyPackageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Lesson;
import model.Chapter;
import model.Subject;
import model.Grade;
import model.Student;
import model.Account;
import model.StudyPackage;
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

    private LessonDAO lessonDAO = new LessonDAO();
    private ChapterDAO chapterDAO = new ChapterDAO();
    private DAOSubject subjectDAO = new DAOSubject();
    private GradeDAO gradeDAO = new GradeDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private StudyPackageDAO studyPackageDAO = new StudyPackageDAO();
    private StudentPackageDAO studentPackageDAO = new StudentPackageDAO();
    private PackageAccessLogDAO accessLogDAO = new PackageAccessLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.ADMIN) //                && !AuthUtil.hasRole(request, RoleConstants.PARENT)
                ) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String lessonIdParam = request.getParameter("lessonId");
        if (lessonIdParam == null || lessonIdParam.isEmpty()) {
            try {
                redirectToFirstAvailableLesson(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("/LessonURL");
            }
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonIdParam);

            // Get current lesson
            Lesson currentLesson = lessonDAO.getLessonById(lessonId);
            if (currentLesson == null) {
                request.setAttribute("error", "Lesson not found");
                request.getRequestDispatcher("/lesson/lessonList.jsp").forward(request, response);
                return;
            }

            // Check permission to view this lesson
            if (!hasPermissionToViewLesson(request, currentLesson)) {
                request.setAttribute("error", "You don't have permission to view this lesson");
                request.getRequestDispatcher("/lesson/lessonList.jsp").forward(request, response);
                return;
            }

            // Get current chapter and subject info
            Chapter currentChapter = chapterDAO.findChapterById(currentLesson.getChapter_id());
            Subject currentSubject = null;
            Grade currentGrade = null;

            if (currentChapter != null) {
                currentSubject = subjectDAO.findById(currentChapter.getSubject_id());
                if (currentSubject != null) {
                    currentGrade = gradeDAO.getGradeById(currentSubject.getGrade_id());
                }
            }

            // Build course structure based on user role
            Map<String, Object> courseStructure = buildCourseStructureByRole(request);

            // Get related lessons in same chapter
            List<Lesson> relatedLessons = getRelatedLessons(currentLesson.getChapter_id(), lessonId);

            // Get lesson statistics
            Map<String, Object> lessonStats = getLessonStatistics(currentLesson);

            // Get user role for UI customization
            String userRole = getUserRole(request);

            // Set attributes
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("currentChapter", currentChapter);
            request.setAttribute("currentSubject", currentSubject);
            request.setAttribute("currentGrade", currentGrade);
            request.setAttribute("courseStructure", courseStructure);
            request.setAttribute("relatedLessons", relatedLessons);
            request.setAttribute("lessonStats", lessonStats);
            request.setAttribute("userRole", userRole);

            request.getRequestDispatcher("/lesson/videoViewer.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            try {
                redirectToFirstAvailableLesson(request, response);
            } catch (SQLException ex) {
                ex.printStackTrace();
                response.sendRedirect("/LessonURL");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the lesson");
            request.getRequestDispatcher("/lesson/lessonList.jsp").forward(request, response);
        }
    }

    private boolean hasPermissionToViewLesson(HttpServletRequest request, Lesson lesson) throws SQLException {
        HttpSession session = request.getSession();

        // Admin and Teacher can view all lessons
        if (AuthUtil.hasRole(request, RoleConstants.ADMIN) || AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            return true;
        }

        // Student access control with package system
        if (AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            Student student = (Student) session.getAttribute("student");
            if (student != null) {
                // Check if student has package access to this lesson
                Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
                if (chapter != null) {
                    Subject subject = subjectDAO.findById(chapter.getSubject_id());
                    if (subject != null) {
                        // Get student's accessible packages
                        List<StudyPackage> accessiblePackages = studyPackageDAO.getStudentAccessiblePackages(student.getId());

                        for (StudyPackage pkg : accessiblePackages) {
                            // Check if package covers this lesson
                            if (packageCoversLesson(pkg, subject, lesson)) {
                                // Log access
                                accessLogDAO.logAccess(student.getId(), pkg.getId(), lesson.getId(), "LESSON_ACCESS");
                                return true;
                            }
                        }

                        // Fallback: check if lesson matches student's grade (for backward compatibility)
                        return subject.getGrade_id() == student.getGrade_id();
                    }
                }
            }
            return false;
        }

        // Parent can view lessons from their children's accessible packages
        if (AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            Account parent = (Account) session.getAttribute("account");
            if (parent != null) {
                try {
                    List<Student> children = studentDAO.getStudentsByParentId(parent.getId());
                    Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
                    if (chapter != null) {
                        Subject subject = subjectDAO.findById(chapter.getSubject_id());
                        if (subject != null) {
                            for (Student child : children) {
                                List<StudyPackage> accessiblePackages = studyPackageDAO.getStudentAccessiblePackages(child.getId());
                                for (StudyPackage pkg : accessiblePackages) {
                                    if (packageCoversLesson(pkg, subject, lesson)) {
                                        return true;
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            return false;
        }

        return false;
    }

    // Helper method to check if package covers a lesson
    private boolean packageCoversLesson(StudyPackage pkg, Subject subject, Lesson lesson) {
        if ("GRADE_ALL".equals(pkg.getType())) {
            // Package covers all subjects in the grade
            return pkg.getGrade_id() != null && pkg.getGrade_id().equals(subject.getGrade_id());
        } else if ("SUBJECT_COMBO".equals(pkg.getType())) {
            // Check if subject is included in package subjects
            // This would require checking package_subject table
            PackageSubjectDAO packageSubjectDAO = new PackageSubjectDAO();
            // Implementation would depend on your package_subject structure
            return true; // Simplified for now
        }
        return false;
    }

    private Map<String, Object> buildCourseStructureByRole(HttpServletRequest request) throws SQLException {
        Map<String, Object> structure = new HashMap<>();
        List<Map<String, Object>> grades = new ArrayList<>();

        HttpSession session = request.getSession();
        List<Integer> allowedGradeIds = getAllowedGradeIds(request);

        List<Grade> allGrades = gradeDAO.findAllFromGrade();

        for (Grade grade : allGrades) {
            // Filter grades based on user role
            if (!allowedGradeIds.isEmpty() && !allowedGradeIds.contains(grade.getId())) {
                continue;
            }

            Map<String, Object> gradeMap = new HashMap<>();
            gradeMap.put("grade", grade);

            List<Subject> subjects = subjectDAO.findAll();
            List<Map<String, Object>> gradeSubjects = new ArrayList<>();

            for (Subject subject : subjects) {
                if (subject.getGrade_id() == grade.getId()) {
                    Map<String, Object> subjectMap = new HashMap<>();
                    subjectMap.put("subject", subject);

                    List<Chapter> chapters = chapterDAO.getChapter(
                            "SELECT * FROM chapter WHERE subject_id = " + subject.getId()
                    );
                    List<Map<String, Object>> subjectChapters = new ArrayList<>();

                    for (Chapter chapter : chapters) {
                        Map<String, Object> chapterMap = new HashMap<>();
                        chapterMap.put("chapter", chapter);

                        List<Lesson> lessons = lessonDAO.getAllLessons();
                        List<Lesson> chapterLessons = new ArrayList<>();
                        for (Lesson lesson : lessons) {
                            if (lesson.getChapter_id() == chapter.getId()) {
                                chapterLessons.add(lesson);
                            }
                        }

                        if (!chapterLessons.isEmpty()) {
                            chapterMap.put("lessons", chapterLessons);
                            subjectChapters.add(chapterMap);
                        }
                    }

                    if (!subjectChapters.isEmpty()) {
                        subjectMap.put("chapters", subjectChapters);
                        gradeSubjects.add(subjectMap);
                    }
                }
            }

            if (!gradeSubjects.isEmpty()) {
                gradeMap.put("subjects", gradeSubjects);
                grades.add(gradeMap);
            }
        }

        structure.put("grades", grades);
        return structure;
    }

    private List<Integer> getAllowedGradeIds(HttpServletRequest request) throws SQLException {
        List<Integer> allowedGradeIds = new ArrayList<>();
        HttpSession session = request.getSession();

        // Admin and Teacher can see all grades
        if (AuthUtil.hasRole(request, RoleConstants.ADMIN) || AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            return allowedGradeIds; // Empty list means all grades allowed
        }

        // Student can only see their grade
        if (AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            Student student = (Student) session.getAttribute("student");
            if (student != null) {
                allowedGradeIds.add(student.getGrade_id());
            }
        }

        // Parent can see their children's grades
        if (AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            Account parent = (Account) session.getAttribute("account");
            if (parent != null) {
                List<Student> children = studentDAO.getStudentsByParentId(parent.getId());
                for (Student child : children) {
                    if (!allowedGradeIds.contains(child.getGrade_id())) {
                        allowedGradeIds.add(child.getGrade_id());
                    }
                }
            }
        }

        return allowedGradeIds;
    }

    private void redirectToFirstAvailableLesson(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        List<Integer> allowedGradeIds = getAllowedGradeIds(request);
        List<Lesson> allLessons = lessonDAO.getAllLessons();

        for (Lesson lesson : allLessons) {
            if (hasPermissionToViewLesson(request, lesson)) {
                response.sendRedirect("/video-viewer?lessonId=" + lesson.getId());
                return;
            }
        }

        // No lessons available, redirect to lesson list
        response.sendRedirect("/LessonURL");
    }

    private List<Lesson> getRelatedLessons(int chapterId, int currentLessonId) {
        List<Lesson> allLessons = lessonDAO.getAllLessons();
        List<Lesson> relatedLessons = new ArrayList<>();

        for (Lesson lesson : allLessons) {
            if (lesson.getChapter_id() == chapterId && lesson.getId() != currentLessonId) {
                relatedLessons.add(lesson);
            }
        }

        return relatedLessons;
    }

    private Map<String, Object> getLessonStatistics(Lesson lesson) {
        Map<String, Object> stats = new HashMap<>();

        // Calculate estimated duration based on content length
        String content = lesson.getContent();
        int estimatedMinutes = Math.max(5, (content != null ? content.length() / 200 : 5));

        stats.put("hasVideo", lesson.getVideo_link() != null && !lesson.getVideo_link().trim().isEmpty());
        stats.put("estimatedDuration", estimatedMinutes + " minutes");
        stats.put("contentLength", content != null ? content.length() : 0);

        return stats;
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
}
