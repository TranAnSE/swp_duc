/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Test;
import java.sql.*;
import java.util.*;

/**
 *
 * @author Na
 */
public class TestDAO extends DBContext {

    private Connection conn;

    // ✅ Constructor khởi tạo kết nối
    public TestDAO() {
        try {
            this.conn = getConnection(); // Lấy connection từ DBContext
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int addTest(Test test) {
        String sql;

        if (test.getCourse_id() != null) {
            // Course-integrated test
            sql = "INSERT INTO test (name, description, is_practice, duration_minutes, "
                    + "num_questions, course_id, chapter_id, lesson_id, test_order, created_by) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        } else {
            // Standalone test
            sql = "INSERT INTO test (name, description, is_practice, duration_minutes, "
                    + "num_questions, created_by) VALUES (?, ?, ?, ?, ?, ?)";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, test.getName());
            ps.setString(2, test.getDescription());
            ps.setBoolean(3, test.isIs_practice());
            ps.setInt(4, test.getDuration_minutes());
            ps.setInt(5, test.getNum_questions());

            if (test.getCourse_id() != null) {
                ps.setInt(6, test.getCourse_id());

                if (test.getChapter_id() != null) {
                    ps.setInt(7, test.getChapter_id());
                } else {
                    ps.setNull(7, Types.INTEGER);
                }

                if (test.getLesson_id() != null) {
                    ps.setInt(8, test.getLesson_id());
                } else {
                    ps.setNull(8, Types.INTEGER);
                }

                ps.setInt(9, test.getTest_order());

                if (test.getCreated_by() != null) {
                    ps.setInt(10, test.getCreated_by());
                } else {
                    ps.setNull(10, Types.INTEGER);
                }
            } else {
                if (test.getCreated_by() != null) {
                    ps.setInt(6, test.getCreated_by());
                } else {
                    ps.setNull(6, Types.INTEGER);
                }
            }

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int testId = rs.getInt(1);

                // If this is a course test, also add to course_test table
                if (test.getCourse_id() != null) {
                    addTestToCourse(testId, test.getCourse_id(), test.getChapter_id(), test.getTest_order());
                }

                return testId;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void updateTest(Test test) {
        String sql = "UPDATE test SET name = ?, description = ?, is_practice = ?, "
                + "duration_minutes = ?, num_questions = ?, course_id = ?, chapter_id = ?, "
                + "test_order = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, test.getName());
            ps.setString(2, test.getDescription());
            ps.setBoolean(3, test.isIs_practice());
            ps.setInt(4, test.getDuration_minutes());
            ps.setInt(5, test.getNum_questions());

            if (test.getCourse_id() != null) {
                ps.setInt(6, test.getCourse_id());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            if (test.getChapter_id() != null) {
                ps.setInt(7, test.getChapter_id());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setInt(8, test.getTest_order());
            ps.setInt(9, test.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteTest(int id) {
        try {
            conn.setAutoCommit(false);

            // Delete from course_test table first
            String deleteCourseTest = "DELETE FROM course_test WHERE test_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteCourseTest)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // Delete related records in test_question table
            String deleteTestQuestions = "DELETE FROM test_question WHERE test_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteTestQuestions)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // Delete related records in test_record table
            String deleteTestRecords = "DELETE FROM test_record WHERE test_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteTestRecords)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // Finally delete the test itself
            String deleteTest = "DELETE FROM test WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteTest)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public Test getTestById(int id) {
        String sql = "SELECT * FROM test WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setDescription(rs.getString("description"));
                test.setIs_practice(rs.getBoolean("is_practice"));
                test.setDuration_minutes(rs.getInt("duration_minutes"));
                test.setNum_questions(rs.getInt("num_questions"));
                test.setCourse_id(rs.getObject("course_id", Integer.class));
                test.setChapter_id(rs.getObject("chapter_id", Integer.class));
                test.setTest_order(rs.getInt("test_order"));
                test.setCreated_by(rs.getObject("created_by", Integer.class));

                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    test.setCreated_at(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    test.setUpdated_at(updatedAt.toLocalDateTime());
                }

                return test;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get next test order for course
    public int getNextTestOrder(int courseId, Integer chapterId) {
        String sql;
        if (chapterId != null) {
            sql = "SELECT COALESCE(MAX(test_order), 0) + 1 FROM test WHERE course_id = ? AND chapter_id = ?";
        } else {
            sql = "SELECT COALESCE(MAX(test_order), 0) + 1 FROM test WHERE course_id = ? AND chapter_id IS NULL";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            if (chapterId != null) {
                ps.setInt(2, chapterId);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }

    public List<Test> getAllTests() {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM test ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setDescription(rs.getString("description"));
                test.setIs_practice(rs.getBoolean("is_practice"));
                test.setDuration_minutes(rs.getInt("duration_minutes"));
                test.setNum_questions(rs.getInt("num_questions"));
                test.setCourse_id(rs.getObject("course_id", Integer.class));
                test.setChapter_id(rs.getObject("chapter_id", Integer.class));
                test.setTest_order(rs.getInt("test_order"));
                test.setCreated_by(rs.getObject("created_by", Integer.class));
                list.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tests theo practice/official
    public List<Test> getTestsByType(boolean isPractice) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM test WHERE is_practice = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isPractice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setDescription(rs.getString("description"));
                test.setIs_practice(rs.getBoolean("is_practice"));
                test.setDuration_minutes(rs.getInt("duration_minutes"));
                test.setNum_questions(rs.getInt("num_questions"));
                test.setCourse_id(rs.getObject("course_id", Integer.class));
                test.setChapter_id(rs.getObject("chapter_id", Integer.class));
                test.setTest_order(rs.getInt("test_order"));
                test.setCreated_by(rs.getObject("created_by", Integer.class));
                list.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Kiểm tra và hiển thị thông tin test chi tiết
    public void debugTestInfo(int testId) {
        System.out.println("\n===== DEBUG TEST INFO: ID=" + testId + " =====");

        try {
            String testSql = "SELECT t.*, sp.course_title, c.name as chapter_name "
                    + "FROM test t "
                    + "LEFT JOIN study_package sp ON t.course_id = sp.id "
                    + "LEFT JOIN chapter c ON t.chapter_id = c.id "
                    + "WHERE t.id = ?";

            try (PreparedStatement ps = conn.prepareStatement(testSql)) {
                ps.setInt(1, testId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    System.out.println("Test basic info:");
                    System.out.println("  ID: " + rs.getInt("id"));
                    System.out.println("  Name: " + rs.getString("name"));
                    System.out.println("  Description: " + rs.getString("description"));
                    System.out.println("  Is Practice: " + rs.getBoolean("is_practice"));
                    System.out.println("  Duration (minutes): " + rs.getInt("duration_minutes"));
                    System.out.println("  Number of Questions: " + rs.getInt("num_questions"));
                    System.out.println("  Test Order: " + rs.getInt("test_order"));

                    Integer courseId = rs.getObject("course_id", Integer.class);
                    if (courseId != null) {
                        System.out.println("  Course ID: " + courseId);
                        System.out.println("  Course Title: " + rs.getString("course_title"));
                    } else {
                        System.out.println("  Course: Not assigned to any course");
                    }

                    Integer chapterId = rs.getObject("chapter_id", Integer.class);
                    if (chapterId != null) {
                        System.out.println("  Chapter ID: " + chapterId);
                        System.out.println("  Chapter Name: " + rs.getString("chapter_name"));
                    } else {
                        System.out.println("  Chapter: Course-level test");
                    }

                    System.out.println("  Created By: " + rs.getObject("created_by"));
                    System.out.println("  Created At: " + rs.getTimestamp("created_at"));
                    System.out.println("  Updated At: " + rs.getTimestamp("updated_at"));
                } else {
                    System.out.println("Test ID " + testId + " not found!");
                    return;
                }
            }

            // Check number of questions in test
            String questionCountSql = "SELECT COUNT(*) as count FROM test_question WHERE test_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(questionCountSql)) {
                ps.setInt(1, testId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt("count");
                    System.out.println("Questions in test: " + count);

                    if (count > 0) {
                        String questionsSql = """
                            SELECT q.id, q.question, q.lesson_id, COUNT(qo.id) as option_count
                            FROM test_question tq
                            JOIN question q ON tq.question_id = q.id
                            LEFT JOIN question_option qo ON q.id = qo.question_id
                            WHERE tq.test_id = ?
                            GROUP BY q.id, q.question, q.lesson_id
                        """;
                        try (PreparedStatement psQ = conn.prepareStatement(questionsSql)) {
                            psQ.setInt(1, testId);
                            ResultSet rsQ = psQ.executeQuery();

                            System.out.println("Question details:");
                            int i = 1;
                            while (rsQ.next()) {
                                System.out.println("  " + i + ". ID: " + rsQ.getInt("id")
                                        + ", Options: " + rsQ.getInt("option_count")
                                        + ", Lesson ID: " + rsQ.getInt("lesson_id")
                                        + ", Text: '" + rsQ.getString("question").substring(0, Math.min(30, rsQ.getString("question").length())) + "...'");
                                i++;
                            }
                        }
                    }
                }
            }

            // Check test records
            String testRecordSql = "SELECT COUNT(*) as count FROM test_record WHERE test_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(testRecordSql)) {
                ps.setInt(1, testId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    System.out.println("Test records: " + rs.getInt("count"));
                }
            }

        } catch (SQLException e) {
            System.out.println("ERROR in debugTestInfo: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("===== END DEBUG TEST =====\n");
    }

    public int getLessonIdByTest(int testId) {
        String sql = "SELECT lesson_id FROM test WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getObject("lesson_id") != null) {
                return rs.getInt("lesson_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu không tìm thấy
    }

    public int addCourseTest(Test test) {
        String sql = "INSERT INTO test (name, description, is_practice, duration_minutes, "
                + "num_questions, course_id, chapter_id, test_order, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, test.getName());
            ps.setString(2, test.getDescription());
            ps.setBoolean(3, test.isIs_practice());
            ps.setInt(4, test.getDuration_minutes());
            ps.setInt(5, test.getNum_questions());

            if (test.getCourse_id() != null) {
                ps.setInt(6, test.getCourse_id());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            if (test.getChapter_id() != null) {
                ps.setInt(7, test.getChapter_id());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setInt(8, test.getTest_order());

            if (test.getCreated_by() != null) {
                ps.setInt(9, test.getCreated_by());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int testId = rs.getInt(1);

                // If this is a course test, also add to course_test table
                if (test.getCourse_id() != null) {
                    addTestToCourse(testId, test.getCourse_id(), test.getChapter_id(), test.getTest_order());
                }

                return testId;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    private void addTestToCourse(int testId, int courseId, Integer chapterId, int displayOrder) {
        String sql = "INSERT INTO course_test (course_id, test_id, chapter_id, display_order, "
                + "test_type, is_active) VALUES (?, ?, ?, ?, ?, 1) "
                + "ON DUPLICATE KEY UPDATE display_order = ?, is_active = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, testId);

            if (chapterId != null) {
                ps.setInt(3, chapterId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setInt(4, displayOrder);
            ps.setString(5, "PRACTICE"); // Will be updated based on test type
            ps.setInt(6, displayOrder);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get tests by course with pagination
    public List<Map<String, Object>> getTestsByCourseWithPagination(int courseId, int page, int pageSize) {
        List<Map<String, Object>> tests = new ArrayList<>();
        String sql = "SELECT * FROM test_management_view WHERE course_id = ? "
                + "ORDER BY test_order, created_at DESC LIMIT ? OFFSET ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> test = new HashMap<>();
                test.put("test_id", rs.getInt("test_id"));
                test.put("test_name", rs.getString("test_name"));
                test.put("test_description", rs.getString("test_description"));
                test.put("is_practice", rs.getBoolean("is_practice"));
                test.put("duration_minutes", rs.getInt("duration_minutes"));
                test.put("num_questions", rs.getInt("num_questions"));
                test.put("test_order", rs.getInt("test_order"));
                test.put("course_id", rs.getInt("course_id"));
                test.put("course_name", rs.getString("course_name"));
                test.put("chapter_id", rs.getObject("chapter_id"));
                test.put("chapter_name", rs.getString("chapter_name"));
                test.put("subject_name", rs.getString("subject_name"));
                test.put("grade_name", rs.getString("grade_name"));
                test.put("created_by_name", rs.getString("created_by_name"));
                test.put("total_questions_assigned", rs.getInt("total_questions_assigned"));
                test.put("created_at", rs.getTimestamp("created_at"));
                test.put("updated_at", rs.getTimestamp("updated_at"));
                tests.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tests;
    }

    // Get total tests count by course
    public int getTotalTestsByCourseCount(int courseId) {
        String sql = "SELECT COUNT(*) FROM test WHERE course_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get tests with pagination and filters
    public List<Map<String, Object>> getTestsWithPaginationAndFilters(
            String searchKeyword, String testType, Integer courseId, Integer createdBy,
            int page, int pageSize) {

        List<Map<String, Object>> tests = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM test_management_view WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Add filters
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (test_name LIKE ? OR test_description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        if (testType != null && !testType.isEmpty() && !"all".equals(testType)) {
            if ("practice".equals(testType)) {
                sql.append(" AND is_practice = 1");
            } else if ("official".equals(testType)) {
                sql.append(" AND is_practice = 0");
            }
        }

        if (courseId != null) {
            sql.append(" AND course_id = ?");
            params.add(courseId);
        }

        if (createdBy != null) {
            sql.append(" AND created_by = ?");
            params.add(createdBy);
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> test = new HashMap<>();
                test.put("test_id", rs.getInt("test_id"));
                test.put("test_name", rs.getString("test_name"));
                test.put("test_description", rs.getString("test_description"));
                test.put("is_practice", rs.getBoolean("is_practice"));
                test.put("duration_minutes", rs.getInt("duration_minutes"));
                test.put("num_questions", rs.getInt("num_questions"));
                test.put("test_order", rs.getInt("test_order"));
                test.put("course_id", rs.getObject("course_id"));
                test.put("course_name", rs.getString("course_name"));
                test.put("chapter_id", rs.getObject("chapter_id"));
                test.put("chapter_name", rs.getString("chapter_name"));
                test.put("subject_name", rs.getString("subject_name"));
                test.put("grade_name", rs.getString("grade_name"));
                test.put("created_by_name", rs.getString("created_by_name"));
                test.put("total_questions_assigned", rs.getInt("total_questions_assigned"));
                test.put("created_at", rs.getTimestamp("created_at"));
                test.put("updated_at", rs.getTimestamp("updated_at"));
                tests.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tests;
    }

    // Get total tests count with filters
    public int getTotalTestsCountWithFilters(String searchKeyword, String testType,
            Integer courseId, Integer createdBy) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM test_management_view WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        // Add same filters as above
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (test_name LIKE ? OR test_description LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        if (testType != null && !testType.isEmpty() && !"all".equals(testType)) {
            if ("practice".equals(testType)) {
                sql.append(" AND is_practice = 1");
            } else if ("official".equals(testType)) {
                sql.append(" AND is_practice = 0");
            }
        }

        if (courseId != null) {
            sql.append(" AND course_id = ?");
            params.add(courseId);
        }

        if (createdBy != null) {
            sql.append(" AND created_by = ?");
            params.add(createdBy);
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Test> getAllTestsWithBasicInfo() {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM test ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Test test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
                test.setDescription(rs.getString("description"));
                test.setIs_practice(rs.getBoolean("is_practice"));
                test.setDuration_minutes(rs.getInt("duration_minutes"));
                test.setNum_questions(rs.getInt("num_questions"));
                test.setCourse_id(rs.getObject("course_id", Integer.class));
                test.setChapter_id(rs.getObject("chapter_id", Integer.class));
                test.setTest_order(rs.getInt("test_order"));
                test.setCreated_by(rs.getObject("created_by", Integer.class));

                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    test.setCreated_at(createdAt.toLocalDateTime());
                }

                list.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getQuestionsBySubject(int subjectId) {
        List<Map<String, Object>> questions = new ArrayList<>();
        String sql = "SELECT q.id, q.question, q.question_type, q.difficulty, q.category, q.is_ai_generated, l.name as lesson_name "
                + "FROM question q "
                + "JOIN lesson l ON q.lesson_id = l.id "
                + "JOIN chapter c ON l.chapter_id = c.id "
                + "WHERE c.subject_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> question = new HashMap<>();
                question.put("id", rs.getInt("id"));
                question.put("question", rs.getString("question"));
                question.put("question_type", rs.getString("question_type"));
                question.put("difficulty", rs.getString("difficulty"));
                question.put("category", rs.getString("category"));
                question.put("is_ai_generated", rs.getBoolean("is_ai_generated"));
                question.put("lesson_name", rs.getString("lesson_name"));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    public List<Map<String, Object>> getLessonsByCourse(int courseId) throws SQLException {
        String sql = """
        SELECT DISTINCT l.id, l.name, l.chapter_id, c.name as chapter_name
        FROM course_lesson cl
        JOIN lesson l ON cl.lesson_id = l.id
        JOIN chapter c ON l.chapter_id = c.id
        WHERE cl.course_id = ? AND cl.is_active = 1
        ORDER BY c.name, l.name
        """;

        List<Map<String, Object>> lessons = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> lesson = new HashMap<>();
                lesson.put("id", rs.getInt("id"));
                lesson.put("name", rs.getString("name"));
                lesson.put("chapter_id", rs.getInt("chapter_id"));
                lesson.put("chapter_name", rs.getString("chapter_name"));
                lessons.add(lesson);
            }
        }
        return lessons;
    }

    public Map<String, Object> getTestContext(int testId) throws SQLException {
        String sql = """
    SELECT t.id, t.name, t.lesson_id, t.chapter_id, t.course_id,
           l.name as lesson_name, l.chapter_id as lesson_chapter_id,
           c.name as chapter_name, c.subject_id,
           s.name as subject_name, s.grade_id, s.id as subject_id_direct,
           g.name as grade_name,
           sp.course_title, sp.subject_id as course_subject_id,
           course_s.name as course_subject_name
    FROM test t
    LEFT JOIN lesson l ON t.lesson_id = l.id
    LEFT JOIN chapter c ON (t.chapter_id = c.id OR l.chapter_id = c.id)
    LEFT JOIN subject s ON c.subject_id = s.id
    LEFT JOIN grade g ON s.grade_id = g.id
    LEFT JOIN study_package sp ON t.course_id = sp.id
    LEFT JOIN subject course_s ON sp.subject_id = course_s.id
    WHERE t.id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> context = new HashMap<>();
                context.put("testId", rs.getInt("id"));
                context.put("testName", rs.getString("name"));
                context.put("lessonId", rs.getObject("lesson_id"));
                context.put("chapterId", rs.getObject("chapter_id"));
                context.put("courseId", rs.getObject("course_id"));
                context.put("lessonName", rs.getString("lesson_name"));
                context.put("chapterName", rs.getString("chapter_name"));
                context.put("subjectName", rs.getString("subject_name"));
                context.put("subjectId", rs.getObject("subject_id"));
                context.put("gradeName", rs.getString("grade_name"));
                context.put("gradeId", rs.getObject("grade_id"));
                context.put("courseTitle", rs.getString("course_title"));
                context.put("courseSubjectId", rs.getObject("course_subject_id"));
                context.put("courseSubjectName", rs.getString("course_subject_name"));

                // Determine context level with enhanced logic
                if (rs.getObject("lesson_id") != null) {
                    context.put("contextLevel", "lesson");
                    context.put("contextId", rs.getInt("lesson_id"));
                    context.put("contextName", rs.getString("lesson_name"));
                } else if (rs.getObject("chapter_id") != null) {
                    context.put("contextLevel", "chapter");
                    context.put("contextId", rs.getInt("chapter_id"));
                    context.put("contextName", rs.getString("chapter_name"));
                } else if (rs.getObject("course_id") != null) {
                    // For course-level tests, use the subject from the course
                    Integer courseSubjectId = rs.getObject("course_subject_id", Integer.class);
                    String courseSubjectName = rs.getString("course_subject_name");

                    if (courseSubjectId != null) {
                        context.put("contextLevel", "subject");
                        context.put("contextId", courseSubjectId);
                        context.put("contextName", courseSubjectName != null ? courseSubjectName : "Unknown Subject");
                    } else {
                        context.put("contextLevel", "course");
                        context.put("contextId", rs.getObject("course_id"));
                        context.put("contextName", rs.getString("course_title"));
                    }
                } else {
                    context.put("contextLevel", "general");
                    context.put("contextId", null);
                    context.put("contextName", "General Test");
                }

                return context;
            }
        }
        return null;
    }

    /**
     * Get test configuration (duration and num_questions) by test ID
     */
    public Map<String, Integer> getTestConfiguration(int testId) throws SQLException {
        String sql = "SELECT duration_minutes, num_questions FROM test WHERE id = ?";
        Map<String, Integer> config = new HashMap<>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                config.put("duration_minutes", rs.getInt("duration_minutes"));
                config.put("num_questions", rs.getInt("num_questions"));
            }
        }

        return config;
    }

    /**
     * Update test with duration and num_questions
     */
    public boolean updateTestWithConfiguration(Test test) throws SQLException {
        String sql = "UPDATE test SET name = ?, description = ?, is_practice = ?, "
                + "duration_minutes = ?, num_questions = ?, updated_at = CURRENT_TIMESTAMP "
                + "WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, test.getName());
            ps.setString(2, test.getDescription());
            ps.setBoolean(3, test.isIs_practice());
            ps.setInt(4, test.getDuration_minutes());
            ps.setInt(5, test.getNum_questions());
            ps.setInt(6, test.getId());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Check if test is course-integrated
     */
    public boolean isCourseIntegratedTest(int testId) throws SQLException {
        String sql = "SELECT course_id FROM test WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getObject("course_id") != null;
            }
        }

        return false;
    }

    /**
     * Get test's required question count
     */
    public int getRequiredQuestionCount(int testId) throws SQLException {
        String sql = "SELECT num_questions FROM test WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("num_questions");
            }
        }

        return 0;
    }

    /**
     * Get tests grouped by course for a specific student Only returns tests
     * from courses the student has access to
     */
    public Map<String, List<Map<String, Object>>> getTestsByCourseForStudent(int studentId) {
        Map<String, List<Map<String, Object>>> testsByCourse = new LinkedHashMap<>();

        String sql = """
        SELECT DISTINCT
            t.id as test_id,
            t.name as test_name,
            t.description as test_description,
            t.is_practice,
            t.duration_minutes,
            t.num_questions,
            t.test_order,
            sp.id as course_id,
            COALESCE(sp.course_title, sp.name) as course_name,
            s.name as subject_name,
            g.name as grade_name,
            c.name as chapter_name,
            -- Check if student has taken this test (for official tests only)
            CASE 
                WHEN t.is_practice = 0 THEN 
                    (SELECT COUNT(*) FROM test_record tr 
                     WHERE tr.student_id = ? AND tr.test_id = t.id AND tr.finish_at IS NOT NULL) > 0
                ELSE 0
            END as has_taken
        FROM test t
        JOIN study_package sp ON t.course_id = sp.id
        LEFT JOIN subject s ON sp.subject_id = s.id
        LEFT JOIN grade g ON s.grade_id = g.id
        LEFT JOIN chapter c ON t.chapter_id = c.id
        WHERE t.course_id IS NOT NULL
        AND EXISTS (
            SELECT 1 FROM student_package stp 
            WHERE stp.student_id = ? 
            AND stp.package_id = sp.id 
            AND stp.is_active = 1 
            AND stp.expires_at > NOW()
        )
        ORDER BY 
            course_name,
            CASE WHEN t.chapter_id IS NULL THEN 0 ELSE 1 END,
            c.name,
            t.test_order,
            t.name
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, studentId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String courseName = rs.getString("course_name");
                String subjectName = rs.getString("subject_name");
                String gradeName = rs.getString("grade_name");

                // Create course display name
                String courseDisplayName = courseName;
                if (subjectName != null && gradeName != null) {
                    courseDisplayName = courseName + " (" + subjectName + " - " + gradeName + ")";
                }

                Map<String, Object> testInfo = new HashMap<>();
                testInfo.put("test_id", rs.getInt("test_id"));
                testInfo.put("test_name", rs.getString("test_name"));
                testInfo.put("test_description", rs.getString("test_description"));
                testInfo.put("is_practice", rs.getBoolean("is_practice"));
                testInfo.put("duration_minutes", rs.getInt("duration_minutes"));
                testInfo.put("num_questions", rs.getInt("num_questions"));
                testInfo.put("test_order", rs.getInt("test_order"));
                testInfo.put("course_id", rs.getInt("course_id"));
                testInfo.put("course_name", courseName);
                testInfo.put("chapter_name", rs.getString("chapter_name"));
                testInfo.put("has_taken", rs.getBoolean("has_taken"));

                // Group by course
                testsByCourse.computeIfAbsent(courseDisplayName, k -> new ArrayList<>()).add(testInfo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return testsByCourse;
    }

    /**
     * Get standalone tests (not associated with any course) for student
     */
    public List<Map<String, Object>> getStandaloneTestsForStudent(int studentId) {
        List<Map<String, Object>> tests = new ArrayList<>();

        String sql = """
        SELECT 
            t.id as test_id,
            t.name as test_name,
            t.description as test_description,
            t.is_practice,
            t.duration_minutes,
            t.num_questions,
            -- Check if student has taken this test (for official tests only)
            CASE 
                WHEN t.is_practice = 0 THEN 
                    (SELECT COUNT(*) FROM test_record tr 
                     WHERE tr.student_id = ? AND tr.test_id = t.id AND tr.finish_at IS NOT NULL) > 0
                ELSE 0
            END as has_taken
        FROM test t
        WHERE t.course_id IS NULL
        ORDER BY 
            CASE WHEN t.is_practice = 1 THEN 0 ELSE 1 END,
            t.name
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> testInfo = new HashMap<>();
                testInfo.put("test_id", rs.getInt("test_id"));
                testInfo.put("test_name", rs.getString("test_name"));
                testInfo.put("test_description", rs.getString("test_description"));
                testInfo.put("is_practice", rs.getBoolean("is_practice"));
                testInfo.put("duration_minutes", rs.getInt("duration_minutes"));
                testInfo.put("num_questions", rs.getInt("num_questions"));
                testInfo.put("has_taken", rs.getBoolean("has_taken"));

                tests.add(testInfo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tests;
    }

    /**
     * Check if student has access to a specific test
     */
    public boolean hasStudentAccessToTest(int studentId, int testId) {
        String sql = """
        SELECT COUNT(*) FROM test t
        LEFT JOIN study_package sp ON t.course_id = sp.id
        LEFT JOIN student_package stp ON (stp.package_id = sp.id AND stp.student_id = ?)
        WHERE t.id = ?
        AND (
            t.course_id IS NULL  -- Standalone test
            OR (
                stp.is_active = 1 
                AND stp.expires_at > NOW()
            )
        )
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, testId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
