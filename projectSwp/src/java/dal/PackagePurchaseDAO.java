/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.PackagePurchase;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ankha
 */
public class PackagePurchaseDAO extends DBContext {

    // Create a new purchase record
    public int createPurchase(int parentId, int packageId, String totalAmount, int maxAssignableStudents) {
        String sql = "INSERT INTO package_purchase (parent_id, package_id, total_amount, max_assignable_students, status) VALUES (?, ?, ?, ?, 'PENDING')";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ps.setString(3, totalAmount);
            ps.setInt(4, maxAssignableStudents);

            int result = ps.executeUpdate();
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Complete a purchase (after successful payment)
    public boolean completePurchase(int purchaseId, int invoiceId) {
        String sql = "UPDATE package_purchase SET status = 'COMPLETED', invoice_id = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, purchaseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get parent's total available slots for a package (across all purchases)
    public Map<String, Integer> getParentAvailableSlots(int parentId, int packageId) {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT * FROM parent_package_available_slots WHERE parent_id = ? AND package_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                result.put("totalPurchasedSlots", rs.getInt("total_purchased_slots"));
                result.put("currentlyAssigned", rs.getInt("currently_assigned"));
                result.put("availableSlots", rs.getInt("available_slots"));
            } else {
                // No purchases yet
                result.put("totalPurchasedSlots", 0);
                result.put("currentlyAssigned", 0);
                result.put("availableSlots", 0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    // Get parent's purchase history for a package
    public List<Map<String, Object>> getParentPurchaseHistory(int parentId, int packageId) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT * FROM parent_purchase_history WHERE parent_id = ? AND package_id = ? ORDER BY purchase_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> purchase = new HashMap<>();
                purchase.put("purchaseId", rs.getInt("purchase_id"));
                purchase.put("purchaseDate", rs.getTimestamp("purchase_date"));
                purchase.put("totalAmount", rs.getString("total_amount"));
                purchase.put("maxAssignableStudents", rs.getInt("max_assignable_students"));
                purchase.put("studentsAssigned", rs.getInt("students_assigned"));
                purchase.put("status", rs.getString("status"));
                history.add(purchase);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return history;
    }

    // Get purchase by ID
    public PackagePurchase getPurchaseById(int purchaseId) {
        String sql = "SELECT * FROM package_purchase WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, purchaseId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                PackagePurchase purchase = new PackagePurchase();
                purchase.setId(rs.getInt("id"));
                purchase.setParentId(rs.getInt("parent_id"));
                purchase.setPackageId(rs.getInt("package_id"));
                purchase.setPurchaseDate(rs.getTimestamp("purchase_date").toLocalDateTime());
                purchase.setTotalAmount(rs.getString("total_amount"));
                purchase.setInvoiceId(rs.getObject("invoice_id", Integer.class));
                purchase.setStatus(rs.getString("status"));
                purchase.setMaxAssignableStudents(rs.getInt("max_assignable_students"));
                return purchase;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get available purchase for assignment (has available slots)
    public PackagePurchase getAvailablePurchaseForAssignment(int parentId, int packageId) {
        String sql = """
            SELECT pp.*, 
                   pp.max_assignable_students - COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as available_slots
            FROM package_purchase pp
            LEFT JOIN student_package sp ON pp.id = sp.purchase_id
            WHERE pp.parent_id = ? AND pp.package_id = ? AND pp.status = 'COMPLETED'
            GROUP BY pp.id
            HAVING available_slots > 0
            ORDER BY pp.purchase_date ASC
            LIMIT 1
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ps.setInt(2, packageId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                PackagePurchase purchase = new PackagePurchase();
                purchase.setId(rs.getInt("id"));
                purchase.setParentId(rs.getInt("parent_id"));
                purchase.setPackageId(rs.getInt("package_id"));
                purchase.setPurchaseDate(rs.getTimestamp("purchase_date").toLocalDateTime());
                purchase.setTotalAmount(rs.getString("total_amount"));
                purchase.setInvoiceId(rs.getObject("invoice_id", Integer.class));
                purchase.setStatus(rs.getString("status"));
                purchase.setMaxAssignableStudents(rs.getInt("max_assignable_students"));
                return purchase;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
