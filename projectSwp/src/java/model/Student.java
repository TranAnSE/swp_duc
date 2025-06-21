/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
import java.time.LocalDate;

/**
 *
 * @author BuiNgocLinh
 */
public class Student {

    private int id;
    private int grade_id;
    private int parent_id;
    private String username;
    private String password;
    private String full_name;
    private LocalDate dob;
    private boolean sex;
    private int image_id;

    public Student() {
    }

    public Student(int id, int grade_id, int parent_id, String username, String password, String full_name, LocalDate dob, boolean sex, int image_id) {
        this.id = id;
        this.grade_id = grade_id;
        this.parent_id = parent_id;
        this.username = username;
        this.password = password;
        this.full_name = full_name;
        this.dob = dob;
        this.sex = sex;
        this.image_id = image_id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getGrade_id() {
        return grade_id;
    }

    public void setGrade_id(int grade_id) {
        this.grade_id = grade_id;
    }

    public int getParent_id() {
        return parent_id;
    }

    public void setParent_id(int parent_id) {
        this.parent_id = parent_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public boolean isSex() {
        return sex;
    }

    public void setSex(boolean sex) {
        this.sex = sex;
    }

    public int getImage_id() {
        return image_id;
    }

    public void setImage_id(int image_id) {
        this.image_id = image_id;
    }
    
    public Date getFormattedDate() {
        return Date.valueOf(dob);
    }
}
