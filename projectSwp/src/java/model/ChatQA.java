package model;

public class ChatQA {
    private int id;
    private String question;
    private String key;
    private String answer;

    public ChatQA() {}

    public ChatQA(int id, String question, String key, String answer) {
        this.id = id;
        this.question = question;
        this.key = key;
        this.answer = answer;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getQuestion() {
        return question;
    }
    public void setQuestion(String question) {
        this.question = question;
    }

    public String getKey() {
        return key;
    }
    public void setKey(String key) {
        this.key = key;
    }

    public String getAnswer() {
        return answer;
    }
    public void setAnswer(String answer) {
        this.answer = answer;
    }
}
