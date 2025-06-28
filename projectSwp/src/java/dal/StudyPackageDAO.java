/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.StudyPackage;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Na
 */
public class StudyPackageDAO extends DBContext {

    // Get all study packages
    public List<StudyPackage> getStudyPackage(String sql) {
        List<StudyPackage> list = new ArrayList<>();
        try {
            Statement state = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                StudyPackage stuPackage = mapResultSetToStudyPackage(rs);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Get active packages for parent purchase
    public List<StudyPackage> getActivePackages() {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, g.name as grade_name FROM study_package sp "
                + "LEFT JOIN grade g ON sp.grade_id = g.id "
                + "WHERE sp.is_active = 1 ORDER BY sp.type, sp.name";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = mapResultSetToStudyPackage(rs);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Get packages by grade for students
    public List<StudyPackage> getPackagesByGrade(int gradeId) {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, g.name as grade_name FROM study_package sp "
                + "LEFT JOIN grade g ON sp.grade_id = g.id "
                + "WHERE sp.is_active = 1 AND (sp.grade_id = ? OR sp.type = 'GRADE_ALL') "
                + "ORDER BY sp.type, sp.name";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, gradeId);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = mapResultSetToStudyPackage(rs);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Add new study package
    public int addStudyPackage(StudyPackage stuPackage) {
        int n = 0;
        String sql = "INSERT INTO study_package (id, name, price, type, grade_id, max_students, duration_days, description) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, stuPackage.getId());
            pre.setString(2, stuPackage.getName());
            pre.setString(3, stuPackage.getPrice());
            pre.setString(4, stuPackage.getType());
            if (stuPackage.getGrade_id() != null) {
                pre.setInt(5, stuPackage.getGrade_id());
            } else {
                pre.setNull(5, Types.INTEGER);
            }
            pre.setInt(6, stuPackage.getMax_students());
            pre.setInt(7, stuPackage.getDuration_days());
            pre.setString(8, stuPackage.getDescription());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    // Update study package
    public int updateStudyPackage(StudyPackage stuPackage) {
        int n = 0;
        String sql = "UPDATE study_package SET name = ?, price = ?, type = ?, grade_id = ?, "
                + "max_students = ?, duration_days = ?, description = ?, updated_at = CURRENT_TIMESTAMP "
                + "WHERE id = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, stuPackage.getName());
            pre.setString(2, stuPackage.getPrice());
            pre.setString(3, stuPackage.getType());
            if (stuPackage.getGrade_id() != null) {
                pre.setInt(4, stuPackage.getGrade_id());
            } else {
                pre.setNull(4, Types.INTEGER);
            }
            pre.setInt(5, stuPackage.getMax_students());
            pre.setInt(6, stuPackage.getDuration_days());
            pre.setString(7, stuPackage.getDescription());
            pre.setInt(8, stuPackage.getId());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    // Find study package by ID
    public StudyPackage findStudyPackageById(int id) {
        String sql = "SELECT sp.*, g.name as grade_name FROM study_package sp "
                + "LEFT JOIN grade g ON sp.grade_id = g.id WHERE sp.id = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return mapResultSetToStudyPackage(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Check if student has access to package
    public boolean hasStudentAccess(int studentId, int packageId) {
        String sql = "SELECT COUNT(*) FROM student_package_access "
                + "WHERE student_id = ? AND package_id = ? AND has_access = 1";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, studentId);
            pre.setInt(2, packageId);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Get packages accessible by student
    public List<StudyPackage> getStudentAccessiblePackages(int studentId) {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, g.name as grade_name FROM study_package sp "
                + "LEFT JOIN grade g ON sp.grade_id = g.id "
                + "JOIN student_package_access spa ON sp.id = spa.package_id "
                + "WHERE spa.student_id = ? AND spa.has_access = 1";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, studentId);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = mapResultSetToStudyPackage(rs);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Helper method to map ResultSet to StudyPackage
    private StudyPackage mapResultSetToStudyPackage(ResultSet rs) throws SQLException {
        StudyPackage stuPackage = new StudyPackage();
        stuPackage.setId(rs.getInt("id"));
        stuPackage.setName(rs.getString("name"));
        stuPackage.setPrice(rs.getString("price"));

        // Handle new fields with null checks
        String type = rs.getString("type");
        stuPackage.setType(type != null ? type : "SUBJECT_COMBO");

        int gradeId = rs.getInt("grade_id");
        stuPackage.setGrade_id(rs.wasNull() ? null : gradeId);

        int maxStudents = rs.getInt("max_students");
        stuPackage.setMax_students(rs.wasNull() ? 1 : maxStudents);

        int durationDays = rs.getInt("duration_days");
        stuPackage.setDuration_days(rs.wasNull() ? 365 : durationDays);

        stuPackage.setDescription(rs.getString("description"));

        boolean isActive = rs.getBoolean("is_active");
        stuPackage.setIs_active(rs.wasNull() ? true : isActive);

        // Handle timestamps
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            stuPackage.setCreated_at(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            stuPackage.setUpdated_at(updatedAt.toLocalDateTime());
        }

        return stuPackage;
    }

    // Other existing methods remain the same...
    public int deleteStudyPackage(int id) {
        int n = 0;
        String sql = "UPDATE study_package SET is_active = 0 WHERE id = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, id);
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    public List<StudyPackage> findStudyPackageByName(String name) {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, g.name as grade_name FROM study_package sp "
                + "LEFT JOIN grade g ON sp.grade_id = g.id "
                + "WHERE sp.name LIKE ? AND sp.is_active = 1";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, "%" + name + "%");
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = mapResultSetToStudyPackage(rs);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<StudyPackage> findStudyPackageByPrice(String price) {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, g.name as grade_name FROM study_package sp "
                + "LEFT JOIN grade g ON sp.grade_id = g.id "
                + "WHERE sp.price = ? AND sp.is_active = 1";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, price);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = mapResultSetToStudyPackage(rs);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<StudyPackage> getFeaturedPackages(int limit) {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, g.name as grade_name FROM study_package sp "
                + "LEFT JOIN grade g ON sp.grade_id = g.id "
                + "WHERE sp.is_active = 1 ORDER BY sp.created_at DESC LIMIT ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, limit);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = mapResultSetToStudyPackage(rs);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean canAssignPackage(int packageId, int additionalStudents) {
        String sql = "SELECT sp.max_students, "
                + "(SELECT COUNT(*) FROM student_package stp WHERE stp.package_id = sp.id AND stp.is_active = 1 AND stp.expires_at > NOW()) as current_count "
                + "FROM study_package sp WHERE sp.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int maxStudents = rs.getInt("max_students");
                int currentCount = rs.getInt("current_count");
                return (currentCount + additionalStudents) <= maxStudents;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Object> getAssignmentStats(int packageId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT "
                + "COUNT(*) as total_assignments, "
                + "COUNT(CASE WHEN expires_at > NOW() AND is_active = 1 THEN 1 END) as active_assignments, "
                + "COUNT(CASE WHEN expires_at <= NOW() OR is_active = 0 THEN 1 END) as expired_assignments "
                + "FROM student_package WHERE package_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("total", rs.getInt("total_assignments"));
                stats.put("active", rs.getInt("active_assignments"));
                stats.put("expired", rs.getInt("expired_assignments"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}
