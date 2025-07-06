package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Subject;

public class DAOSubject extends DBContext {

    public List<Subject> findAll() throws SQLException {
        String sql = "SELECT * FROM subject";
        List<Subject> subjects = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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

    public Subject getSubjectById(int id) throws SQLException {
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

    public List<Subject> findSubjectsWithPagination(String name, Integer gradeId, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM subject WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + name.trim() + "%");
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
        }

        sql.append(" ORDER BY name LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        List<Subject> subjects = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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

    public int getTotalSubjectsCount(String name, Integer gradeId) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM subject WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + name.trim() + "%");
        }

        if (gradeId != null) {
            sql.append(" AND grade_id = ?");
            params.add(gradeId);
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
