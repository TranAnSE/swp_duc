/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.QuestionOption;

/**
 *
 * @author Na
 */


public class QuestionOptionDAO extends DBContext {

    public List<QuestionOption> getOptionsByQuestion(int questionId) throws SQLException {
        List<QuestionOption> list = new ArrayList<>();
        String sql = "SELECT * FROM question_option WHERE question_id = ? ORDER BY id";
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    QuestionOption option = new QuestionOption();
                    option.setId(rs.getInt("id"));
                    option.setQuestion_id(rs.getInt("question_id"));
                    option.setContent(rs.getString("content"));
                    option.setIs_correct(rs.getBoolean("is_correct"));
                    list.add(option);
                }
            }
        }
        return list;
    }

    public QuestionOption getOptionById(int id) throws SQLException {
        String sql = "SELECT * FROM question_option WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    QuestionOption option = new QuestionOption();
                    option.setId(rs.getInt("id"));
                    option.setQuestion_id(rs.getInt("question_id"));
                    option.setContent(rs.getString("content"));
                    option.setIs_correct(rs.getBoolean("is_correct"));
                    return option;
                }
            }
        }
        return null;
    }

    public void insertOption(QuestionOption option) throws SQLException {
        String sql = "INSERT INTO question_option (question_id, content, is_correct) VALUES (?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, option.getQuestion_id());
            stmt.setString(2, option.getContent());
            stmt.setBoolean(3, option.isIs_correct());
            stmt.executeUpdate();
        }
    }

    public void updateOption(QuestionOption option) throws SQLException {
        String sql = "UPDATE question_option SET content = ?, is_correct = ? WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, option.getContent());
            stmt.setBoolean(2, option.isIs_correct());
            stmt.setInt(3, option.getId());
            stmt.executeUpdate();
        }
    }

    public void deleteOption(int id) throws SQLException {
        String sql = "DELETE FROM question_option WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteOptionsByQuestion(int questionId) throws SQLException {
        String sql = "DELETE FROM question_option WHERE question_id = ?";
        try (Connection conn = new DBContext().getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            stmt.executeUpdate();
        }
    }
}
