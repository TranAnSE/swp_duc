package dal;

import model.Invoice;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;

public class InvoiceDAO extends DBContext {

    public int insertInvoice(Invoice invoice) {
        String sql = "INSERT INTO invoice (total_amount, parent_id, created_at, status, update_at) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, invoice.getTotal_amount());
            stmt.setInt(2, invoice.getParent_id());
            stmt.setDate(3, Date.valueOf(invoice.getCreated_at()));
            stmt.setString(4, invoice.getStatus());
            if (invoice.getPay_at() != null) {
                stmt.setDate(5, Date.valueOf(invoice.getPay_at()));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                // Lấy ID được tạo tự động
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        invoice.setId(generatedId);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return generatedId;
    }

    public void updateInvoice(Invoice invoice) {
        String sql = "UPDATE invoice SET total_amount = ?, parent_id = ?, created_at = ?, status = ?, update_at = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, invoice.getTotal_amount());
            stmt.setInt(2, invoice.getParent_id());
            stmt.setDate(3, Date.valueOf(invoice.getCreated_at()));
            stmt.setString(4, invoice.getStatus());
            if (invoice.getPay_at() != null) {
                stmt.setDate(5, Date.valueOf(invoice.getPay_at()));
            } else {
                stmt.setNull(5, Types.DATE);
            }
            stmt.setInt(6, invoice.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Phương thức mới để cập nhật trạng thái hóa đơn sau khi thanh toán
    public void updateInvoiceStatus(Invoice invoice) {
        // Lấy thông tin invoice hiện tại
        Invoice currentInvoice = getInvoiceById(invoice.getId());
        if (currentInvoice == null) {
            System.out.println("Error: Invoice not found with ID " + invoice.getId());
            return;
        }
        
        String sql = "UPDATE invoice SET status = ?, update_at = ? WHERE id = ?";
        System.out.println("Updating invoice status - SQL: " + sql);
        System.out.println("Invoice ID: " + invoice.getId() + ", Status: " + invoice.getStatus() + ", Pay Date: " + invoice.getPay_at());
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, invoice.getStatus());
            stmt.setDate(2, invoice.getPay_at() != null ? Date.valueOf(invoice.getPay_at()) : Date.valueOf(LocalDate.now()));
            stmt.setInt(3, invoice.getId());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Update invoice status result: " + rowsAffected + " rows affected");
            
            // Đảm bảo cập nhật thành công
            if (rowsAffected <= 0) {
                System.out.println("Warning: No rows affected when updating invoice status");
            }
        } catch (SQLException e) {
            System.out.println("Error updating invoice status: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Phương thức mới để thêm dòng chi tiết hóa đơn
    public void insertInvoiceLine(int invoiceId, int packageId) {
        String sql = "INSERT INTO invoice_line (invoice_id, package_id) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, invoiceId);
            stmt.setInt(2, packageId);
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteInvoice(int id) {
        String sql = "DELETE FROM invoice WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM invoice";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Invoice invoice = new Invoice(
                        rs.getInt("id"),
                        rs.getString("total_amount"),
                        rs.getInt("parent_id"),
                        rs.getDate("created_at").toLocalDate(),
                        rs.getString("status"),
                        rs.getDate("update_at") != null ? rs.getDate("update_at").toLocalDate() : null
                );
                  list.add(invoice);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

  public Invoice getInvoiceById(int id) {
    Invoice invoice = null;
    String sql = "SELECT * FROM invoice WHERE id = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            invoice = new Invoice();
            invoice.setId(rs.getInt("id"));
            invoice.setTotal_amount(rs.getString("total_amount"));
            invoice.setParent_id(rs.getInt("parent_id"));
            invoice.setCreated_at(rs.getDate("created_at").toLocalDate());
            invoice.setStatus(rs.getString("status"));
            invoice.setPay_at(rs.getDate("update_at") != null ? rs.getDate("update_at").toLocalDate() : null);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return invoice;
}

}