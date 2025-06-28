/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Date;

/**
 *
 * @author ankha
 */
public class StudentPackage {

    private int id;
    private int student_id;
    private int package_id;
    private int parent_id;
    private LocalDateTime purchased_at;
    private LocalDateTime expires_at;
    private boolean is_active;

    // Additional fields for display
    private String package_name;
    private String student_name;
    private String parent_name;

    public StudentPackage() {
    }

    public StudentPackage(int student_id, int package_id, int parent_id, LocalDateTime expires_at) {
        this.student_id = student_id;
        this.package_id = package_id;
        this.parent_id = parent_id;
        this.expires_at = expires_at;
        this.is_active = true;
        this.purchased_at = LocalDateTime.now();
    }

    // Helper methods for JSP compatibility
    public boolean isActive() {
        return is_active && expires_at != null && expires_at.isAfter(LocalDateTime.now());
    }
    
    public boolean isExpired() {
        return !is_active || expires_at == null || expires_at.isBefore(LocalDateTime.now());
    }
    
    public long getDaysRemaining() {
        if (expires_at == null || expires_at.isBefore(LocalDateTime.now())) {
            return 0;
        }
        return ChronoUnit.DAYS.between(LocalDateTime.now(), expires_at);
    }
    
    public String getStatusClass() {
        return isActive() ? "active" : "expired";
    }
    
    public String getStatusBadgeClass() {
        return isActive() ? "status-active" : "status-expired";
    }
    
    public String getStatusText() {
        return isActive() ? "Active" : "Expired";
    }

    // Date conversion methods for JSP fmt:formatDate compatibility
    public Date getPurchasedAtAsDate() {
        if (purchased_at != null) {
            return Date.from(purchased_at.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
    
    public Date getExpiresAtAsDate() {
        if (expires_at != null) {
            return Date.from(expires_at.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
    
    // Formatted string methods for direct display
    public String getFormattedPurchasedAt() {
        if (purchased_at != null) {
            return purchased_at.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "";
    }
    
    public String getFormattedExpiresAt() {
        if (expires_at != null) {
            return expires_at.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        }
        return "";
    }
    
    public String getFormattedPurchasedDate() {
        if (purchased_at != null) {
            return purchased_at.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "";
    }
    
    public String getFormattedExpiresDate() {
        if (expires_at != null) {
            return expires_at.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return "";
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudent_id() {
        return student_id;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }

    public int getPackage_id() {
        return package_id;
    }

    public void setPackage_id(int package_id) {
        this.package_id = package_id;
    }

    public int getParent_id() {
        return parent_id;
    }

    public void setParent_id(int parent_id) {
        this.parent_id = parent_id;
    }

    public LocalDateTime getPurchased_at() {
        return purchased_at;
    }

    public void setPurchased_at(LocalDateTime purchased_at) {
        this.purchased_at = purchased_at;
    }

    public LocalDateTime getExpires_at() {
        return expires_at;
    }

    public void setExpires_at(LocalDateTime expires_at) {
        this.expires_at = expires_at;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    public String getPackage_name() {
        return package_name;
    }

    public void setPackage_name(String package_name) {
        this.package_name = package_name;
    }

    public String getStudent_name() {
        return student_name;
    }

    public void setStudent_name(String student_name) {
        this.student_name = student_name;
    }

    public String getParent_name() {
        return parent_name;
    }

    public void setParent_name(String parent_name) {
        this.parent_name = parent_name;
    }
}
