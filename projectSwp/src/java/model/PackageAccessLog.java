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
public class PackageAccessLog {

    private int id;
    private int student_id;
    private int package_id;
    private Integer lesson_id;
    private String access_type; // VIDEO_VIEW, TEST_TAKE, LESSON_ACCESS
    private LocalDateTime accessed_at;

    public PackageAccessLog() {
    }

    public PackageAccessLog(int student_id, int package_id, Integer lesson_id, String access_type) {
        this.student_id = student_id;
        this.package_id = package_id;
        this.lesson_id = lesson_id;
        this.access_type = access_type;
        this.accessed_at = LocalDateTime.now();
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

    public Integer getLesson_id() {
        return lesson_id;
    }

    public void setLesson_id(Integer lesson_id) {
        this.lesson_id = lesson_id;
    }

    public String getAccess_type() {
        return access_type;
    }

    public void setAccess_type(String access_type) {
        this.access_type = access_type;
    }

    public LocalDateTime getAccessed_at() {
        return accessed_at;
    }

    public void setAccessed_at(LocalDateTime accessed_at) {
        this.accessed_at = accessed_at;
    }
}
