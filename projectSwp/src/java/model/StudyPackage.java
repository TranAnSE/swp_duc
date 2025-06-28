/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author BuiNgocLinh
 */
public class StudyPackage {

    private int id;
    private String name;
    private String price;
    private String type; // SUBJECT_COMBO or GRADE_ALL
    private Integer grade_id;
    private int max_students;
    private int duration_days;
    private String description;
    private boolean is_active;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;

    public StudyPackage() {
    }

    public StudyPackage(int id, String name, String price) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.type = "SUBJECT_COMBO";
        this.max_students = 1;
        this.duration_days = 365;
        this.is_active = true;
    }

    public StudyPackage(int id, String name, String price, String type, Integer grade_id,
            int max_students, int duration_days, String description) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.type = type;
        this.grade_id = grade_id;
        this.max_students = max_students;
        this.duration_days = duration_days;
        this.description = description;
        this.is_active = true;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getGrade_id() {
        return grade_id;
    }

    public void setGrade_id(Integer grade_id) {
        this.grade_id = grade_id;
    }

    public int getMax_students() {
        return max_students;
    }

    public void setMax_students(int max_students) {
        this.max_students = max_students;
    }

    public int getDuration_days() {
        return duration_days;
    }

    public void setDuration_days(int duration_days) {
        this.duration_days = duration_days;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public LocalDateTime getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(LocalDateTime updated_at) {
        this.updated_at = updated_at;
    }
}
