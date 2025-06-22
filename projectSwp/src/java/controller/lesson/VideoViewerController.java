/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.lesson;

import dal.LessonDAO;
import dal.ChapterDAO;
import dal.DAOSubject;
import dal.GradeDAO;
import dal.StudentDAO;
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
import util.AuthUtil;
import util.RoleConstants;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication - allow students, teachers, admin, parents
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.ADMIN)
                && !AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String lessonIdParam = request.getParameter("lessonId");
        if (lessonIdParam == null || lessonIdParam.isEmpty()) {
            response.sendRedirect("/LessonURL");
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

            // Get current chapter info
            Chapter currentChapter = chapterDAO.findChapterById(currentLesson.getChapter_id());

            // Get current subject info
            Subject currentSubject = null;
            if (currentChapter != null) {
                currentSubject = subjectDAO.findById(currentChapter.getSubject_id());
            }

            // Get student's grade if student is logged in
            Integer studentGradeId = null;
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");
            if (student != null) {
                studentGradeId = student.getGrade_id();
            }

            // Build course structure for sidebar
            Map<String, Object> courseStructure = buildCourseStructure(studentGradeId);

            // Get related lessons in same chapter
            List<Lesson> relatedLessons = getRelatedLessons(currentLesson.getChapter_id(), lessonId);

            // Get lesson statistics
            Map<String, Object> lessonStats = getLessonStatistics(lessonId);

            // Set attributes
            request.setAttribute("currentLesson", currentLesson);
            request.setAttribute("currentChapter", currentChapter);
            request.setAttribute("currentSubject", currentSubject);
            request.setAttribute("courseStructure", courseStructure);
            request.setAttribute("relatedLessons", relatedLessons);
            request.setAttribute("lessonStats", lessonStats);

            request.getRequestDispatcher("/lesson/videoViewer.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/LessonURL");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the lesson");
            request.getRequestDispatcher("/lesson/lessonList.jsp").forward(request, response);
        }
    }

    private Map<String, Object> buildCourseStructure(Integer studentGradeId) throws SQLException {
        Map<String, Object> structure = new HashMap<>();
        List<Map<String, Object>> grades = new ArrayList<>();

        List<Grade> allGrades = gradeDAO.findAllFromGrade();

        for (Grade grade : allGrades) {
            // Fix: So sánh int với Integer đúng cách
            if (studentGradeId != null && grade.getId() != studentGradeId.intValue()) {
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
                        chapterMap.put("lessons", chapterLessons);
                        subjectChapters.add(chapterMap);
                    }

                    subjectMap.put("chapters", subjectChapters);
                    gradeSubjects.add(subjectMap);
                }
            }

            gradeMap.put("subjects", gradeSubjects);
            grades.add(gradeMap);
        }

        structure.put("grades", grades);
        return structure;
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

    private Map<String, Object> getLessonStatistics(int lessonId) {
        Map<String, Object> stats = new HashMap<>();

        // Basic stats that don't require database changes
        stats.put("hasVideo", true); // We can check if video_link is not empty
        stats.put("estimatedDuration", "15 minutes"); // Default estimation
        stats.put("difficulty", "Intermediate"); // Default level

        return stats;
    }
}
