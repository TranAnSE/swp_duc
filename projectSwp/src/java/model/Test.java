package model;

import java.time.LocalDateTime;

public class Test {

    private int id;
    private String name;
    private String description;
    private boolean is_practice;
    private int duration_minutes;
    private int num_questions;
    private Integer course_id;
    private Integer chapter_id;
    private Integer lesson_id;
    private int test_order;
    private Integer created_by;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;

    // Constructors
    public Test() {
        this.duration_minutes = 30; // Default 30 minutes
        this.num_questions = 10; // Default 10 questions
        this.test_order = 1;
    }

    public Test(int id, String name, String description, boolean is_practice) {
        this();
        this.id = id;
        this.name = name;
        this.description = description;
        this.is_practice = is_practice;
    }

    // New constructor for course-integrated tests
    public Test(String name, String description, boolean is_practice,
            int duration_minutes, int num_questions, Integer course_id,
            Integer chapter_id, Integer lesson_id, Integer created_by) {
        this();
        this.name = name;
        this.description = description;
        this.is_practice = is_practice;
        this.duration_minutes = duration_minutes;
        this.num_questions = num_questions;
        this.course_id = course_id;
        this.chapter_id = chapter_id;
        this.lesson_id = lesson_id;
        this.created_by = created_by;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIs_practice() {
        return is_practice;
    }

    public void setIs_practice(boolean is_practice) {
        this.is_practice = is_practice;
    }

    public int getDuration_minutes() {
        return duration_minutes;
    }

    public void setDuration_minutes(int duration_minutes) {
        this.duration_minutes = duration_minutes;
    }

    public int getNum_questions() {
        return num_questions;
    }

    public void setNum_questions(int num_questions) {
        this.num_questions = num_questions;
    }

    public Integer getCourse_id() {
        return course_id;
    }

    public void setCourse_id(Integer course_id) {
        this.course_id = course_id;
    }

    public Integer getChapter_id() {
        return chapter_id;
    }

    public void setChapter_id(Integer chapter_id) {
        this.chapter_id = chapter_id;
    }

    public Integer getLesson_id() {
        return lesson_id;
    }

    public void setLesson_id(Integer lesson_id) {
        this.lesson_id = lesson_id;
    }

    public int getTest_order() {
        return test_order;
    }

    public void setTest_order(int test_order) {
        this.test_order = test_order;
    }

    public Integer getCreated_by() {
        return created_by;
    }

    public void setCreated_by(Integer created_by) {
        this.created_by = created_by;
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

    // Helper methods
    public boolean isCourseIntegrated() {
        return course_id != null && course_id > 0;
    }

    public boolean isChapterSpecific() {
        return chapter_id != null && chapter_id > 0;
    }

    public boolean isLessonSpecific() {
        return lesson_id != null && lesson_id > 0;
    }

    public String getTestType() {
        return is_practice ? "Practice Test" : "Official Test";
    }

    public String getTestScope() {
        if (isLessonSpecific()) {
            return "Lesson Test";
        } else if (isChapterSpecific()) {
            return "Chapter Test";
        } else if (isCourseIntegrated()) {
            return "Course Test";
        } else {
            return "General Test";
        }
    }
}
