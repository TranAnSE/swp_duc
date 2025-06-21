/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author BuiNgocLinh
 */
public class Lesson {

    private int id;
    private String name;
    private String content;
    private int chapter_id;
    private String video_link;

    public Lesson() {
    }

    public Lesson(int id, String name, String content, int chapter_id, String video_link) {
        this.id = id;
        this.name = name;
        this.content = content;
        this.chapter_id = chapter_id;
        this.video_link = video_link;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getChapter_id() {
        return chapter_id;
    }

    public void setChapter_id(int chapter_id) {
        this.chapter_id = chapter_id;
    }

    public String getVideo_link() {
        return video_link;
    }

    public void setVideo_link(String video_link) {
        this.video_link = video_link;
    }

    @Override
    public String toString() {
        return "Lesson{" + "id=" + id + ", name=" + name + ", content=" + content + ", chapter_id=" + chapter_id + ", video_link=" + video_link + '}';
    }

}
