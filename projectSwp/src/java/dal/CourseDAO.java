/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 *
 * @author ankha
 */
public class CourseDAO extends DBContext {

    public int createCourse(StudyPackage course, int subjectId, int createdBy) throws SQLException {
        String sql = "INSERT INTO study_package (course_title, price, type, subject_id, duration_days, "
                + "description, max_students, is_active, approval_status, created_by, created_at) "
                + "VALUES (?, ?, 'COURSE', ?, ?, ?, 1, 0, 'DRAFT', ?, CURRENT_TIMESTAMP)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getPrice());
            ps.setInt(3, subjectId);
            ps.setInt(4, course.getDuration_days());
            ps.setString(5, course.getDescription());
            ps.setInt(6, createdBy);

            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<Map<String, Object>> getAllCoursesWithDetails() throws SQLException {
        String sql = "SELECT * FROM course_management_view ORDER BY created_at DESC";
        List<Map<String, Object>> courses = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("course_id", rs.getInt("course_id"));
                course.put("course_title", rs.getString("course_title"));
                course.put("price", rs.getString("price"));
                course.put("duration_days", rs.getInt("duration_days"));
                course.put("description", rs.getString("description"));
                course.put("approval_status", rs.getString("approval_status"));
                course.put("is_active", rs.getBoolean("is_active"));
                course.put("grade_name", rs.getString("grade_name"));
                course.put("subject_name", rs.getString("subject_name"));
                course.put("created_by_name", rs.getString("created_by_name"));
                course.put("approved_by_name", rs.getString("approved_by_name"));
                course.put("total_chapters", rs.getInt("total_chapters"));
                course.put("total_lessons", rs.getInt("total_lessons"));
                course.put("total_tests", rs.getInt("total_tests"));
                course.put("created_at", rs.getTimestamp("created_at"));
                course.put("submitted_at", rs.getTimestamp("submitted_at"));
                course.put("approved_at", rs.getTimestamp("approved_at"));
                courses.add(course);
            }
        }
        return courses;
    }

    public List<Map<String, Object>> getCoursesByTeacher(int teacherId) throws SQLException {
        String sql = "SELECT * FROM course_management_view WHERE created_by = ? ORDER BY created_at DESC";
        List<Map<String, Object>> courses = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("course_id", rs.getInt("course_id"));
                course.put("course_title", rs.getString("course_title"));
                course.put("price", rs.getString("price"));
                course.put("duration_days", rs.getInt("duration_days"));
                course.put("description", rs.getString("description"));
                course.put("approval_status", rs.getString("approval_status"));
                course.put("is_active", rs.getBoolean("is_active"));
                course.put("grade_name", rs.getString("grade_name"));
                course.put("subject_name", rs.getString("subject_name"));
                course.put("total_chapters", rs.getInt("total_chapters"));
                course.put("total_lessons", rs.getInt("total_lessons"));
                course.put("total_tests", rs.getInt("total_tests"));
                course.put("created_at", rs.getTimestamp("created_at"));
                course.put("submitted_at", rs.getTimestamp("submitted_at"));
                courses.add(course);
            }
        }
        return courses;
    }

    public List<Map<String, Object>> getApprovedCourses() throws SQLException {
        String sql = "SELECT * FROM course_management_view WHERE approval_status = 'APPROVED' AND is_active = 1 ORDER BY created_at DESC";
        List<Map<String, Object>> courses = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("course_id", rs.getInt("course_id"));
                course.put("course_title", rs.getString("course_title"));
                course.put("price", rs.getString("price"));
                course.put("duration_days", rs.getInt("duration_days"));
                course.put("description", rs.getString("description"));
                course.put("grade_name", rs.getString("grade_name"));
                course.put("subject_name", rs.getString("subject_name"));
                course.put("total_chapters", rs.getInt("total_chapters"));
                course.put("total_lessons", rs.getInt("total_lessons"));
                course.put("total_tests", rs.getInt("total_tests"));
                courses.add(course);
            }
        }
        return courses;
    }

    public Map<String, Object> getCourseDetails(int courseId) throws SQLException {
        String sql = "SELECT sp.*, s.name as subject_name, s.id as subject_id, g.name as grade_name, g.id as grade_id "
                + "FROM study_package sp "
                + "JOIN subject s ON sp.subject_id = s.id "
                + "JOIN grade g ON s.grade_id = g.id "
                + "WHERE sp.id = ? AND sp.type = 'COURSE'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("course_id", rs.getInt("id"));
                course.put("course_title", rs.getString("course_title"));
                course.put("price", rs.getString("price"));
                course.put("duration_days", rs.getInt("duration_days"));
                course.put("description", rs.getString("description"));
                course.put("approval_status", rs.getString("approval_status"));
                course.put("is_active", rs.getBoolean("is_active"));
                course.put("subject_id", rs.getInt("subject_id"));
                course.put("subject_name", rs.getString("subject_name"));
                course.put("grade_id", rs.getInt("grade_id"));
                course.put("grade_name", rs.getString("grade_name"));
                course.put("created_by", rs.getInt("created_by"));
                course.put("created_at", rs.getTimestamp("created_at"));
                course.put("submitted_at", rs.getTimestamp("submitted_at"));
                course.put("approved_at", rs.getTimestamp("approved_at"));
                course.put("rejection_reason", rs.getString("rejection_reason"));
                return course;
            }
        }
        return null;
    }

    public List<Map<String, Object>> getCourseChapters(int courseId) throws SQLException {
        String sql = "SELECT cc.*, c.name as chapter_name, c.description as chapter_description "
                + "FROM course_chapter cc "
                + "JOIN chapter c ON cc.chapter_id = c.id "
                + "WHERE cc.course_id = ? AND cc.is_active = 1 "
                + "ORDER BY cc.display_order";

        List<Map<String, Object>> chapters = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> chapter = new HashMap<>();
                chapter.put("id", rs.getInt("id"));
                chapter.put("chapter_id", rs.getInt("chapter_id"));
                chapter.put("chapter_name", rs.getString("chapter_name"));
                chapter.put("chapter_description", rs.getString("chapter_description"));
                chapter.put("display_order", rs.getInt("display_order"));
                chapters.add(chapter);
            }
        }
        return chapters;
    }

    public List<Map<String, Object>> getCourseLessons(int courseId) throws SQLException {
        String sql = "SELECT cl.*, l.name as lesson_name, l.content as lesson_content, c.name as chapter_name "
                + "FROM course_lesson cl "
                + "JOIN lesson l ON cl.lesson_id = l.id "
                + "JOIN chapter c ON cl.chapter_id = c.id "
                + "WHERE cl.course_id = ? AND cl.is_active = 1 "
                + "ORDER BY cl.display_order";

        List<Map<String, Object>> lessons = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> lesson = new HashMap<>();
                lesson.put("id", rs.getInt("id"));
                lesson.put("lesson_id", rs.getInt("lesson_id"));
                lesson.put("lesson_name", rs.getString("lesson_name"));
                lesson.put("lesson_content", rs.getString("lesson_content"));
                lesson.put("chapter_name", rs.getString("chapter_name"));
                lesson.put("lesson_type", rs.getString("lesson_type"));
                lesson.put("display_order", rs.getInt("display_order"));
                lessons.add(lesson);
            }
        }
        return lessons;
    }

    public List<Map<String, Object>> getCourseTests(int courseId) throws SQLException {
        String sql = "SELECT ct.*, t.name as test_name, t.description as test_description, c.name as chapter_name "
                + "FROM course_test ct "
                + "JOIN test t ON ct.test_id = t.id "
                + "LEFT JOIN chapter c ON ct.chapter_id = c.id "
                + "WHERE ct.course_id = ? AND ct.is_active = 1 "
                + "ORDER BY ct.display_order";

        List<Map<String, Object>> tests = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> test = new HashMap<>();
                test.put("id", rs.getInt("id"));
                test.put("test_id", rs.getInt("test_id"));
                test.put("test_name", rs.getString("test_name"));
                test.put("test_description", rs.getString("test_description"));
                test.put("chapter_name", rs.getString("chapter_name"));
                test.put("test_type", rs.getString("test_type"));
                test.put("display_order", rs.getInt("display_order"));
                tests.add(test);
            }
        }
        return tests;
    }

    public boolean submitCourseForApproval(int courseId) throws SQLException {
        String sql = "UPDATE study_package SET approval_status = 'PENDING_APPROVAL', submitted_at = CURRENT_TIMESTAMP "
                + "WHERE id = ? AND type = 'COURSE' AND approval_status = 'DRAFT'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean approveCourse(int courseId, int adminId) throws SQLException {
        String sql = "UPDATE study_package SET approval_status = 'APPROVED', approved_at = CURRENT_TIMESTAMP, "
                + "approved_by = ?, is_active = 1 WHERE id = ? AND type = 'COURSE' AND approval_status = 'PENDING_APPROVAL'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean rejectCourse(int courseId, String rejectionReason) throws SQLException {
        String sql = "UPDATE study_package SET approval_status = 'REJECTED', rejection_reason = ? "
                + "WHERE id = ? AND type = 'COURSE' AND approval_status = 'PENDING_APPROVAL'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, rejectionReason);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean activateCourse(int courseId) throws SQLException {
        String sql = "UPDATE study_package SET is_active = 1 WHERE id = ? AND type = 'COURSE' AND approval_status = 'APPROVED'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deactivateCourse(int courseId) throws SQLException {
        String sql = "UPDATE study_package SET is_active = 0 WHERE id = ? AND type = 'COURSE'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addChapterToCourse(int courseId, int chapterId, int displayOrder) throws SQLException {
        String sql = "INSERT INTO course_chapter (course_id, chapter_id, display_order) VALUES (?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE display_order = ?, is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, chapterId);
            ps.setInt(3, displayOrder);
            ps.setInt(4, displayOrder);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addLessonToCourse(int courseId, int lessonId, int chapterId, int displayOrder, String lessonType) throws SQLException {
        String sql = "INSERT INTO course_lesson (course_id, lesson_id, chapter_id, display_order, lesson_type) "
                + "VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE display_order = ?, lesson_type = ?, is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, lessonId);
            ps.setInt(3, chapterId);
            ps.setInt(4, displayOrder);
            ps.setString(5, lessonType);
            ps.setInt(6, displayOrder);
            ps.setString(7, lessonType);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addTestToCourse(int courseId, int testId, Integer chapterId, int displayOrder, String testType) throws SQLException {
        String sql = "INSERT INTO course_test (course_id, test_id, chapter_id, display_order, test_type) "
                + "VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE display_order = ?, test_type = ?, is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, testId);
            if (chapterId != null) {
                ps.setInt(3, chapterId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setInt(4, displayOrder);
            ps.setString(5, testType);
            ps.setInt(6, displayOrder);
            ps.setString(7, testType);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateCourse(int courseId, String courseTitle, String price,
            int durationDays, String description, int subjectId) throws SQLException {
        String sql = "UPDATE study_package SET course_title = ?, price = ?, duration_days = ?, "
                + "description = ?, subject_id = ?, updated_at = CURRENT_TIMESTAMP "
                + "WHERE id = ? AND type = 'COURSE'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, courseTitle);
            ps.setString(2, price);
            ps.setInt(3, durationDays);
            ps.setString(4, description);
            ps.setInt(5, subjectId);
            ps.setInt(6, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    public int getNextChapterOrder(int courseId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(display_order), 0) + 1 FROM course_chapter WHERE course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    public int getNextLessonOrder(int courseId, int chapterId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(display_order), 0) + 1 FROM course_lesson WHERE course_id = ? AND chapter_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, chapterId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    public boolean removeChapterFromCourse(int courseId, int chapterId) throws SQLException {
        String sql = "UPDATE course_chapter SET is_active = 0 WHERE course_id = ? AND chapter_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, chapterId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean removeLessonFromCourse(int courseId, int lessonId) throws SQLException {
        String sql = "UPDATE course_lesson SET is_active = 0 WHERE course_id = ? AND lesson_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, lessonId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean reorderCourseContent(int courseId, String contentType, String[] contentIds) throws SQLException {
        String tableName;
        String idColumn;

        switch (contentType.toLowerCase()) {
            case "chapter":
                tableName = "course_chapter";
                idColumn = "chapter_id";
                break;
            case "lesson":
                tableName = "course_lesson";
                idColumn = "lesson_id";
                break;
            case "test":
                tableName = "course_test";
                idColumn = "test_id";
                break;
            default:
                return false;
        }

        String sql = "UPDATE " + tableName + " SET display_order = ? WHERE course_id = ? AND " + idColumn + " = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < contentIds.length; i++) {
                ps.setInt(1, i + 1);
                ps.setInt(2, courseId);
                ps.setInt(3, Integer.parseInt(contentIds[i]));
                ps.addBatch();
            }
            int[] results = ps.executeBatch();

            // Check if all updates were successful
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        }
    }

    public boolean updateCourseTimestamp(int courseId) throws SQLException {
        String sql = "UPDATE study_package SET updated_at = CURRENT_TIMESTAMP WHERE id = ? AND type = 'COURSE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        }
    }
}
