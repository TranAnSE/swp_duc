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
        String sql = "INSERT INTO test (name, description, is_practice, category_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, test.getName());
            ps.setString(2, test.getDescription());
            ps.setBoolean(3, test.isIs_practice());
            ps.setInt(4, test.getCategory_id());
            ps.executeUpdate();
            
            // Lấy ID của test vừa tạo
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu có lỗi
    }

    public void updateTest(Test test) {
        String sql = "UPDATE test SET name = ?, description = ?, is_practice = ?, category_id = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, test.getName());
            ps.setString(2, test.getDescription());
            ps.setBoolean(3, test.isIs_practice());
            ps.setInt(4, test.getCategory_id());
            ps.setInt(5, test.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteTest(int id) {
        try {
            // Start a transaction
            conn.setAutoCommit(false);
            
            // First delete related records in test_question table
            String deleteTestQuestions = "DELETE FROM test_question WHERE test_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteTestQuestions)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }
            
            // Then delete related records in test_record table
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
            
            // Commit the transaction
            conn.commit();
        } catch (SQLException e) {
            // Rollback in case of error
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            // Reset auto-commit
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
                return new Test(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_practice"),
                    rs.getInt("category_id")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Test> getAllTests() {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM test";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Test(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_practice"),
                    rs.getInt("category_id")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tests theo practice/official
    public List<Test> getTestsByType(boolean isPractice) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM test WHERE is_practice = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isPractice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Test(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_practice"),
                    rs.getInt("category_id")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tests theo category
    public List<Test> getTestsByCategory(int categoryId) {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM test WHERE category_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Test(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getBoolean("is_practice"),
                    rs.getInt("category_id")
                ));
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
            // 1. Lấy thông tin cơ bản của test
            String testSql = "SELECT * FROM test WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(testSql)) {
                ps.setInt(1, testId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    System.out.println("Test basic info:");
                    System.out.println("  ID: " + rs.getInt("id"));
                    System.out.println("  Name: " + rs.getString("name"));
                    System.out.println("  Description: " + rs.getString("description"));
                    System.out.println("  Is Practice: " + rs.getBoolean("is_practice"));
                    System.out.println("  Category ID: " + rs.getInt("category_id"));
                    
                    // Kiểm tra xem có lesson_id không
                    if (rs.getObject("lesson_id") != null) {
                        int lessonId = rs.getInt("lesson_id");
                        System.out.println("  Lesson ID: " + lessonId);
                        
                        // Lấy thông tin lesson
                        String lessonSql = "SELECT * FROM lesson WHERE id = ?";
                        try (PreparedStatement psLesson = conn.prepareStatement(lessonSql)) {
                            psLesson.setInt(1, lessonId);
                            ResultSet rsLesson = psLesson.executeQuery();
                            if (rsLesson.next()) {
                                System.out.println("  Lesson Info:");
                                System.out.println("    Title: " + rsLesson.getString("title"));
                                System.out.println("    Chapter ID: " + rsLesson.getInt("chapter_id"));
                            } else {
                                System.out.println("  WARNING: Lesson ID " + lessonId + " does not exist in database!");
                            }
                        }
                    } else {
                        System.out.println("  No lesson linked to this test (lesson_id is NULL)");
                    }
                } else {
                    System.out.println("Test ID " + testId + " not found!");
                    return;
                }
            }
            
            // 2. Kiểm tra số lượng câu hỏi trong test
            String questionCountSql = "SELECT COUNT(*) as count FROM test_question WHERE test_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(questionCountSql)) {
                ps.setInt(1, testId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt("count");
                    System.out.println("Questions in test: " + count);
                    
                    // Lấy chi tiết các câu hỏi
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
                                System.out.println("  " + i + ". ID: " + rsQ.getInt("id") + 
                                                 ", Options: " + rsQ.getInt("option_count") +
                                                 ", Lesson ID: " + rsQ.getInt("lesson_id") +
                                                 ", Text: '" + rsQ.getString("question").substring(0, Math.min(30, rsQ.getString("question").length())) + "...'");
                                i++;
                            }
                        }
                    }
                }
            }
            
            // 3. Kiểm tra các bản ghi test đã làm
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
    
    // Thêm phương thức để lấy lesson_id của test
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
}
