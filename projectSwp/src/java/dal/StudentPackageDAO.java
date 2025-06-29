/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.StudentPackage;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.util.logging.Level;
import java.util.logging.Logger;

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

    public List<StudentPackage> getStudentPackagesByPackage(int packageId) {
        List<StudentPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, pkg.name as package_name, s.full_name as student_name, a.full_name as parent_name "
                + "FROM student_package sp "
                + "JOIN study_package pkg ON sp.package_id = pkg.id "
                + "JOIN student s ON sp.student_id = s.id "
                + "JOIN account a ON sp.parent_id = a.id "
                + "WHERE sp.package_id = ? ORDER BY sp.purchased_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
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

    public int countActiveAssignments() {
        String sql = "SELECT COUNT(*) FROM student_package WHERE is_active = 1 AND expires_at > NOW()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countExpiredAssignments() {
        String sql = "SELECT COUNT(*) FROM student_package WHERE is_active = 0 OR expires_at <= NOW()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countStudentsWithPackages() {
        String sql = "SELECT COUNT(DISTINCT student_id) FROM student_package";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Object> getAssignmentDetails(int assignmentId) {
        Map<String, Object> details = new HashMap<>();
        String sql = "SELECT sp.*, pkg.name as package_name, pkg.type as package_type, pkg.price as package_price, "
                + "s.full_name as student_name, s.username as student_username, "
                + "a.full_name as parent_name, a.email as parent_email, "
                + "g.name as grade_name, "
                + "DATEDIFF(sp.expires_at, NOW()) as days_remaining "
                + "FROM student_package sp "
                + "JOIN study_package pkg ON sp.package_id = pkg.id "
                + "JOIN student s ON sp.student_id = s.id "
                + "JOIN account a ON sp.parent_id = a.id "
                + "JOIN grade g ON s.grade_id = g.id "
                + "WHERE sp.id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                details.put("studentName", rs.getString("student_name"));
                details.put("studentUsername", rs.getString("student_username"));
                details.put("gradeName", rs.getString("grade_name"));
                details.put("packageName", rs.getString("package_name"));
                details.put("packageType", rs.getString("package_type"));
                details.put("packagePrice", rs.getString("package_price"));
                details.put("parentName", rs.getString("parent_name"));
                details.put("parentEmail", rs.getString("parent_email"));
                details.put("purchasedAt", rs.getTimestamp("purchased_at").toString());
                details.put("expiresAt", rs.getTimestamp("expires_at").toString());
                details.put("daysRemaining", rs.getInt("days_remaining"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    public Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();

        try {
            // Get basic statistics
            String totalSql = "SELECT COUNT(*) FROM student_package";
            String activeSql = "SELECT COUNT(*) FROM student_package WHERE is_active = 1 AND expires_at > NOW()";
            String expiredSql = "SELECT COUNT(*) FROM student_package WHERE is_active = 0 OR expires_at <= NOW()";
            String studentsSql = "SELECT COUNT(DISTINCT student_id) FROM student_package";

            try (PreparedStatement ps = connection.prepareStatement(totalSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    data.put("totalAssignments", rs.getInt(1));
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(activeSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    data.put("activeAssignments", rs.getInt(1));
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(expiredSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    data.put("expiredAssignments", rs.getInt(1));
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(studentsSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    data.put("totalStudents", rs.getInt(1));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Set default values if error occurs
            data.put("totalAssignments", 0);
            data.put("activeAssignments", 0);
            data.put("expiredAssignments", 0);
            data.put("totalStudents", 0);
        }

        return data;
    }

    public List<StudentPackage> getStudentPackagesByStudentId(int studentId) {
        List<StudentPackage> list = new ArrayList<>();
        String sql = "SELECT sp.*, pkg.name as package_name, s.full_name as student_name, a.full_name as parent_name "
                + "FROM student_package sp "
                + "JOIN study_package pkg ON sp.package_id = pkg.id "
                + "JOIN student s ON sp.student_id = s.id "
                + "JOIN account a ON sp.parent_id = a.id "
                + "WHERE sp.student_id = ? ORDER BY sp.purchased_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
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

    /**
     * Check if specific student already has this package
     */
    public boolean hasStudentActivePackage(int studentId, int packageId) {
        String sql = "SELECT COUNT(*) FROM student_package WHERE student_id = ? AND package_id = ? AND is_active = 1 AND expires_at > NOW()";
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

    /**
     * Get available children for parent that don't have this package
     */
    public List<Map<String, Object>> getAvailableChildrenForPackage(int parentId, int packageId) {
        List<Map<String, Object>> children = new ArrayList<>();

        String sql = """
        SELECT 
            s.id,
            s.full_name,
            s.username,
            g.name as grade_name
        FROM student s
        JOIN grade g ON s.grade_id = g.id
        WHERE s.parent_id = ?
        AND s.id NOT IN (
            SELECT sp.student_id 
            FROM student_package sp 
            WHERE sp.package_id = ? 
            AND sp.is_active = 1 
            AND sp.expires_at > NOW()
        )
        ORDER BY s.full_name
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> child = new HashMap<>();
                child.put("id", rs.getInt("id"));
                child.put("fullName", rs.getString("full_name"));
                child.put("username", rs.getString("username"));
                child.put("gradeName", rs.getString("grade_name"));
                children.add(child);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return children;
    }

    /**
     * Get students that already have active package (to exclude from selection)
     */
    public List<Integer> getStudentsWithActivePackage(int packageId) {
        List<Integer> studentIds = new ArrayList<>();
        String sql = "SELECT student_id FROM student_package WHERE package_id = ? AND is_active = 1 AND expires_at > NOW()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                studentIds.add(rs.getInt("student_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return studentIds;
    }

    /**
     * Assign additional students to an existing package purchase (per-parent
     * limit)
     */
    public boolean assignAdditionalStudentToPackage(int studentId, int packageId, int parentId, int durationDays) {
        // Check if parent has available slots
        if (!hasParentAvailableSlots(parentId, packageId)) {
            return false;
        }

        // Check if student already has this package
        if (hasStudentActivePackage(studentId, packageId)) {
            return false;
        }

        String sql = "INSERT INTO student_package (student_id, package_id, parent_id, expires_at, assigned_by) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, packageId);
            ps.setInt(3, parentId);
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now().plusDays(durationDays)));
            ps.setInt(5, parentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get unassigned children for a parent and package (considering per-parent
     * limit)
     */
    public List<Map<String, Object>> getUnassignedChildrenForPackage(int parentId, int packageId) {
        List<Map<String, Object>> children = new ArrayList<>();

        // First check if parent has available slots
        if (!hasParentAvailableSlots(parentId, packageId)) {
            return children; // Return empty list if no slots available
        }

        String sql = """
        SELECT 
            s.id,
            s.full_name,
            s.username,
            g.name as grade_name
        FROM student s
        JOIN grade g ON s.grade_id = g.id
        WHERE s.parent_id = ?
        AND s.id NOT IN (
            SELECT sp.student_id 
            FROM student_package sp 
            WHERE sp.package_id = ? 
            AND sp.is_active = 1 
            AND sp.expires_at > NOW()
        )
        ORDER BY s.full_name
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> child = new HashMap<>();
                child.put("id", rs.getInt("id"));
                child.put("fullName", rs.getString("full_name"));
                child.put("username", rs.getString("username"));
                child.put("gradeName", rs.getString("grade_name"));
                children.add(child);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return children;
    }

    /**
     * Remove student assignment from package
     */
    public boolean removeStudentFromPackage(int assignmentId, int parentId) {
        String sql = "UPDATE student_package SET is_active = 0 WHERE id = ? AND parent_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, parentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if parent has available slots for a specific package (per-parent
     * limit)
     */
    public boolean hasParentAvailableSlots(int parentId, int packageId) {
        String sql = """
        SELECT 
            pkg.max_students as max_per_parent,
            COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as current_active
        FROM study_package pkg
        LEFT JOIN student_package sp ON pkg.id = sp.package_id AND sp.parent_id = ?
        WHERE pkg.id = ?
        GROUP BY pkg.max_students
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int maxPerParent = rs.getInt("max_per_parent");
                int currentActive = rs.getInt("current_active");
                return currentActive < maxPerParent;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Count assigned students for a parent in a specific package
     */
    public int countParentAssignedStudents(int parentId, int packageId) {
        String sql = "SELECT COUNT(*) FROM student_package WHERE parent_id = ? AND package_id = ? AND is_active = 1 AND expires_at > NOW()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get parent's package statistics for a specific package
     */
    public Map<String, Object> getParentPackageStats(int parentId, int packageId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = """
        SELECT 
            pkg.max_students as max_per_parent,
            pkg.name as package_name,
            pkg.price,
            COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as active_assignments,
            COUNT(*) as total_assignments
        FROM study_package pkg
        LEFT JOIN student_package sp ON pkg.id = sp.package_id AND sp.parent_id = ?
        WHERE pkg.id = ?
        GROUP BY pkg.id, pkg.max_students, pkg.name, pkg.price
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int maxPerParent = rs.getInt("max_per_parent");
                int activeAssignments = rs.getInt("active_assignments");

                stats.put("maxPerParent", maxPerParent);
                stats.put("packageName", rs.getString("package_name"));
                stats.put("price", rs.getString("price"));
                stats.put("activeAssignments", activeAssignments);
                stats.put("totalAssignments", rs.getInt("total_assignments"));
                stats.put("availableSlots", Math.max(0, maxPerParent - activeAssignments));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Get parent's assignment history
     */
    public List<Map<String, Object>> getParentAssignmentHistory(int parentId, int limit) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = """
        SELECT 
            sp.id as assignment_id,
            pkg.name as package_name,
            s.full_name as student_name,
            sp.purchased_at as assignment_date,
            CASE 
                WHEN sp.expires_at > NOW() AND sp.is_active = 1 THEN 'ACTIVE'
                WHEN sp.expires_at <= NOW() THEN 'EXPIRED'
                ELSE 'INACTIVE'
            END as status
        FROM student_package sp
        JOIN study_package pkg ON sp.package_id = pkg.id
        JOIN student s ON sp.student_id = s.id
        WHERE sp.parent_id = ?
        ORDER BY sp.purchased_at DESC
        LIMIT ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("assignmentId", rs.getInt("assignment_id"));
                item.put("packageName", rs.getString("package_name"));
                item.put("studentName", rs.getString("student_name"));
                item.put("assignmentDate", rs.getTimestamp("assignment_date").toString());
                item.put("status", rs.getString("status"));
                history.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return history;
    }

    public List<StudentPackage> getFilteredStudentPackagesByPackage(int packageId, String studentName, String status) {
        List<StudentPackage> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT sp.*, pkg.name as package_name, s.full_name as student_name, a.full_name as parent_name ");
        sql.append("FROM student_package sp ");
        sql.append("JOIN study_package pkg ON sp.package_id = pkg.id ");
        sql.append("JOIN student s ON sp.student_id = s.id ");
        sql.append("JOIN account a ON sp.parent_id = a.id ");
        sql.append("WHERE sp.package_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(packageId);

        // Add student name filter
        if (studentName != null && !studentName.trim().isEmpty()) {
            sql.append("AND s.full_name LIKE ? ");
            params.add("%" + studentName.trim() + "%");
        }

        // Add status filter
        if (status != null && !status.trim().isEmpty()) {
            switch (status.toLowerCase()) {
                case "active":
                    sql.append("AND sp.is_active = 1 AND sp.expires_at > NOW() ");
                    break;
                case "expired":
                    sql.append("AND sp.expires_at <= NOW() ");
                    break;
                case "inactive":
                    sql.append("AND sp.is_active = 0 ");
                    break;
            }
        }

        sql.append("ORDER BY sp.purchased_at DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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
}
