/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author BuiNgocLinh
 */
public class Test {
    private int id;
    private String name;
    private String description;
    private boolean is_practice;
    private int category_id;

    public Test() {
    }

    public Test(int id, String name, String description, boolean is_practice, int category_id) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.is_practice = is_practice;
        this.category_id = category_id;
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

    public boolean isIs_practice() {
        return is_practice;
    }

    public void setIs_practice(boolean is_practice) {
        this.is_practice = is_practice;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }
    
    
}
