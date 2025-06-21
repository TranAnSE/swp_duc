/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author BuiNgocLinh
 */
public class QuestionRecord {

    private int id;
    private int test_record_id;
    private int question_id;
    private int option_id;

    public QuestionRecord() {
    }

    public QuestionRecord(int id, int test_record_id, int question_id, int option_id) {
        this.id = id;
        this.test_record_id = test_record_id;
        this.question_id = question_id;
        this.option_id = option_id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTest_record_id() {
        return test_record_id;
    }

    public void setTest_record_id(int test_record_id) {
        this.test_record_id = test_record_id;
    }

    public int getQuestion_id() {
        return question_id;
    }

    public void setQuestion_id(int question_id) {
        this.question_id = question_id;
    }

    public int getOption_id() {
        return option_id;
    }

    public void setOption_id(int option_id) {
        this.option_id = option_id;
    }

}
