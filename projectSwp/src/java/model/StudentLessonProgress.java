/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;
import java.math.BigDecimal;

/**
 *
 * @author ankha
 */
public class StudentLessonProgress {

    private int id;
    private int studentId;
    private int lessonId;
    private int courseId;
    private int watchDuration;
    private int totalDuration;
    private BigDecimal completionPercentage;
    private boolean isCompleted;
    private int lastPosition;
    private LocalDateTime firstWatchedAt;
    private LocalDateTime lastWatchedAt;
    private LocalDateTime completedAt;

    // Constructors
    public StudentLessonProgress() {
    }

    public StudentLessonProgress(int studentId, int lessonId, int courseId) {
        this.studentId = studentId;
        this.lessonId = lessonId;
        this.courseId = courseId;
        this.completionPercentage = BigDecimal.ZERO;
        this.isCompleted = false;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getWatchDuration() {
        return watchDuration;
    }

    public void setWatchDuration(int watchDuration) {
        this.watchDuration = watchDuration;
    }

    public int getTotalDuration() {
        return totalDuration;
    }

    public void setTotalDuration(int totalDuration) {
        this.totalDuration = totalDuration;
    }

    public BigDecimal getCompletionPercentage() {
        return completionPercentage;
    }

    public void setCompletionPercentage(BigDecimal completionPercentage) {
        this.completionPercentage = completionPercentage;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }

    public int getLastPosition() {
        return lastPosition;
    }

    public void setLastPosition(int lastPosition) {
        this.lastPosition = lastPosition;
    }

    public LocalDateTime getFirstWatchedAt() {
        return firstWatchedAt;
    }

    public void setFirstWatchedAt(LocalDateTime firstWatchedAt) {
        this.firstWatchedAt = firstWatchedAt;
    }

    public LocalDateTime getLastWatchedAt() {
        return lastWatchedAt;
    }

    public void setLastWatchedAt(LocalDateTime lastWatchedAt) {
        this.lastWatchedAt = lastWatchedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }
}
