/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ankha
 */
public class DashboardDAO extends DBContext {

    /**
     * Get total counts for main entities
     */
    public Map<String, Integer> getTotalCounts() throws SQLException {
        Map<String, Integer> counts = new HashMap<>();

        // Initialize with default values
        counts.put("accounts", 0);
        counts.put("students", 0);
        counts.put("tests", 0);
        counts.put("questions", 0);
        counts.put("lessons", 0);
        counts.put("subjects", 0);
        counts.put("grades", 0);
        counts.put("packages", 0);

        try {
            // Count accounts
            String sql = "SELECT COUNT(*) as count FROM account";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("accounts", rs.getInt("count"));
                }
            }

            // Count students
            sql = "SELECT COUNT(*) as count FROM student";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("students", rs.getInt("count"));
                }
            }

            // Count tests
            sql = "SELECT COUNT(*) as count FROM test";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("tests", rs.getInt("count"));
                }
            }

            // Count questions
            sql = "SELECT COUNT(*) as count FROM question";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("questions", rs.getInt("count"));
                }
            }

            // Count lessons
            sql = "SELECT COUNT(*) as count FROM lesson";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("lessons", rs.getInt("count"));
                }
            }

            // Count subjects
            sql = "SELECT COUNT(*) as count FROM subject";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("subjects", rs.getInt("count"));
                }
            }

            // Count grades
            sql = "SELECT COUNT(*) as count FROM grade";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("grades", rs.getInt("count"));
                }
            }

            // Count packages
            sql = "SELECT COUNT(*) as count FROM study_package";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    counts.put("packages", rs.getInt("count"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error in getTotalCounts: " + e.getMessage());
            e.printStackTrace();
        }

        return counts;
    }

    /**
     * Get user distribution by role
     */
    public Map<String, Integer> getUsersByRole() throws SQLException {
        Map<String, Integer> roleDistribution = new HashMap<>();

        // Initialize with default values
        roleDistribution.put("admin", 0);
        roleDistribution.put("teacher", 0);
        roleDistribution.put("parent", 0);

        try {
            String sql = "SELECT role, COUNT(*) as count FROM account WHERE role IS NOT NULL GROUP BY role";
            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String role = rs.getString("role");
                    int count = rs.getInt("count");
                    if (role != null && !role.trim().isEmpty()) {
                        roleDistribution.put(role, count);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getUsersByRole: " + e.getMessage());
            e.printStackTrace();
        }

        return roleDistribution;
    }

    /**
     * Get test statistics
     */
    public Map<String, Object> getTestStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        try {
            // Total tests by type
            Map<String, Integer> testsByType = new HashMap<>();
            testsByType.put("Practice", 0);
            testsByType.put("Official", 0);

            String sql1 = "SELECT is_practice, COUNT(*) as count FROM test GROUP BY is_practice";
            try (PreparedStatement ps = connection.prepareStatement(sql1); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    boolean isPractice = rs.getBoolean("is_practice");
                    String type = isPractice ? "Practice" : "Official";
                    testsByType.put(type, rs.getInt("count"));
                }
            }
            stats.put("testsByType", testsByType);

            // Test completion rate
            double completionRate = 0.0;
            try {
                String sql2 = "SELECT "
                        + "(SELECT COUNT(DISTINCT test_id) FROM test_record WHERE finish_at IS NOT NULL) as completed_tests, "
                        + "(SELECT COUNT(*) FROM test WHERE is_practice = 0) as total_official_tests";
                try (PreparedStatement ps = connection.prepareStatement(sql2); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int completedTests = rs.getInt("completed_tests");
                        int totalTests = rs.getInt("total_official_tests");
                        if (totalTests > 0) {
                            completionRate = (double) completedTests / totalTests * 100;
                        }
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error calculating completion rate: " + e.getMessage());
            }
            stats.put("completionRate", Math.round(completionRate * 100.0) / 100.0);

        } catch (SQLException e) {
            System.err.println("Error in getTestStatistics: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Get recent test activities
     */
    public List<Map<String, Object>> getRecentTestActivities() throws SQLException {
        List<Map<String, Object>> activities = new ArrayList<>();

        try {
            String sql = "SELECT tr.id, s.full_name as student_name, t.name as test_name, "
                    + "tr.score, tr.finish_at "
                    + "FROM test_record tr "
                    + "JOIN student s ON tr.student_id = s.id "
                    + "JOIN test t ON tr.test_id = t.id "
                    + "WHERE tr.finish_at IS NOT NULL "
                    + "ORDER BY tr.finish_at DESC LIMIT 10";

            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("studentName", rs.getString("student_name"));
                    activity.put("testName", rs.getString("test_name"));
                    activity.put("score", rs.getDouble("score"));
                    activity.put("finishAt", rs.getTimestamp("finish_at"));
                    activities.add(activity);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getRecentTestActivities: " + e.getMessage());
            e.printStackTrace();
        }

        return activities;
    }

    /**
     * Get monthly test completion data for chart
     */
    public List<Map<String, Object>> getMonthlyTestCompletions() throws SQLException {
        List<Map<String, Object>> monthlyData = new ArrayList<>();

        try {
            String sql = "SELECT DATE_FORMAT(finish_at, '%Y-%m') as month, "
                    + "COUNT(*) as completions "
                    + "FROM test_record "
                    + "WHERE finish_at IS NOT NULL "
                    + "AND finish_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH) "
                    + "GROUP BY DATE_FORMAT(finish_at, '%Y-%m') "
                    + "ORDER BY month";

            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("month", rs.getString("month"));
                    data.put("completions", rs.getInt("completions"));
                    monthlyData.add(data);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getMonthlyTestCompletions: " + e.getMessage());
            e.printStackTrace();
        }

        return monthlyData;
    }

    /**
     * Get grade distribution data
     */
    public List<Map<String, Object>> getGradeDistribution() throws SQLException {
        List<Map<String, Object>> gradeData = new ArrayList<>();

        try {
            String sql = "SELECT g.name as grade_name, COUNT(s.id) as student_count "
                    + "FROM grade g "
                    + "LEFT JOIN student s ON g.id = s.grade_id "
                    + "GROUP BY g.id, g.name "
                    + "ORDER BY g.name";

            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("gradeName", rs.getString("grade_name"));
                    data.put("studentCount", rs.getInt("student_count"));
                    gradeData.add(data);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getGradeDistribution: " + e.getMessage());
            e.printStackTrace();
        }

        return gradeData;
    }

    /**
     * Get package sales data with accurate revenue calculation
     */
    public Map<String, Object> getPackageStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        try {
            // Calculate total revenue from paid invoices
            double totalRevenue = 0.0;
            try {
                String sql1 = "SELECT SUM(CAST(total_amount AS DECIMAL(10,2))) as total_revenue "
                        + "FROM invoice "
                        + "WHERE status = 'paid' AND total_amount IS NOT NULL AND total_amount != ''";

                try (PreparedStatement ps = connection.prepareStatement(sql1); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalRevenue = rs.getDouble("total_revenue");
                        if (rs.wasNull()) {
                            totalRevenue = 0.0;
                        }
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error calculating revenue from invoice total_amount: " + e.getMessage());

                // Fallback: Calculate revenue from package prices
                try {
                    String fallbackSql = "SELECT SUM(CAST(sp.price AS DECIMAL(10,2))) as total_revenue "
                            + "FROM study_package sp "
                            + "JOIN invoice_line il ON sp.id = il.package_id "
                            + "JOIN invoice i ON il.invoice_id = i.id "
                            + "WHERE i.status = 'paid' AND sp.price IS NOT NULL AND sp.price != ''";

                    try (PreparedStatement ps = connection.prepareStatement(fallbackSql); ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            totalRevenue = rs.getDouble("total_revenue");
                            if (rs.wasNull()) {
                                totalRevenue = 0.0;
                            }
                        }
                    }
                } catch (SQLException e2) {
                    System.err.println("Error in fallback revenue calculation: " + e2.getMessage());
                    totalRevenue = 0.0;
                }
            }
            stats.put("totalRevenue", totalRevenue);

            // Get package sales count with accurate data
            List<Map<String, Object>> packageSales = new ArrayList<>();
            try {
                String sql2 = "SELECT sp.name, "
                        + "COUNT(il.package_id) as sales_count, "
                        + "SUM(CASE WHEN sp.price IS NOT NULL AND sp.price != '' "
                        + "     THEN CAST(sp.price AS DECIMAL(10,2)) ELSE 0 END) as package_revenue "
                        + "FROM study_package sp "
                        + "LEFT JOIN invoice_line il ON sp.id = il.package_id "
                        + "LEFT JOIN invoice i ON il.invoice_id = i.id AND i.status = 'paid' "
                        + "GROUP BY sp.id, sp.name "
                        + "ORDER BY sales_count DESC, sp.name";

                try (PreparedStatement ps = connection.prepareStatement(sql2); ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("packageName", rs.getString("name"));
                        data.put("salesCount", rs.getInt("sales_count"));
                        data.put("packageRevenue", rs.getDouble("package_revenue"));
                        packageSales.add(data);
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error getting package sales: " + e.getMessage());

                // Add default data if error occurs
                Map<String, Object> defaultData = new HashMap<>();
                defaultData.put("packageName", "No Data Available");
                defaultData.put("salesCount", 0);
                defaultData.put("packageRevenue", 0.0);
                packageSales.add(defaultData);
            }
            stats.put("packageSales", packageSales);

            // Additional statistics
            try {
                // Total number of paid invoices
                String sql3 = "SELECT COUNT(*) as paid_invoices FROM invoice WHERE status = 'paid'";
                try (PreparedStatement ps = connection.prepareStatement(sql3); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("totalPaidInvoices", rs.getInt("paid_invoices"));
                    }
                }

                // Average order value
                if (totalRevenue > 0) {
                    int paidInvoices = (Integer) stats.getOrDefault("totalPaidInvoices", 0);
                    if (paidInvoices > 0) {
                        double avgOrderValue = totalRevenue / paidInvoices;
                        stats.put("averageOrderValue", Math.round(avgOrderValue * 100.0) / 100.0);
                    }
                }

            } catch (SQLException e) {
                System.err.println("Error calculating additional statistics: " + e.getMessage());
            }

        } catch (Exception e) {
            System.err.println("Critical error in getPackageStatistics: " + e.getMessage());
            e.printStackTrace();

            // Set safe default values
            stats.put("totalRevenue", 0.0);
            stats.put("packageSales", new ArrayList<>());
            stats.put("totalPaidInvoices", 0);
            stats.put("averageOrderValue", 0.0);
        }

        return stats;
    }
}
