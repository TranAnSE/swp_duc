/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.PackageAccessLog;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ankha
 */
public class PackageAccessLogDAO extends DBContext {

    // Log access activity
    public boolean logAccess(int studentId, int packageId, Integer lessonId, String accessType) {
        String sql = "INSERT INTO package_access_log (student_id, package_id, lesson_id, access_type) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, packageId);
            if (lessonId != null) {
                ps.setInt(3, lessonId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, accessType);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get access logs by student
    public List<PackageAccessLog> getAccessLogsByStudent(int studentId) {
        List<PackageAccessLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM package_access_log WHERE student_id = ? ORDER BY accessed_at DESC LIMIT 100";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PackageAccessLog log = new PackageAccessLog();
                log.setId(rs.getInt("id"));
                log.setStudent_id(rs.getInt("student_id"));
                log.setPackage_id(rs.getInt("package_id"));
                log.setLesson_id(rs.getObject("lesson_id", Integer.class));
                log.setAccess_type(rs.getString("access_type"));
                log.setAccessed_at(rs.getTimestamp("accessed_at").toLocalDateTime());
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    // Get access logs by package
    public List<PackageAccessLog> getAccessLogsByPackage(int packageId) {
        List<PackageAccessLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM package_access_log WHERE package_id = ? ORDER BY accessed_at DESC LIMIT 100";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PackageAccessLog log = new PackageAccessLog();
                log.setId(rs.getInt("id"));
                log.setStudent_id(rs.getInt("student_id"));
                log.setPackage_id(rs.getInt("package_id"));
                log.setLesson_id(rs.getObject("lesson_id", Integer.class));
                log.setAccess_type(rs.getString("access_type"));
                log.setAccessed_at(rs.getTimestamp("accessed_at").toLocalDateTime());
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
}
