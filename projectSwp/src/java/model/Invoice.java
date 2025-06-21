/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;

/**
 *
 * @author BuiNgocLinh
 */
public class Invoice {
    private int id;
    private String total_amount;
    private int parent_id;
    private LocalDate created_at;
    private String status;
    private LocalDate pay_at;

    public Invoice() {
    }

    public Invoice(int id, String total_amount, int parent_id, LocalDate created_at, String status, LocalDate pay_at) {
        this.id = id;
        this.total_amount = total_amount;
        this.parent_id = parent_id;
        this.created_at = created_at;
        this.status = status;
        this.pay_at = pay_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(String total_amount) {
        this.total_amount = total_amount;
    }

    public int getParent_id() {
        return parent_id;
    }

    public void setParent_id(int parent_id) {
        this.parent_id = parent_id;
    }

    public LocalDate getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDate created_at) {
        this.created_at = created_at;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getPay_at() {
        return pay_at;
    }

    public void setPay_at(LocalDate pay_at) {
        this.pay_at = pay_at;
    }
    
    
}
