package model;

public class Question {

    private int id;
    private String question; // Trước đây là name
    private int image_id;
    private int lesson_id;
    private String question_type; // 'SINGLE' hoặc 'MULTIPLE'
    private boolean isAIGenerated;
    private String difficulty;
    private String category;

    public Question() {
    }

    public Question(int id, String question, int image_id, int lesson_id, String question_type) {
        this.id = id;
        this.question = question;
        this.image_id = image_id;
        this.lesson_id = lesson_id;
        this.question_type = question_type;
        this.isAIGenerated = false; // Default is manual
        this.difficulty = "medium";      // Default value
        this.category = "conceptual";    // Default value
    }

    public Question(String question, int image_id, int lesson_id, String question_type) {
        this.question = question;
        this.image_id = image_id;
        this.lesson_id = lesson_id;
        this.question_type = question_type;
        this.isAIGenerated = false; // Default is manual
        this.difficulty = "medium";
        this.category = "conceptual";
    }

    public Question(String question, int image_id, int lesson_id, String question_type, boolean isAIGenerated) {
        this.question = question;
        this.image_id = image_id;
        this.lesson_id = lesson_id;
        this.question_type = question_type;
        this.isAIGenerated = isAIGenerated;
        this.difficulty = "medium";
        this.category = "conceptual";
    }

    public int getId() {
        return id;
    }

    public String getQuestion() {
        return question;
    }

    public int getImage_id() {
        return image_id;
    }

    public int getLesson_id() {
        return lesson_id;
    }

    public String getQuestion_type() {
        return question_type;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public void setImage_id(int image_id) {
        this.image_id = image_id;
    }

    public void setLesson_id(int lesson_id) {
        this.lesson_id = lesson_id;
    }

    public void setQuestion_type(String question_type) {
        this.question_type = question_type;
    }

    public boolean isAIGenerated() {
        return isAIGenerated;
    }

    public void setAIGenerated(boolean isAIGenerated) {
        this.isAIGenerated = isAIGenerated;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
