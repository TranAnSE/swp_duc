/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author ankha
 */
public class PackagePurchase {

    private int id;
    private int parentId;
    private int packageId;
    private LocalDateTime purchaseDate;
    private String totalAmount;
    private Integer invoiceId;
    private String status; // PENDING, COMPLETED, CANCELLED
    private int maxAssignableStudents;

    // Constructors
    public PackagePurchase() {
    }

    public PackagePurchase(int parentId, int packageId, String totalAmount, int maxAssignableStudents) {
        this.parentId = parentId;
        this.packageId = packageId;
        this.totalAmount = totalAmount;
        this.maxAssignableStudents = maxAssignableStudents;
        this.status = "PENDING";
        this.purchaseDate = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public int getPackageId() {
        return packageId;
    }

    public void setPackageId(int packageId) {
        this.packageId = packageId;
    }

    public LocalDateTime getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(LocalDateTime purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public String getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(String totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Integer getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(Integer invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getMaxAssignableStudents() {
        return maxAssignableStudents;
    }

    public void setMaxAssignableStudents(int maxAssignableStudents) {
        this.maxAssignableStudents = maxAssignableStudents;
    }
}
