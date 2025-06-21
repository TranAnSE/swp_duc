/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.TestQuestion;
/**
 *
 * @author Na
 */
public class TestQuestionDAO extends DBContext {
    private Connection conn;

    public TestQuestionDAO() {
        try {
            this.conn = getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Thêm một câu hỏi vào test
     * @param testId ID của test
     * @param questionId ID của câu hỏi
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean addTestQuestion(int testId, int questionId) {
        String sql = "INSERT INTO test_question (test_id, question_id) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ps.setInt(2, questionId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa một câu hỏi khỏi test
     * @param testId ID của test
     * @param questionId ID của câu hỏi
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean removeTestQuestion(int testId, int questionId) {
        String sql = "DELETE FROM test_question WHERE test_id = ? AND question_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ps.setInt(2, questionId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa tất cả câu hỏi của một test
     * @param testId ID của test
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean removeAllQuestionsFromTest(int testId) {
        String sql = "DELETE FROM test_question WHERE test_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách ID câu hỏi của một test
     * @param testId ID của test
     * @return Danh sách ID câu hỏi
     */
    public List<Integer> getQuestionIdsByTest(int testId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT question_id FROM test_question WHERE test_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("question_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy danh sách TestQuestion của một test
     * @param testId ID của test
     * @return Danh sách TestQuestion
     */
    public List<TestQuestion> getTestQuestionsByTest(int testId) {
        List<TestQuestion> list = new ArrayList<>();
        String sql = "SELECT * FROM test_question WHERE test_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TestQuestion tq = new TestQuestion(
                    rs.getInt("test_id"),
                    rs.getInt("question_id")
                );
                list.add(tq);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void removeQuestionFromAllTests(int questionId) throws SQLException {
        String sql = "DELETE FROM test_question WHERE question_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.executeUpdate();
        }
    }
} 