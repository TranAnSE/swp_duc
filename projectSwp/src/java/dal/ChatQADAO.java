package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ChatQA;

public class ChatQADAO extends DBContext {

    public List<ChatQA> findAll() throws SQLException {
        List<ChatQA> list = new ArrayList<>();
        String sql = "SELECT * FROM chat_qa ORDER BY id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ChatQA qa = new ChatQA();
                qa.setId(rs.getInt("id"));
                qa.setQuestion(rs.getString("question"));
                qa.setKey(rs.getString("key"));
                qa.setAnswer(rs.getString("answer"));
                list.add(qa);
            }
        }
        return list;
    }

    public ChatQA findById(int id) throws SQLException {
        String sql = "SELECT * FROM chat_qa WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ChatQA qa = new ChatQA();
                    qa.setId(rs.getInt("id"));
                    qa.setQuestion(rs.getString("question"));
                    qa.setKey(rs.getString("key"));
                    qa.setAnswer(rs.getString("answer"));
                    return qa;
                }
            }
        }
        return null;
    }

    public boolean insert(ChatQA qa) throws SQLException {
        String sql = "INSERT INTO chat_qa (question, `key`, answer) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, qa.getQuestion());
            ps.setString(2, qa.getKey());
            ps.setString(3, qa.getAnswer());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(ChatQA qa) throws SQLException {
        String sql = "UPDATE chat_qa SET question = ?, `key` = ?, answer = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, qa.getQuestion());
            ps.setString(2, qa.getKey());
            ps.setString(3, qa.getAnswer());
            ps.setInt(4, qa.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM chat_qa WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public List<ChatQA> findByKey(String keyword) throws SQLException {
        List<ChatQA> list = new ArrayList<>();
        String sql = "SELECT * FROM chat_qa WHERE `key` LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatQA qa = new ChatQA();
                    qa.setId(rs.getInt("id"));
                    qa.setQuestion(rs.getString("question"));
                    qa.setKey(rs.getString("key"));
                    qa.setAnswer(rs.getString("answer"));
                    list.add(qa);
                }
            }
        }
        return list;
    }
}
