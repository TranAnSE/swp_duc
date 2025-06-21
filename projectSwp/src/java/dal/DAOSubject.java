package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Subject;

public class DAOSubject extends DBContext {

    public List<Subject> findAll() throws SQLException {
        String sql = "SELECT * FROM subject";
        List<Subject> subjects = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Subject sub = new Subject();
                sub.setId(rs.getInt("id"));
                sub.setName(rs.getString("name"));
                sub.setDescription(rs.getString("description"));
                sub.setGrade_id(rs.getInt("grade_id"));
                subjects.add(sub);
            }
        }
        return subjects;
    }

    public List<Subject> findByNameOfSubject(String name) throws SQLException {
        String sql = "SELECT * FROM subject WHERE name LIKE ?";
        List<Subject> subjects = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Subject sub = new Subject();
                    sub.setId(rs.getInt("id"));
                    sub.setName(rs.getString("name"));
                    sub.setDescription(rs.getString("description"));
                    sub.setGrade_id(rs.getInt("grade_id"));
                    subjects.add(sub);
                }
            }
        }
        return subjects;
    }

    public boolean insert(Subject subject) throws SQLException {
        String sql = "INSERT INTO subject (name, description, grade_id) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, subject.getName());
            ps.setString(2, subject.getDescription());
            ps.setInt(3, subject.getGrade_id());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM subject WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Subject subject) throws SQLException {
        String sql = "UPDATE subject SET name = ?, description = ?, grade_id = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, subject.getName());
            ps.setString(2, subject.getDescription());
            ps.setInt(3, subject.getGrade_id());
            ps.setInt(4, subject.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public Subject findById(int id) throws SQLException {
        String sql = "SELECT * FROM subject WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject sub = new Subject();
                    sub.setId(rs.getInt("id"));
                    sub.setName(rs.getString("name"));
                    sub.setDescription(rs.getString("description"));
                    sub.setGrade_id(rs.getInt("grade_id"));
                    return sub;
                }
            }
        }
        return null;
    }
}
