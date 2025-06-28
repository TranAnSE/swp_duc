/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.StudentPackage;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ankha
 */
public class StudentPackageDAO extends DBContext {

    // Assign package to student
    public boolean assignPackageToStudent(int studentId, int packageId, int parentId, int durationDays) {
        String sql = "INSERT INTO student_package (student_id, package_id, parent_id, expires_at) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, packageId);
            ps.setInt(3, parentId);
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now().plusDays(durationDays)));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if student has access to package
    public boolean hasStudentAccess(int studentId, int packageId) {
        String sql = "SELECT COUNT(*) FROM student_package_access WHERE student_id = ? AND package_id = ? AND has_access = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get student packages by parent
    public List<StudentPackage> getStudentPackagesByParent(int parentId) {
        List<StudentPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, pkg.name as package_name, s.full_name as student_name, a.full_name as parent_name "
                + "FROM student_package sp "
                + "JOIN study_package pkg ON sp.package_id = pkg.id "
                + "JOIN student s ON sp.student_id = s.id "
                + "JOIN account a ON sp.parent_id = a.id "
                + "WHERE sp.parent_id = ? ORDER BY sp.purchased_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentPackage studentPackage = new StudentPackage();
                studentPackage.setId(rs.getInt("id"));
                studentPackage.setStudent_id(rs.getInt("student_id"));
                studentPackage.setPackage_id(rs.getInt("package_id"));
                studentPackage.setParent_id(rs.getInt("parent_id"));
                studentPackage.setPurchased_at(rs.getTimestamp("purchased_at").toLocalDateTime());
                studentPackage.setExpires_at(rs.getTimestamp("expires_at").toLocalDateTime());
                studentPackage.setIs_active(rs.getBoolean("is_active"));
                studentPackage.setPackage_name(rs.getString("package_name"));
                studentPackage.setStudent_name(rs.getString("student_name"));
                studentPackage.setParent_name(rs.getString("parent_name"));
                list.add(studentPackage);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get student packages by student
    public List<StudentPackage> getStudentPackagesByStudent(int studentId) {
        List<StudentPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, pkg.name as package_name FROM student_package_access sp "
                + "JOIN study_package pkg ON sp.package_id = pkg.id "
                + "WHERE sp.student_id = ? AND sp.has_access = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentPackage studentPackage = new StudentPackage();
                studentPackage.setStudent_id(rs.getInt("student_id"));
                studentPackage.setPackage_id(rs.getInt("package_id"));
                studentPackage.setParent_id(rs.getInt("parent_id"));
                studentPackage.setPurchased_at(rs.getTimestamp("purchased_at").toLocalDateTime());
                studentPackage.setExpires_at(rs.getTimestamp("expires_at").toLocalDateTime());
                studentPackage.setIs_active(rs.getBoolean("is_active"));
                studentPackage.setPackage_name(rs.getString("package_name"));
                list.add(studentPackage);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count assigned students for a package
    public int countAssignedStudents(int packageId) {
        String sql = "SELECT COUNT(*) FROM student_package WHERE package_id = ? AND is_active = 1 AND expires_at > NOW()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Deactivate student package
    public boolean deactivateStudentPackage(int studentPackageId) {
        String sql = "UPDATE student_package SET is_active = 0 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentPackageId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if package has available slots
    public boolean hasAvailableSlots(int packageId) {
        String sql = "SELECT sp.max_students, "
                + "(SELECT COUNT(*) FROM student_package stp WHERE stp.package_id = sp.id AND stp.is_active = 1 AND stp.expires_at > NOW()) as assigned_count "
                + "FROM study_package sp WHERE sp.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int maxStudents = rs.getInt("max_students");
                int assignedCount = rs.getInt("assigned_count");
                return assignedCount < maxStudents;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}