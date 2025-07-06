/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Grade;

/**
 *
 * @author ADMIN
 */
public class GradeDAO extends DBContext {

    // hien thi full grade
    public List<Grade> findAllFromGrade() throws SQLException {
        String sql = "SELECT * FROM grade";
        List<Grade> grades = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Grade gra = new Grade();
                gra.setId(rs.getInt("id"));
                gra.setName(rs.getString("name"));
                gra.setDescription(rs.getString("description"));
                gra.setTeacher_id(rs.getInt("teacher_id"));
                grades.add(gra);
            }
        }
        return grades;
    }
    // Tìm grade qua name

    public List<Grade> findByName(String name) throws SQLException {
        String sql = "SELECT * FROM grade WHERE name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                List<Grade> grades = new ArrayList<>();
                while (rs.next()) {
                    Grade gra = new Grade();
                    gra.setId(rs.getInt("id"));
                    gra.setName(rs.getString("name"));
                    gra.setDescription(rs.getString("description"));
                    gra.setTeacher_id(rs.getInt("teacher_id"));
                    grades.add(gra);
                }
                return grades;
            }
        }
    }

    // tao new grade
    public boolean insert(Grade grade) throws SQLException {
        String sql = "INSERT INTO grade ( name, description, teacher_id) "
                + "VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, grade.getName());
            ps.setString(2, grade.getDescription());
            ps.setInt(3, grade.getTeacher_id());

            return ps.executeUpdate() > 0;
        }
    }

    // remove grade
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM grade WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // update grade
    public boolean update(Grade grade) throws SQLException {
        String sql = "UPDATE grade SET name = ?, description = ?, teacher_id = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, grade.getName());
            ps.setString(2, grade.getDescription());
            ps.setInt(3, grade.getTeacher_id());
            ps.setInt(4, grade.getId());
            return ps.executeUpdate() > 0;
        }
    }

    // lay ID
    public Grade getGradeById(int id) throws SQLException {
        String sql = "SELECT * FROM grade WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Grade gra = new Grade();
                    gra.setId(rs.getInt("id"));
                    gra.setName(rs.getString("name"));
                    gra.setDescription(rs.getString("description"));
                    gra.setTeacher_id(rs.getInt("teacher_id"));
                    return gra;
                }
            }
        }
        return null; // nếu không tìm thấy
    }

    public List<Grade> findGradesWithPagination(String name, Integer teacherId, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM grade WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + name.trim() + "%");
        }

        if (teacherId != null) {
            sql.append(" AND teacher_id = ?");
            params.add(teacherId);
        }

        sql.append(" ORDER BY name LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        List<Grade> grades = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Grade gra = new Grade();
                    gra.setId(rs.getInt("id"));
                    gra.setName(rs.getString("name"));
                    gra.setDescription(rs.getString("description"));
                    gra.setTeacher_id(rs.getInt("teacher_id"));
                    grades.add(gra);
                }
            }
        }
        return grades;
    }

    public int getTotalGradesCount(String name, Integer teacherId) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM grade WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + name.trim() + "%");
        }

        if (teacherId != null) {
            sql.append(" AND teacher_id = ?");
            params.add(teacherId);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}
