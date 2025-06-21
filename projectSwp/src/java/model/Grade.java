/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author BuiNgocLinh
 */
public class Grade {

    private int id;
    private String name;
    private String description;
    private int teacher_id;

    public Grade() {
    }

    public Grade(int id, String name, String description, int teacher_id) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.teacher_id = teacher_id;
    }
    public Grade( String name, String description, int teacher_id) {
        this.name = name;
        this.description = description;
        this.teacher_id = teacher_id;
    }

    public int getTeacher_id() {
        return teacher_id;
    }

    public void setTeacher_id(int teacher_id) {
        this.teacher_id = teacher_id;
    }

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

}
