/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 *
 * @author BuiNgocLinh
 */
public class TestRecord {

    private int id;
    private int student_id;
    private int test_id;
    private LocalDateTime started_at;
    private LocalDateTime finish_at;
    private double score;

    public TestRecord() {
    }

    public TestRecord(int id, int student_id, int test_id, LocalDateTime started_at, LocalDateTime finish_at, double score) {
        this.id = id;
        this.student_id = student_id;
        this.test_id = test_id;
        this.started_at = started_at;
        this.finish_at = finish_at;
        this.score = score;
    }

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

    public int getTest_id() {
        return test_id;
    }

    public void setTest_id(int test_id) {
        this.test_id = test_id;
    }

    public LocalDateTime getStarted_at() {
        return started_at;
    }

    public void setStarted_at(LocalDateTime started_at) {
        this.started_at = started_at;
    }

    public LocalDateTime getFinish_at() {
        return finish_at;
    }

    public void setFinish_at(LocalDateTime finish_at) {
        this.finish_at = finish_at;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }
    
    // Helper methods để convert LocalDateTime sang Date cho JSP
    public Date getStartedAtAsDate() {
        if (started_at != null) {
            return Date.from(started_at.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
    
    public Date getFinishAtAsDate() {
        if (finish_at != null) {
            return Date.from(finish_at.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
    
    // Trả về Timestamp từ started_at cho sử dụng trong controller
    public Timestamp getStart_time() {
        if (started_at != null) {
            return Timestamp.valueOf(started_at);
        }
        return null;
    }
    
    // Trả về Timestamp từ finish_at cho sử dụng trong controller
    public Timestamp getFinish_time() {
        if (finish_at != null) {
            return Timestamp.valueOf(finish_at);
        }
        return null;
    }
}
