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
            String sql = """
        SELECT s.full_name as student_name, 
               t.name as test_name, 
               tr.score, 
               tr.finish_at, 
               g.name as grade_name 
        FROM test_record tr 
        JOIN student s ON tr.student_id = s.id 
        JOIN test t ON tr.test_id = t.id 
        JOIN grade g ON s.grade_id = g.id 
        WHERE tr.finish_at IS NOT NULL 
        ORDER BY tr.finish_at DESC 
        LIMIT 10
    """;

            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("studentName", rs.getString("student_name"));
                    activity.put("testName", rs.getString("test_name"));
                    // Keep score as is (0-10 scale)
                    activity.put("score", Math.round(rs.getDouble("score") * 100.0) / 100.0);
                    activity.put("finishAt", rs.getTimestamp("finish_at"));
                    activity.put("gradeName", rs.getString("grade_name"));
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
            String sql = """
        SELECT g.name as grade_name, 
               COUNT(DISTINCT s.id) as total_students,
               COUNT(DISTINCT CASE WHEN tr.finish_at IS NOT NULL THEN tr.id END) as total_tests_taken,
               COALESCE(AVG(CASE WHEN tr.finish_at IS NOT NULL THEN tr.score END), 0) as avg_score
        FROM grade g 
        LEFT JOIN student s ON g.id = s.grade_id 
        LEFT JOIN test_record tr ON s.id = tr.student_id AND tr.finish_at IS NOT NULL
        GROUP BY g.id, g.name 
        ORDER BY g.name
    """;

            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("gradeName", rs.getString("grade_name"));
                    data.put("totalStudents", rs.getInt("total_students"));
                    data.put("totalTestsTaken", rs.getInt("total_tests_taken"));
                    double avgScore = rs.getDouble("avg_score");
                    // Keep score as is (0-10 scale), don't multiply by 100
                    data.put("avgScore", Math.round(avgScore * 100.0) / 100.0);
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
     * Get subject distribution data
     */
    public List<Map<String, Object>> getSubjectDistribution() throws SQLException {
        List<Map<String, Object>> subjectData = new ArrayList<>();

        try {
            String sql = """
        SELECT s.name as subject_name, 
               COUNT(DISTINCT ch.id) as chapter_count, 
               COUNT(DISTINCT l.id) as lesson_count,
               COUNT(DISTINCT q.id) as question_count
        FROM subject s 
        LEFT JOIN chapter ch ON s.id = ch.subject_id 
        LEFT JOIN lesson l ON ch.id = l.chapter_id 
        LEFT JOIN question q ON l.id = q.lesson_id
        GROUP BY s.id, s.name 
        HAVING lesson_count > 0
        ORDER BY lesson_count DESC
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("subjectName", rs.getString("subject_name"));
                    data.put("chapterCount", rs.getInt("chapter_count"));
                    data.put("lessonCount", rs.getInt("lesson_count"));
                    data.put("questionCount", rs.getInt("question_count"));
                    subjectData.add(data);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getSubjectDistribution: " + e.getMessage());
            e.printStackTrace();
        }

        return subjectData;
    }

    /**
     * Get package sales data with accurate revenue calculation
     */
    public Map<String, Object> getPackageStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        try {
            // Calculate total revenue from paid invoices
            double totalRevenue = 0.0;
            int totalPaidInvoices = 0;

            try {
                // Get total revenue and count of paid invoices
                String sql1 = """
                SELECT COUNT(*) as paid_count,
                       SUM(CASE 
                           WHEN total_amount IS NOT NULL AND total_amount != '' 
                           THEN CAST(total_amount AS DECIMAL(10,2)) 
                           ELSE 0 
                       END) as total_revenue
                FROM invoice 
                WHERE status = 'paid' OR status = 'completed'
            """;

                try (PreparedStatement ps = connection.prepareStatement(sql1); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalPaidInvoices = rs.getInt("paid_count");
                        totalRevenue = rs.getDouble("total_revenue");
                        if (rs.wasNull()) {
                            totalRevenue = 0.0;
                        }
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error calculating revenue: " + e.getMessage());
                totalRevenue = 0.0;
                totalPaidInvoices = 0;
            }

            stats.put("totalRevenue", totalRevenue);
            stats.put("totalPaidInvoices", totalPaidInvoices);

            // Calculate average order value
            double avgOrderValue = 0.0;
            if (totalPaidInvoices > 0) {
                avgOrderValue = totalRevenue / totalPaidInvoices;
            }
            stats.put("averageOrderValue", Math.round(avgOrderValue * 100.0) / 100.0);

            // Get package sales breakdown
            List<Map<String, Object>> packageSales = new ArrayList<>();
            try {
                String sql2 = """
                SELECT sp.name,
                       COUNT(DISTINCT i.id) as sales_count,
                       SUM(CASE 
                           WHEN i.total_amount IS NOT NULL AND i.total_amount != '' 
                           THEN CAST(i.total_amount AS DECIMAL(10,2)) 
                           ELSE 0 
                       END) as package_revenue
                FROM study_package sp
                LEFT JOIN invoice_line il ON sp.id = il.package_id
                LEFT JOIN invoice i ON il.invoice_id = i.id AND i.status = 'paid' OR i.status = 'completed'
                GROUP BY sp.id, sp.name
                ORDER BY sales_count DESC, sp.name
            """;

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
            }

            stats.put("packageSales", packageSales);

            // Additional statistics
            try {
                // Get total pending invoices
                String sql3 = "SELECT COUNT(*) as pending_invoices FROM invoice WHERE status = 'pending'";
                try (PreparedStatement ps = connection.prepareStatement(sql3); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("totalPendingInvoices", rs.getInt("pending_invoices"));
                    }
                }

                // Get total invoices
                String sql4 = "SELECT COUNT(*) as total_invoices FROM invoice";
                try (PreparedStatement ps = connection.prepareStatement(sql4); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("totalInvoices", rs.getInt("total_invoices"));
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
            stats.put("totalPendingInvoices", 0);
            stats.put("totalInvoices", 0);
        }

        return stats;
    }

    /**
     * Get parent dashboard statistics
     */
    public Map<String, Object> getParentDashboardData(int parentId) throws SQLException {
        Map<String, Object> dashboardData = new HashMap<>();

        try {
            // Get children count and basic info
            Map<String, Object> childrenStats = getChildrenStatistics(parentId);
            dashboardData.put("childrenStats", childrenStats);

            // Get test performance data
            List<Map<String, Object>> testPerformance = getChildrenTestPerformance(parentId);
            dashboardData.put("testPerformance", testPerformance);

            // Get recent test activities
            List<Map<String, Object>> recentActivities = getChildrenRecentActivities(parentId);
            dashboardData.put("recentActivities", recentActivities);

            // Get monthly progress
            List<Map<String, Object>> monthlyProgress = getChildrenMonthlyProgress(parentId);
            dashboardData.put("monthlyProgress", monthlyProgress);

            // Get subject performance
            List<Map<String, Object>> subjectPerformance = getChildrenSubjectPerformance(parentId);
            dashboardData.put("subjectPerformance", subjectPerformance);

            // Get grade distribution
            Map<String, Object> gradeDistribution = getChildrenGradeDistribution(parentId);
            dashboardData.put("gradeDistribution", gradeDistribution);

            // Get invoice summary
            Map<String, Object> invoiceSummary = getParentInvoiceSummary(parentId);
            dashboardData.put("invoiceSummary", invoiceSummary);

        } catch (SQLException e) {
            System.err.println("Error in getParentDashboardData: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return dashboardData;
    }

    /**
     * Get children statistics for parent
     */
    public Map<String, Object> getChildrenStatistics(int parentId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        try {
            String sql = """
            SELECT 
                COUNT(DISTINCT s.id) as total_children,
                COUNT(DISTINCT tr.id) as total_tests_taken,
                COUNT(DISTINCT CASE WHEN tr.finish_at IS NOT NULL THEN tr.id END) as completed_tests,
                COALESCE(AVG(CASE WHEN tr.finish_at IS NOT NULL THEN tr.score END), 0) as avg_score,
                COUNT(DISTINCT CASE WHEN DATE(tr.started_at) = CURDATE() THEN tr.id END) as tests_today
            FROM student s
            LEFT JOIN test_record tr ON s.id = tr.student_id
            WHERE s.parent_id = ?
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("totalChildren", rs.getInt("total_children"));
                        stats.put("totalTestsTaken", rs.getInt("total_tests_taken"));
                        stats.put("completedTests", rs.getInt("completed_tests"));
                        stats.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        stats.put("testsToday", rs.getInt("tests_today"));
                    }
                }
            }

            // Calculate completion rate
            int totalTests = (Integer) stats.getOrDefault("totalTestsTaken", 0);
            int completedTests = (Integer) stats.getOrDefault("completedTests", 0);
            double completionRate = totalTests > 0 ? (double) completedTests / totalTests * 100 : 0;
            stats.put("completionRate", Math.round(completionRate * 100.0) / 100.0);

        } catch (SQLException e) {
            System.err.println("Error in getChildrenStatistics: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Get children test performance data
     */
    public List<Map<String, Object>> getChildrenTestPerformance(int parentId) throws SQLException {
        List<Map<String, Object>> performance = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                s.full_name as student_name,
                s.id as student_id,
                COUNT(DISTINCT tr.id) as total_tests,
                COUNT(DISTINCT CASE WHEN tr.finish_at IS NOT NULL THEN tr.id END) as completed_tests,
                COALESCE(AVG(CASE WHEN tr.finish_at IS NOT NULL THEN tr.score END), 0) as avg_score,
                COALESCE(MAX(tr.score), 0) as best_score,
                g.name as grade_name
            FROM student s
            LEFT JOIN test_record tr ON s.id = tr.student_id
            LEFT JOIN grade g ON s.grade_id = g.id
            WHERE s.parent_id = ?
            GROUP BY s.id, s.full_name, g.name
            ORDER BY avg_score DESC
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("studentName", rs.getString("student_name"));
                        data.put("studentId", rs.getInt("student_id"));
                        data.put("totalTests", rs.getInt("total_tests"));
                        data.put("completedTests", rs.getInt("completed_tests"));
                        data.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        data.put("bestScore", Math.round(rs.getDouble("best_score") * 100.0) / 100.0);
                        data.put("gradeName", rs.getString("grade_name"));
                        performance.add(data);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getChildrenTestPerformance: " + e.getMessage());
            e.printStackTrace();
        }

        return performance;
    }

    /**
     * Get children recent activities
     */
    public List<Map<String, Object>> getChildrenRecentActivities(int parentId) throws SQLException {
        List<Map<String, Object>> activities = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                s.full_name as student_name,
                t.name as test_name,
                tr.score,
                tr.finish_at,
                tr.started_at,
                CASE WHEN t.is_practice = 1 THEN 'Practice' ELSE 'Official' END as test_type
            FROM student s
            JOIN test_record tr ON s.id = tr.student_id
            JOIN test t ON tr.test_id = t.id
            WHERE s.parent_id = ?
            ORDER BY COALESCE(tr.finish_at, tr.started_at) DESC
            LIMIT 10
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> activity = new HashMap<>();
                        activity.put("studentName", rs.getString("student_name"));
                        activity.put("testName", rs.getString("test_name"));
                        activity.put("score", rs.getObject("score"));
                        activity.put("finishAt", rs.getTimestamp("finish_at"));
                        activity.put("startedAt", rs.getTimestamp("started_at"));
                        activity.put("testType", rs.getString("test_type"));
                        activities.add(activity);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getChildrenRecentActivities: " + e.getMessage());
            e.printStackTrace();
        }

        return activities;
    }

    /**
     * Get children monthly progress
     */
    public List<Map<String, Object>> getChildrenMonthlyProgress(int parentId) throws SQLException {
        List<Map<String, Object>> progress = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                DATE_FORMAT(tr.finish_at, '%Y-%m') as month,
                COUNT(DISTINCT tr.id) as tests_completed,
                COALESCE(AVG(tr.score), 0) as avg_score,
                COUNT(DISTINCT s.id) as active_children
            FROM student s
            LEFT JOIN test_record tr ON s.id = tr.student_id AND tr.finish_at IS NOT NULL
            WHERE s.parent_id = ?
            AND tr.finish_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
            GROUP BY DATE_FORMAT(tr.finish_at, '%Y-%m')
            ORDER BY month DESC
            LIMIT 6
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("month", rs.getString("month"));
                        data.put("testsCompleted", rs.getInt("tests_completed"));
                        data.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        data.put("activeChildren", rs.getInt("active_children"));
                        progress.add(data);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getChildrenMonthlyProgress: " + e.getMessage());
            e.printStackTrace();
        }

        return progress;
    }

    /**
     * Get children subject performance
     */
    public List<Map<String, Object>> getChildrenSubjectPerformance(int parentId) throws SQLException {
        List<Map<String, Object>> subjectPerf = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                sub.name as subject_name,
                COUNT(DISTINCT tr.id) as tests_taken,
                COALESCE(AVG(tr.score), 0) as avg_score,
                COUNT(DISTINCT s.id) as students_count
            FROM student s
            JOIN grade g ON s.grade_id = g.id
            JOIN subject sub ON g.id = sub.grade_id
            LEFT JOIN chapter ch ON sub.id = ch.subject_id
            LEFT JOIN lesson l ON ch.id = l.chapter_id
            LEFT JOIN question q ON l.id = q.lesson_id
            LEFT JOIN test_question tq ON q.id = tq.question_id
            LEFT JOIN test_record tr ON tq.test_id = tr.test_id AND tr.student_id = s.id AND tr.finish_at IS NOT NULL
            WHERE s.parent_id = ?
            GROUP BY sub.id, sub.name
            HAVING tests_taken > 0
            ORDER BY avg_score DESC
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("subjectName", rs.getString("subject_name"));
                        data.put("testsTaken", rs.getInt("tests_taken"));
                        data.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        data.put("studentsCount", rs.getInt("students_count"));
                        subjectPerf.add(data);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getChildrenSubjectPerformance: " + e.getMessage());
            e.printStackTrace();
        }

        return subjectPerf;
    }

    /**
     * Get children grade distribution
     */
    public Map<String, Object> getChildrenGradeDistribution(int parentId) throws SQLException {
        Map<String, Object> distribution = new HashMap<>();

        try {
            String sql = """
            SELECT 
                g.name as grade_name,
                COUNT(s.id) as student_count
            FROM student s
            JOIN grade g ON s.grade_id = g.id
            WHERE s.parent_id = ?
            GROUP BY g.id, g.name
            ORDER BY g.name
        """;

            List<Map<String, Object>> gradeData = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("gradeName", rs.getString("grade_name"));
                        data.put("studentCount", rs.getInt("student_count"));
                        gradeData.add(data);
                    }
                }
            }
            distribution.put("gradeData", gradeData);

        } catch (SQLException e) {
            System.err.println("Error in getChildrenGradeDistribution: " + e.getMessage());
            e.printStackTrace();
        }

        return distribution;
    }

    /**
     * Get parent invoice summary
     */
    public Map<String, Object> getParentInvoiceSummary(int parentId) throws SQLException {
        Map<String, Object> summary = new HashMap<>();

        try {
            String sql = """
            SELECT 
                COUNT(*) as total_invoices,
                COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_invoices,
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_invoices,
                COALESCE(SUM(CASE WHEN status = 'paid' AND total_amount IS NOT NULL AND total_amount != '' 
                    THEN CAST(total_amount AS DECIMAL(10,2)) END), 0) as total_paid_amount,
                COALESCE(SUM(CASE WHEN status = 'pending' AND total_amount IS NOT NULL AND total_amount != '' 
                    THEN CAST(total_amount AS DECIMAL(10,2)) END), 0) as pending_amount
            FROM invoice
            WHERE parent_id = ?
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        summary.put("totalInvoices", rs.getInt("total_invoices"));
                        summary.put("paidInvoices", rs.getInt("paid_invoices"));
                        summary.put("pendingInvoices", rs.getInt("pending_invoices"));
                        summary.put("totalPaidAmount", rs.getDouble("total_paid_amount"));
                        summary.put("pendingAmount", rs.getDouble("pending_amount"));
                    }
                }
            }

            // Get recent invoices
            String recentSql = """
            SELECT id, total_amount, status, created_at
            FROM invoice
            WHERE parent_id = ?
            ORDER BY created_at DESC
            LIMIT 5
        """;

            List<Map<String, Object>> recentInvoices = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(recentSql)) {
                ps.setInt(1, parentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> invoice = new HashMap<>();
                        invoice.put("id", rs.getInt("id"));
                        invoice.put("amount", rs.getString("total_amount"));
                        invoice.put("status", rs.getString("status"));
                        invoice.put("createdAt", rs.getTimestamp("created_at"));
                        recentInvoices.add(invoice);
                    }
                }
            }
            summary.put("recentInvoices", recentInvoices);

        } catch (SQLException e) {
            System.err.println("Error in getParentInvoiceSummary: " + e.getMessage());
            e.printStackTrace();
        }

        return summary;
    }

    /**
     * Get comprehensive dashboard data for student
     */
    public Map<String, Object> getStudentDashboardData(int studentId) throws SQLException {
        Map<String, Object> dashboardData = new HashMap<>();

        try {
            // Get student basic statistics
            Map<String, Object> studentStats = getStudentStatistics(studentId);
            dashboardData.put("studentStats", studentStats);

            // Get test performance over time
            List<Map<String, Object>> testPerformance = getStudentTestPerformance(studentId);
            dashboardData.put("testPerformance", testPerformance);

            // Get recent test activities
            List<Map<String, Object>> recentActivities = getStudentRecentActivities(studentId);
            dashboardData.put("recentActivities", recentActivities);

            // Get monthly activity
            List<Map<String, Object>> monthlyActivity = getStudentMonthlyActivity(studentId);
            dashboardData.put("monthlyActivity", monthlyActivity);

            // Get subject performance
            List<Map<String, Object>> subjectPerformance = getStudentSubjectPerformance(studentId);
            dashboardData.put("subjectPerformance", subjectPerformance);

            // Get test type distribution
            Map<String, Object> testTypeDistribution = getStudentTestTypeDistribution(studentId);
            dashboardData.put("testTypeDistribution", testTypeDistribution);

            // Get upcoming tests/available tests
            List<Map<String, Object>> availableTests = getAvailableTestsForStudent(studentId);
            dashboardData.put("availableTests", availableTests);

            // Get study progress
            Map<String, Object> studyProgress = getStudentStudyProgress(studentId);
            dashboardData.put("studyProgress", studyProgress);

        } catch (SQLException e) {
            System.err.println("Error in getStudentDashboardData: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return dashboardData;
    }

    /**
     * Get student basic statistics
     */
    public Map<String, Object> getStudentStatistics(int studentId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        try {
            String sql = """
            SELECT 
                COUNT(DISTINCT tr.id) as total_tests_taken,
                COUNT(DISTINCT CASE WHEN tr.finish_at IS NOT NULL THEN tr.id END) as completed_tests,
                COALESCE(AVG(CASE WHEN tr.finish_at IS NOT NULL THEN tr.score END), 0) as avg_score,
                COALESCE(MAX(tr.score), 0) as best_score,
                COUNT(DISTINCT CASE WHEN DATE(tr.started_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN tr.id END) as tests_this_week,
                COUNT(DISTINCT CASE WHEN DATE(tr.started_at) = CURDATE() THEN tr.id END) as tests_today
            FROM test_record tr
            WHERE tr.student_id = ?
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.put("totalTestsTaken", rs.getInt("total_tests_taken"));
                        stats.put("completedTests", rs.getInt("completed_tests"));
                        stats.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        stats.put("bestScore", Math.round(rs.getDouble("best_score") * 100.0) / 100.0);
                        stats.put("testsThisWeek", rs.getInt("tests_this_week"));
                        stats.put("testsToday", rs.getInt("tests_today"));
                    }
                }
            }

            // Calculate completion rate
            int totalTests = (Integer) stats.getOrDefault("totalTestsTaken", 0);
            int completedTests = (Integer) stats.getOrDefault("completedTests", 0);
            double completionRate = totalTests > 0 ? (double) completedTests / totalTests * 100 : 0;
            stats.put("completionRate", Math.round(completionRate * 100.0) / 100.0);

            // Get current streak
            int currentStreak = getStudentCurrentStreak(studentId);
            stats.put("currentStreak", currentStreak);

        } catch (SQLException e) {
            System.err.println("Error in getStudentStatistics: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Get student test performance over time
     */
    public List<Map<String, Object>> getStudentTestPerformance(int studentId) throws SQLException {
        List<Map<String, Object>> performance = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                DATE(tr.finish_at) as test_date,
                tr.score,
                t.name as test_name,
                CASE WHEN t.is_practice = 1 THEN 'Practice' ELSE 'Official' END as test_type
            FROM test_record tr
            JOIN test t ON tr.test_id = t.id
            WHERE tr.student_id = ? AND tr.finish_at IS NOT NULL
            ORDER BY tr.finish_at DESC
            LIMIT 20
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("testDate", rs.getDate("test_date"));
                        data.put("score", Math.round(rs.getDouble("score") * 100.0) / 100.0);
                        data.put("testName", rs.getString("test_name"));
                        data.put("testType", rs.getString("test_type"));
                        performance.add(data);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getStudentTestPerformance: " + e.getMessage());
            e.printStackTrace();
        }

        return performance;
    }

    /**
     * Get student recent activities
     */
    public List<Map<String, Object>> getStudentRecentActivities(int studentId) throws SQLException {
        List<Map<String, Object>> activities = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                t.name as test_name,
                tr.score,
                tr.finish_at,
                tr.started_at,
                CASE WHEN t.is_practice = 1 THEN 'Practice' ELSE 'Official' END as test_type,
                c.name as category_name
            FROM test_record tr
            JOIN test t ON tr.test_id = t.id
            LEFT JOIN category c ON t.category_id = c.id
            WHERE tr.student_id = ?
            ORDER BY COALESCE(tr.finish_at, tr.started_at) DESC
            LIMIT 10
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> activity = new HashMap<>();
                        activity.put("testName", rs.getString("test_name"));
                        activity.put("score", rs.getObject("score"));
                        activity.put("finishAt", rs.getTimestamp("finish_at"));
                        activity.put("startedAt", rs.getTimestamp("started_at"));
                        activity.put("testType", rs.getString("test_type"));
                        activity.put("categoryName", rs.getString("category_name"));
                        activities.add(activity);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getStudentRecentActivities: " + e.getMessage());
            e.printStackTrace();
        }

        return activities;
    }

    /**
     * Get student monthly activity
     */
    public List<Map<String, Object>> getStudentMonthlyActivity(int studentId) throws SQLException {
        List<Map<String, Object>> activity = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                DATE_FORMAT(tr.finish_at, '%Y-%m') as month,
                COUNT(DISTINCT tr.id) as tests_completed,
                COALESCE(AVG(tr.score), 0) as avg_score
            FROM test_record tr
            WHERE tr.student_id = ? AND tr.finish_at IS NOT NULL
            AND tr.finish_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
            GROUP BY DATE_FORMAT(tr.finish_at, '%Y-%m')
            ORDER BY month DESC
            LIMIT 6
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("month", rs.getString("month"));
                        data.put("testsCompleted", rs.getInt("tests_completed"));
                        data.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        activity.add(data);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getStudentMonthlyActivity: " + e.getMessage());
            e.printStackTrace();
        }

        return activity;
    }

    /**
     * Get student subject performance
     */
    public List<Map<String, Object>> getStudentSubjectPerformance(int studentId) throws SQLException {
        List<Map<String, Object>> subjectPerf = new ArrayList<>();

        try {
            String sql = """
            SELECT 
                sub.name as subject_name,
                COUNT(DISTINCT tr.id) as tests_taken,
                COALESCE(AVG(tr.score), 0) as avg_score,
                COALESCE(MAX(tr.score), 0) as best_score
            FROM student s
            JOIN grade g ON s.grade_id = g.id
            JOIN subject sub ON g.id = sub.grade_id
            LEFT JOIN chapter ch ON sub.id = ch.subject_id
            LEFT JOIN lesson l ON ch.id = l.chapter_id
            LEFT JOIN question q ON l.id = q.lesson_id
            LEFT JOIN test_question tq ON q.id = tq.question_id
            LEFT JOIN test_record tr ON tq.test_id = tr.test_id AND tr.student_id = s.id AND tr.finish_at IS NOT NULL
            WHERE s.id = ?
            GROUP BY sub.id, sub.name
            HAVING tests_taken > 0
            ORDER BY avg_score DESC
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("subjectName", rs.getString("subject_name"));
                        data.put("testsTaken", rs.getInt("tests_taken"));
                        data.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        data.put("bestScore", Math.round(rs.getDouble("best_score") * 100.0) / 100.0);
                        subjectPerf.add(data);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getStudentSubjectPerformance: " + e.getMessage());
            e.printStackTrace();
        }

        return subjectPerf;
    }

    /**
     * Get student test type distribution
     */
    public Map<String, Object> getStudentTestTypeDistribution(int studentId) throws SQLException {
        Map<String, Object> distribution = new HashMap<>();

        try {
            String sql = """
            SELECT 
                CASE WHEN t.is_practice = 1 THEN 'Practice' ELSE 'Official' END as test_type,
                COUNT(tr.id) as test_count,
                COALESCE(AVG(tr.score), 0) as avg_score
            FROM test_record tr
            JOIN test t ON tr.test_id = t.id
            WHERE tr.student_id = ? AND tr.finish_at IS NOT NULL
            GROUP BY t.is_practice
        """;

            List<Map<String, Object>> typeData = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        data.put("testType", rs.getString("test_type"));
                        data.put("testCount", rs.getInt("test_count"));
                        data.put("avgScore", Math.round(rs.getDouble("avg_score") * 100.0) / 100.0);
                        typeData.add(data);
                    }
                }
            }
            distribution.put("typeData", typeData);

        } catch (SQLException e) {
            System.err.println("Error in getStudentTestTypeDistribution: " + e.getMessage());
            e.printStackTrace();
        }

        return distribution;
    }

    /**
     * Get available tests for student
     */
    public List<Map<String, Object>> getAvailableTestsForStudent(int studentId) throws SQLException {
        List<Map<String, Object>> availableTests = new ArrayList<>();

        try {
            String sql = """
            SELECT DISTINCT
                t.id,
                t.name as test_name,
                t.description,
                CASE WHEN t.is_practice = 1 THEN 'Practice' ELSE 'Official' END as test_type,
                c.name as category_name,
                c.duration,
                CASE WHEN tr.id IS NOT NULL THEN 1 ELSE 0 END as already_taken
            FROM test t
            LEFT JOIN category c ON t.category_id = c.id
            LEFT JOIN test_record tr ON t.id = tr.test_id AND tr.student_id = ? AND tr.finish_at IS NOT NULL
            WHERE (t.is_practice = 1 OR (t.is_practice = 0 AND tr.id IS NULL))
            ORDER BY t.is_practice DESC, t.name
            LIMIT 10
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> test = new HashMap<>();
                        test.put("testId", rs.getInt("id"));
                        test.put("testName", rs.getString("test_name"));
                        test.put("description", rs.getString("description"));
                        test.put("testType", rs.getString("test_type"));
                        test.put("categoryName", rs.getString("category_name"));
                        test.put("duration", rs.getInt("duration"));
                        test.put("alreadyTaken", rs.getBoolean("already_taken"));
                        availableTests.add(test);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getAvailableTestsForStudent: " + e.getMessage());
            e.printStackTrace();
        }

        return availableTests;
    }

    /**
     * Get student study progress
     */
    public Map<String, Object> getStudentStudyProgress(int studentId) throws SQLException {
        Map<String, Object> progress = new HashMap<>();

        try {
            // Get total lessons and completed lessons (based on tests taken)
            String sql = """
            SELECT 
                COUNT(DISTINCT l.id) as total_lessons,
                COUNT(DISTINCT CASE WHEN tr.finish_at IS NOT NULL THEN l.id END) as completed_lessons
            FROM student s
            JOIN grade g ON s.grade_id = g.id
            JOIN subject sub ON g.id = sub.grade_id
            JOIN chapter ch ON sub.id = ch.subject_id
            JOIN lesson l ON ch.id = l.chapter_id
            LEFT JOIN question q ON l.id = q.lesson_id
            LEFT JOIN test_question tq ON q.id = tq.question_id
            LEFT JOIN test_record tr ON tq.test_id = tr.test_id AND tr.student_id = s.id
            WHERE s.id = ?
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int totalLessons = rs.getInt("total_lessons");
                        int completedLessons = rs.getInt("completed_lessons");
                        double progressPercentage = totalLessons > 0 ? (double) completedLessons / totalLessons * 100 : 0;

                        progress.put("totalLessons", totalLessons);
                        progress.put("completedLessons", completedLessons);
                        progress.put("progressPercentage", Math.round(progressPercentage * 100.0) / 100.0);
                    }
                }
            }

            // Get subjects progress
            String subjectSql = """
            SELECT 
                sub.name as subject_name,
                COUNT(DISTINCT l.id) as total_lessons,
                COUNT(DISTINCT CASE WHEN tr.finish_at IS NOT NULL THEN l.id END) as completed_lessons
            FROM student s
            JOIN grade g ON s.grade_id = g.id
            JOIN subject sub ON g.id = sub.grade_id
            JOIN chapter ch ON sub.id = ch.subject_id
            JOIN lesson l ON ch.id = l.chapter_id
            LEFT JOIN question q ON l.id = q.lesson_id
            LEFT JOIN test_question tq ON q.id = tq.question_id
            LEFT JOIN test_record tr ON tq.test_id = tr.test_id AND tr.student_id = s.id
            WHERE s.id = ?
            GROUP BY sub.id, sub.name
            ORDER BY sub.name
        """;

            List<Map<String, Object>> subjectProgress = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(subjectSql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> data = new HashMap<>();
                        int totalLessons = rs.getInt("total_lessons");
                        int completedLessons = rs.getInt("completed_lessons");
                        double progressPercentage = totalLessons > 0 ? (double) completedLessons / totalLessons * 100 : 0;

                        data.put("subjectName", rs.getString("subject_name"));
                        data.put("totalLessons", totalLessons);
                        data.put("completedLessons", completedLessons);
                        data.put("progressPercentage", Math.round(progressPercentage * 100.0) / 100.0);
                        subjectProgress.add(data);
                    }
                }
            }
            progress.put("subjectProgress", subjectProgress);

        } catch (SQLException e) {
            System.err.println("Error in getStudentStudyProgress: " + e.getMessage());
            e.printStackTrace();
        }

        return progress;
    }

    /**
     * Get student current streak (consecutive days with tests)
     */
    private int getStudentCurrentStreak(int studentId) throws SQLException {
        int streak = 0;
        try {
            String sql = """
            SELECT COUNT(*) as streak
            FROM (
                SELECT DATE(finish_at) as test_date
                FROM test_record 
                WHERE student_id = ? AND finish_at IS NOT NULL
                GROUP BY DATE(finish_at)
                ORDER BY test_date DESC
            ) daily_tests
        """;

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        streak = rs.getInt("streak");
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getStudentCurrentStreak: " + e.getMessage());
        }
        return streak;
    }
}
