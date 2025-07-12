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
        String getGradeSql = "SELECT grade_id FROM subject WHERE id = ?";
        int gradeId = 0;

        try (PreparedStatement ps = connection.prepareStatement(getGradeSql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                gradeId = rs.getInt("grade_id");
            } else {
                throw new SQLException("Subject not found");
            }
        }

        String sql = "INSERT INTO study_package (course_title, price, type, subject_id, grade_id, duration_days, "
                + "description, max_students, is_active, approval_status, created_by, created_at) "
                + "VALUES (?, ?, 'COURSE', ?, ?, ?, ?, 1, 0, 'DRAFT', ?, CURRENT_TIMESTAMP)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getPrice());
            ps.setInt(3, subjectId);
            ps.setInt(4, gradeId);
            ps.setInt(5, course.getDuration_days());
            ps.setString(6, course.getDescription());
            ps.setInt(7, createdBy);

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
        String sql = "SELECT cl.*, l.name as lesson_name, l.content as lesson_content, l.video_link, c.name as chapter_name "
                + "FROM course_lesson cl "
                + "JOIN lesson l ON cl.lesson_id = l.id "
                + "JOIN chapter c ON cl.chapter_id = c.id "
                + "WHERE cl.course_id = ? AND cl.is_active = 1 "
                + "ORDER BY cl.chapter_id, cl.display_order";

        List<Map<String, Object>> lessons = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> lesson = new HashMap<>();
                lesson.put("id", rs.getInt("id"));
                lesson.put("lesson_id", rs.getInt("lesson_id"));
                lesson.put("chapter_id", rs.getInt("chapter_id"));
                lesson.put("lesson_name", rs.getString("lesson_name"));
                lesson.put("lesson_content", rs.getString("lesson_content"));
                lesson.put("video_link", rs.getString("video_link"));
                lesson.put("chapter_name", rs.getString("chapter_name"));
                lesson.put("lesson_type", rs.getString("lesson_type"));
                lesson.put("display_order", rs.getInt("display_order"));
                lessons.add(lesson);
            }
        }
        return lessons;
    }

    public List<Map<String, Object>> getCourseTests(int courseId) throws SQLException {
        String sql = "SELECT ct.*, t.name as test_name, t.description as test_description, "
                + "t.is_practice, t.duration_minutes, t.num_questions, c.name as chapter_name "
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
                test.put("is_practice", rs.getBoolean("is_practice"));
                test.put("duration_minutes", rs.getInt("duration_minutes"));
                test.put("num_questions", rs.getInt("num_questions"));
                test.put("chapter_id", rs.getObject("chapter_id"));
                test.put("chapter_name", rs.getString("chapter_name"));
                test.put("test_type", rs.getString("test_type"));
                test.put("display_order", rs.getInt("display_order"));
                tests.add(test);
            }
        }
        return tests;
    }

    public List<Map<String, Object>> getAvailableTestsForCourse(int courseId, int subjectId) throws SQLException {
        String sql = "SELECT t.*, "
                + "CASE WHEN ct.test_id IS NOT NULL THEN 1 ELSE 0 END as is_in_course "
                + "FROM test t "
                + "LEFT JOIN course_test ct ON t.id = ct.test_id AND ct.course_id = ? AND ct.is_active = 1 "
                + "WHERE (t.course_id IS NULL OR t.course_id = ?) "
                + "ORDER BY t.name";

        List<Map<String, Object>> tests = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> test = new HashMap<>();
                test.put("id", rs.getInt("id"));
                test.put("name", rs.getString("name"));
                test.put("description", rs.getString("description"));
                test.put("is_practice", rs.getBoolean("is_practice"));
                test.put("duration_minutes", rs.getInt("duration_minutes"));
                test.put("num_questions", rs.getInt("num_questions"));
                test.put("is_in_course", rs.getBoolean("is_in_course"));
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
        // Check if chapter already exists
        String checkSql = "SELECT COUNT(*) FROM course_chapter WHERE course_id = ? AND chapter_id = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, courseId);
            checkPs.setInt(2, chapterId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("Chapter already exists in course, updating display order");
                // Update existing record
                String updateSql = "UPDATE course_chapter SET display_order = ?, is_active = 1 WHERE course_id = ? AND chapter_id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
                    updatePs.setInt(1, displayOrder);
                    updatePs.setInt(2, courseId);
                    updatePs.setInt(3, chapterId);
                    return updatePs.executeUpdate() > 0;
                }
            }
        }

        // Insert new record
        String sql = "INSERT INTO course_chapter (course_id, chapter_id, display_order, is_active) VALUES (?, ?, ?, 1)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, chapterId);
            ps.setInt(3, displayOrder);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addLessonToCourse(int courseId, int lessonId, int chapterId, int displayOrder, String lessonType) throws SQLException {
        // First check if lesson already exists (active or inactive)
        String checkSql = "SELECT COUNT(*) FROM course_lesson WHERE course_id = ? AND lesson_id = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, courseId);
            checkPs.setInt(2, lessonId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("Lesson already exists in course, updating instead of inserting");
                // Update existing record
                String updateSql = "UPDATE course_lesson SET chapter_id = ?, display_order = ?, lesson_type = ?, is_active = 1 WHERE course_id = ? AND lesson_id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
                    updatePs.setInt(1, chapterId);
                    updatePs.setInt(2, displayOrder);
                    updatePs.setString(3, lessonType);
                    updatePs.setInt(4, courseId);
                    updatePs.setInt(5, lessonId);
                    int result = updatePs.executeUpdate();
                    System.out.println("addLessonToCourse - Updated existing record, result: " + result);
                    return result > 0;
                }
            }
        }

        // Insert new record
        String sql = "INSERT INTO course_lesson (course_id, lesson_id, chapter_id, display_order, lesson_type, is_active) "
                + "VALUES (?, ?, ?, ?, ?, 1)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, lessonId);
            ps.setInt(3, chapterId);
            ps.setInt(4, displayOrder);
            ps.setString(5, lessonType);

            int result = ps.executeUpdate();
            System.out.println("addLessonToCourse - Insert result: " + result);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error in addLessonToCourse: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public boolean addTestToCourse(int courseId, int testId, Integer chapterId, int displayOrder, String testType) throws SQLException {
        // Check if test already exists
        String checkSql = "SELECT COUNT(*) FROM course_test WHERE course_id = ? AND test_id = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, courseId);
            checkPs.setInt(2, testId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Update existing record
                String updateSql = "UPDATE course_test SET chapter_id = ?, display_order = ?, test_type = ?, is_active = 1 WHERE course_id = ? AND test_id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
                    if (chapterId != null) {
                        updatePs.setInt(1, chapterId);
                    } else {
                        updatePs.setNull(1, Types.INTEGER);
                    }
                    updatePs.setInt(2, displayOrder);
                    updatePs.setString(3, testType);
                    updatePs.setInt(4, courseId);
                    updatePs.setInt(5, testId);
                    return updatePs.executeUpdate() > 0;
                }
            }
        }

        // Insert new record
        String sql = "INSERT INTO course_test (course_id, test_id, chapter_id, display_order, test_type, is_active) "
                + "VALUES (?, ?, ?, ?, ?, 1)";

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
            return ps.executeUpdate() > 0;
        }
    }

    public boolean removeTestFromCourse(int courseId, int testId) throws SQLException {
        String sql = "DELETE FROM course_test WHERE course_id = ? AND test_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, testId);
            return ps.executeUpdate() > 0;
        }
    }

    public int getNextTestOrder(int courseId, Integer chapterId) throws SQLException {
        String sql;
        if (chapterId != null) {
            sql = "SELECT COALESCE(MAX(display_order), 0) + 1 FROM course_test WHERE course_id = ? AND chapter_id = ? AND is_active = 1";
        } else {
            sql = "SELECT COALESCE(MAX(display_order), 0) + 1 FROM course_test WHERE course_id = ? AND chapter_id IS NULL AND is_active = 1";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            if (chapterId != null) {
                ps.setInt(2, chapterId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    public boolean updateCourse(int courseId, String courseTitle, String price,
            int durationDays, String description, int subjectId) throws SQLException {
        String getGradeSql = "SELECT grade_id FROM subject WHERE id = ?";
        int gradeId = 0;

        try (PreparedStatement ps = connection.prepareStatement(getGradeSql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                gradeId = rs.getInt("grade_id");
            } else {
                throw new SQLException("Subject not found");
            }
        }

        String sql = "UPDATE study_package SET course_title = ?, price = ?, duration_days = ?, "
                + "description = ?, subject_id = ?, grade_id = ?, updated_at = CURRENT_TIMESTAMP "
                + "WHERE id = ? AND type = 'COURSE'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, courseTitle);
            ps.setString(2, price);
            ps.setInt(3, durationDays);
            ps.setString(4, description);
            ps.setInt(5, subjectId);
            ps.setInt(6, gradeId);
            ps.setInt(7, courseId);

            int result = ps.executeUpdate();
            System.out.println("Updated course " + courseId + " with description: " + description);
            return result > 0;
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
        String sql = "SELECT COALESCE(MAX(display_order), 0) + 1 FROM course_lesson WHERE course_id = ? AND chapter_id = ? AND is_active = 1";
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
        try {
            connection.setAutoCommit(false);

            // First remove all lessons in this chapter from the course
            String removeLessonsSql = "DELETE FROM course_lesson WHERE course_id = ? AND chapter_id = ?";
            try (PreparedStatement ps1 = connection.prepareStatement(removeLessonsSql)) {
                ps1.setInt(1, courseId);
                ps1.setInt(2, chapterId);
                ps1.executeUpdate();
            }

            // Then remove the chapter from the course
            String removeChapterSql = "DELETE FROM course_chapter WHERE course_id = ? AND chapter_id = ?";
            try (PreparedStatement ps2 = connection.prepareStatement(removeChapterSql)) {
                ps2.setInt(1, courseId);
                ps2.setInt(2, chapterId);
                int result = ps2.executeUpdate();

                connection.commit();
                return result > 0;
            }
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public boolean removeLessonFromCourse(int courseId, int lessonId) throws SQLException {
        String sql = "DELETE FROM course_lesson WHERE course_id = ? AND lesson_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, lessonId);
            int result = ps.executeUpdate();
            System.out.println("removeLessonFromCourse - Deleted " + result + " records for courseId=" + courseId + ", lessonId=" + lessonId);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error in removeLessonFromCourse: " + e.getMessage());
            e.printStackTrace();
            throw e;
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

    public List<Map<String, Object>> getAllCoursesWithFiltersAndPagination(
            Integer subjectId, Integer gradeId, String status, String searchKeyword,
            int page, int pageSize) throws SQLException {

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM course_management_view WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Add filters
        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
        }

        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND approval_status = ?");
            params.add(status);
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (course_title LIKE ? OR description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        return executeCoursesQuery(sql.toString(), params);
    }

    public List<Map<String, Object>> getCoursesByTeacherWithFiltersAndPagination(
            int teacherId, Integer subjectId, Integer gradeId, String status,
            String searchKeyword, int page, int pageSize) throws SQLException {

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM course_management_view WHERE created_by = ?"
        );
        List<Object> params = new ArrayList<>();
        params.add(teacherId);

        // Add filters
        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
        }

        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND approval_status = ?");
            params.add(status);
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (course_title LIKE ? OR description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        return executeCoursesQuery(sql.toString(), params);
    }

    public List<Map<String, Object>> getApprovedCoursesWithFiltersAndPagination(
            Integer subjectId, Integer gradeId, String searchKeyword,
            int page, int pageSize) throws SQLException {

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM course_management_view WHERE approval_status = 'APPROVED' AND is_active = 1"
        );
        List<Object> params = new ArrayList<>();

        // Add filters
        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (course_title LIKE ? OR description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        return executeCoursesQuery(sql.toString(), params);
    }

    public int getTotalCoursesCount(Integer subjectId, Integer gradeId, String status, String searchKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM course_management_view WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Add filters
        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
        }

        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND approval_status = ?");
            params.add(status);
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (course_title LIKE ? OR description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        return executeCountQuery(sql.toString(), params);
    }

    public int getTotalCoursesByTeacherCount(int teacherId, Integer subjectId, Integer gradeId, String status, String searchKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM course_management_view WHERE created_by = ?"
        );
        List<Object> params = new ArrayList<>();
        params.add(teacherId);

        // Add filters
        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
        }

        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            sql.append(" AND approval_status = ?");
            params.add(status);
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (course_title LIKE ? OR description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        return executeCountQuery(sql.toString(), params);
    }

    public int getTotalApprovedCoursesCount(Integer subjectId, Integer gradeId, String searchKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM course_management_view WHERE approval_status = 'APPROVED' AND is_active = 1"
        );
        List<Object> params = new ArrayList<>();

        // Add filters
        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (course_title LIKE ? OR description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        return executeCountQuery(sql.toString(), params);
    }

    private List<Map<String, Object>> executeCoursesQuery(String sql, List<Object> params) throws SQLException {
        List<Map<String, Object>> courses = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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
                course.put("subject_id", rs.getInt("subject_id"));
                course.put("grade_id", rs.getInt("grade_id"));
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

    private int executeCountQuery(String sql, List<Object> params) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean reorderLessonsInChapter(int courseId, int chapterId, String[] lessonIds) throws SQLException {
        String sql = "UPDATE course_lesson SET display_order = ? WHERE course_id = ? AND chapter_id = ? AND lesson_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            connection.setAutoCommit(false);

            for (int i = 0; i < lessonIds.length; i++) {
                ps.setInt(1, i + 1); // display_order starts from 1
                ps.setInt(2, courseId);
                ps.setInt(3, chapterId);
                ps.setInt(4, Integer.parseInt(lessonIds[i]));
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            connection.commit();

            // Check if all updates were successful
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }

            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public List<Integer> getAddedChaptersForCourse(int courseId) throws SQLException {
        List<Integer> chapterIds = new ArrayList<>();
        String sql = "SELECT chapter_id FROM course_chapter WHERE course_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                chapterIds.add(rs.getInt("chapter_id"));
            }
        }

        return chapterIds;
    }

    public List<Integer> getAddedLessonsForCourse(int courseId) throws SQLException {
        List<Integer> lessonIds = new ArrayList<>();
        String sql = "SELECT lesson_id FROM course_lesson WHERE course_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lessonIds.add(rs.getInt("lesson_id"));
            }
        }

        return lessonIds;
    }

    public List<Integer> getAddedLessonsForChapter(int courseId, int chapterId) throws SQLException {
        List<Integer> lessonIds = new ArrayList<>();
        String sql = "SELECT lesson_id FROM course_lesson WHERE course_id = ? AND chapter_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, chapterId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lessonIds.add(rs.getInt("lesson_id"));
            }
        }

        return lessonIds;
    }

    public boolean isLessonInCourse(int courseId, int lessonId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM course_lesson WHERE course_id = ? AND lesson_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, lessonId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }

        return false;
    }

    public boolean isChapterInCourse(int courseId, int chapterId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM course_chapter WHERE course_id = ? AND chapter_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, chapterId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }

        return false;
    }

    public List<Map<String, Object>> getCourseContentStructure(int courseId) throws SQLException {
        String sql = """
        SELECT 
            'chapter' as content_type,
            cc.chapter_id as content_id,
            c.name as content_name,
            c.description as content_description,
            cc.display_order,
            0 as parent_id
        FROM course_chapter cc
        JOIN chapter c ON cc.chapter_id = c.id
        WHERE cc.course_id = ? AND cc.is_active = 1
        
        UNION ALL
        
        SELECT 
            'lesson' as content_type,
            cl.lesson_id as content_id,
            l.name as content_name,
            l.content as content_description,
            cl.display_order,
            cl.chapter_id as parent_id
        FROM course_lesson cl
        JOIN lesson l ON cl.lesson_id = l.id
        WHERE cl.course_id = ? AND cl.is_active = 1
        
        ORDER BY parent_id, display_order
        """;

        List<Map<String, Object>> content = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, courseId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("content_type", rs.getString("content_type"));
                item.put("content_id", rs.getInt("content_id"));
                item.put("content_name", rs.getString("content_name"));
                item.put("content_description", rs.getString("content_description"));
                item.put("display_order", rs.getInt("display_order"));
                item.put("parent_id", rs.getInt("parent_id"));
                content.add(item);
            }
        }
        return content;
    }

    public Map<String, Object> getCourseStructureForViewer(int courseId) throws SQLException {
        Map<String, Object> courseStructure = new HashMap<>();

        // Get course details
        Map<String, Object> courseDetails = getCourseDetails(courseId);
        if (courseDetails == null) {
            return null;
        }

        courseStructure.put("course", courseDetails);

        // Get chapters with lessons
        String sql = """
        SELECT 
            cc.chapter_id,
            c.name as chapter_name,
            c.description as chapter_description,
            cc.display_order as chapter_order
        FROM course_chapter cc
        JOIN chapter c ON cc.chapter_id = c.id
        WHERE cc.course_id = ? AND cc.is_active = 1
        ORDER BY cc.display_order
        """;

        List<Map<String, Object>> chapters = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> chapter = new HashMap<>();
                chapter.put("chapter_id", rs.getInt("chapter_id"));
                chapter.put("chapter_name", rs.getString("chapter_name"));
                chapter.put("chapter_description", rs.getString("chapter_description"));
                chapter.put("chapter_order", rs.getInt("chapter_order"));

                // Get lessons for this chapter
                List<Map<String, Object>> lessons = getCourseLessonsForChapter(courseId, rs.getInt("chapter_id"));
                chapter.put("lessons", lessons);

                chapters.add(chapter);
            }
        }

        courseStructure.put("chapters", chapters);
        return courseStructure;
    }

    public List<Map<String, Object>> getCourseLessonsForChapter(int courseId, int chapterId) throws SQLException {
        String sql = """
        SELECT 
            cl.lesson_id,
            l.name as lesson_name,
            l.content as lesson_content,
            l.video_link,
            cl.display_order,
            cl.lesson_type
        FROM course_lesson cl
        JOIN lesson l ON cl.lesson_id = l.id
        WHERE cl.course_id = ? AND cl.chapter_id = ? AND cl.is_active = 1
        ORDER BY cl.display_order
        """;

        List<Map<String, Object>> lessons = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, chapterId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> lesson = new HashMap<>();
                lesson.put("lesson_id", rs.getInt("lesson_id"));
                lesson.put("lesson_name", rs.getString("lesson_name"));
                lesson.put("lesson_content", rs.getString("lesson_content"));
                lesson.put("video_link", rs.getString("video_link"));
                lesson.put("display_order", rs.getInt("display_order"));
                lesson.put("lesson_type", rs.getString("lesson_type"));
                lessons.add(lesson);
            }
        }
        return lessons;
    }

    public Map<String, Object> getFirstLessonInCourse(int courseId) throws SQLException {
        String sql = """
        SELECT 
            cl.lesson_id,
            l.name as lesson_name,
            l.content as lesson_content,
            l.video_link,
            cl.chapter_id,
            c.name as chapter_name
        FROM course_lesson cl
        JOIN lesson l ON cl.lesson_id = l.id
        JOIN chapter c ON cl.chapter_id = c.id
        JOIN course_chapter cc ON cl.chapter_id = cc.chapter_id AND cl.course_id = cc.course_id
        WHERE cl.course_id = ? AND cl.is_active = 1 AND cc.is_active = 1
        ORDER BY cc.display_order, cl.display_order
        LIMIT 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> lesson = new HashMap<>();
                lesson.put("lesson_id", rs.getInt("lesson_id"));
                lesson.put("lesson_name", rs.getString("lesson_name"));
                lesson.put("lesson_content", rs.getString("lesson_content"));
                lesson.put("video_link", rs.getString("video_link"));
                lesson.put("chapter_id", rs.getInt("chapter_id"));
                lesson.put("chapter_name", rs.getString("chapter_name"));
                return lesson;
            }
        }
        return null;
    }

    public Map<String, Object> getLessonInCourse(int courseId, int lessonId) throws SQLException {
        String sql = """
        SELECT 
            cl.lesson_id,
            l.name as lesson_name,
            l.content as lesson_content,
            l.video_link,
            cl.chapter_id,
            c.name as chapter_name,
            cl.display_order as lesson_order,
            cc.display_order as chapter_order
        FROM course_lesson cl
        JOIN lesson l ON cl.lesson_id = l.id
        JOIN chapter c ON cl.chapter_id = c.id
        JOIN course_chapter cc ON cl.chapter_id = cc.chapter_id AND cl.course_id = cc.course_id
        WHERE cl.course_id = ? AND cl.lesson_id = ? AND cl.is_active = 1 AND cc.is_active = 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, lessonId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> lesson = new HashMap<>();
                lesson.put("lesson_id", rs.getInt("lesson_id"));
                lesson.put("lesson_name", rs.getString("lesson_name"));
                lesson.put("lesson_content", rs.getString("lesson_content"));
                lesson.put("video_link", rs.getString("video_link"));
                lesson.put("chapter_id", rs.getInt("chapter_id"));
                lesson.put("chapter_name", rs.getString("chapter_name"));
                lesson.put("lesson_order", rs.getInt("lesson_order"));
                lesson.put("chapter_order", rs.getInt("chapter_order"));
                return lesson;
            }
        }
        return null;
    }

    public List<Map<String, Object>> getNextPreviousLessons(int courseId, int currentLessonId) throws SQLException {
        String sql = """
        WITH lesson_sequence AS (
            SELECT 
                cl.lesson_id,
                l.name as lesson_name,
                ROW_NUMBER() OVER (ORDER BY cc.display_order, cl.display_order) as sequence_num
            FROM course_lesson cl
            JOIN lesson l ON cl.lesson_id = l.id
            JOIN course_chapter cc ON cl.chapter_id = cc.chapter_id AND cl.course_id = cc.course_id
            WHERE cl.course_id = ? AND cl.is_active = 1 AND cc.is_active = 1
        ),
        current_lesson AS (
            SELECT sequence_num FROM lesson_sequence WHERE lesson_id = ?
        )
        SELECT 
            ls.lesson_id,
            ls.lesson_name,
            CASE 
                WHEN ls.sequence_num = (SELECT sequence_num FROM current_lesson) - 1 THEN 'previous'
                WHEN ls.sequence_num = (SELECT sequence_num FROM current_lesson) + 1 THEN 'next'
            END as position
        FROM lesson_sequence ls, current_lesson cl
        WHERE ls.sequence_num IN (cl.sequence_num - 1, cl.sequence_num + 1)
        """;

        List<Map<String, Object>> navigation = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, currentLessonId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> nav = new HashMap<>();
                nav.put("lesson_id", rs.getInt("lesson_id"));
                nav.put("lesson_name", rs.getString("lesson_name"));
                nav.put("position", rs.getString("position"));
                navigation.add(nav);
            }
        }
        return navigation;
    }

    public boolean reorderTests(int courseId, String[] testIds) throws SQLException {
        String sql = "UPDATE course_test SET display_order = ? WHERE course_id = ? AND test_id = ? AND is_active = 1";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            connection.setAutoCommit(false);

            for (int i = 0; i < testIds.length; i++) {
                ps.setInt(1, i + 1); // display_order starts from 1
                ps.setInt(2, courseId);
                ps.setInt(3, Integer.parseInt(testIds[i]));
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            connection.commit();

            // Check if all updates were successful
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }

            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public boolean updateTestPosition(int courseId, int testId, Integer chapterId, Integer lessonId, int displayOrder) throws SQLException {
        try {
            connection.setAutoCommit(false);

            // Update course_test table
            String updateCourseTest = "UPDATE course_test SET chapter_id = ?, display_order = ? WHERE course_id = ? AND test_id = ?";
            try (PreparedStatement ps1 = connection.prepareStatement(updateCourseTest)) {
                if (chapterId != null) {
                    ps1.setInt(1, chapterId);
                } else {
                    ps1.setNull(1, Types.INTEGER);
                }
                ps1.setInt(2, displayOrder);
                ps1.setInt(3, courseId);
                ps1.setInt(4, testId);
                ps1.executeUpdate();
            }

            // Update test table for lesson assignment
            String updateTest = "UPDATE test SET lesson_id = ? WHERE id = ?";
            try (PreparedStatement ps2 = connection.prepareStatement(updateTest)) {
                if (lessonId != null) {
                    ps2.setInt(1, lessonId);
                } else {
                    ps2.setNull(1, Types.INTEGER);
                }
                ps2.setInt(2, testId);
                ps2.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public List<Map<String, Object>> getAvailableTestsForCourseWithDetails(int courseId, int subjectId) throws SQLException {
        String sql = "SELECT t.*, "
                + "CASE WHEN ct.test_id IS NOT NULL THEN 1 ELSE 0 END as is_in_course, "
                + "creator.full_name as created_by_name, "
                + "COUNT(tq.question_id) as total_questions, "
                + "COALESCE(t.duration_minutes, 30) as duration_minutes, "
                + "COALESCE(t.num_questions, 10) as num_questions "
                + "FROM test t "
                + "LEFT JOIN course_test ct ON t.id = ct.test_id AND ct.course_id = ? AND ct.is_active = 1 "
                + "LEFT JOIN account creator ON t.created_by = creator.id "
                + "LEFT JOIN test_question tq ON t.id = tq.test_id "
                + "WHERE (t.course_id IS NULL OR t.course_id = ?) "
                + "GROUP BY t.id, t.name, t.description, t.is_practice, t.duration_minutes, "
                + "t.num_questions, t.created_at, creator.full_name, ct.test_id "
                + "ORDER BY t.created_at DESC";

        List<Map<String, Object>> tests = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> test = new HashMap<>();
                test.put("id", rs.getInt("id"));
                test.put("name", rs.getString("name"));
                test.put("description", rs.getString("description"));
                test.put("is_practice", rs.getBoolean("is_practice"));

                // Ensure we get proper values for duration and questions
                int durationMinutes = rs.getInt("duration_minutes");
                int numQuestions = rs.getInt("num_questions");
                int totalQuestions = rs.getInt("total_questions");

                test.put("duration_minutes", durationMinutes > 0 ? durationMinutes : 30);
                test.put("num_questions", numQuestions > 0 ? numQuestions : 10);
                test.put("total_questions", totalQuestions);
                test.put("is_in_course", rs.getBoolean("is_in_course"));
                test.put("created_by_name", rs.getString("created_by_name"));
                test.put("created_at", rs.getTimestamp("created_at"));
                tests.add(test);
            }
        }
        return tests;
    }

    public List<Map<String, Object>> getCourseTestsStructured(int courseId) throws SQLException {
        String sql = """
        SELECT ct.*, t.name as test_name, t.description as test_description, 
               t.is_practice, t.duration_minutes, t.num_questions, 
               c.name as chapter_name, l.name as lesson_name,
               t.lesson_id
        FROM course_test ct
        JOIN test t ON ct.test_id = t.id
        LEFT JOIN chapter c ON ct.chapter_id = c.id
        LEFT JOIN lesson l ON t.lesson_id = l.id
        WHERE ct.course_id = ? AND ct.is_active = 1
        ORDER BY 
            CASE WHEN ct.chapter_id IS NULL THEN 0 ELSE 1 END,
            ct.chapter_id,
            CASE WHEN t.lesson_id IS NULL THEN 0 ELSE 1 END,
            t.lesson_id,
            ct.display_order
        """;

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
                test.put("is_practice", rs.getBoolean("is_practice"));
                test.put("duration_minutes", rs.getInt("duration_minutes"));
                test.put("num_questions", rs.getInt("num_questions"));
                test.put("chapter_id", rs.getObject("chapter_id"));
                test.put("chapter_name", rs.getString("chapter_name"));
                test.put("lesson_id", rs.getObject("lesson_id"));
                test.put("lesson_name", rs.getString("lesson_name"));
                test.put("test_type", rs.getString("test_type"));
                test.put("display_order", rs.getInt("display_order"));

                // Determine test position context
                if (rs.getObject("lesson_id") != null) {
                    test.put("position_context", "lesson");
                    test.put("position_name", rs.getString("lesson_name"));
                } else if (rs.getObject("chapter_id") != null) {
                    test.put("position_context", "chapter");
                    test.put("position_name", rs.getString("chapter_name"));
                } else {
                    test.put("position_context", "course");
                    test.put("position_name", "Course Level");
                }

                tests.add(test);
            }
        }
        return tests;
    }
}
