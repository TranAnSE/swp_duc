/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Question;

/**
 *
 * @author Na
 */
public class QuestionDAO extends DBContext {

    public Connection getDBConnection() {
        return this.connection;
    }

    public List<Question> findAllQuestion() throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Question q = new Question(
                        rs.getInt("id"),
                        rs.getString("question"),
                        rs.getInt("image_id"),
                        rs.getInt("lesson_id"),
                        rs.getString("question_type")
                );
                try {
                    q.setAIGenerated(rs.getBoolean("is_ai_generated"));
                } catch (SQLException e) {
                    q.setAIGenerated(false);
                }
                try {
                    q.setDifficulty(rs.getString("difficulty"));
                    q.setCategory(rs.getString("category"));
                } catch (SQLException e) {
                    q.setDifficulty("medium");
                    q.setCategory("conceptual");
                }
                list.add(q);
            }
        }
        return list;
    }

    public Question getQuestionById(int id) throws SQLException {
        String sql = "SELECT * FROM Question WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Question q = new Question(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getInt("image_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("question_type")
                    );
                    try {
                        q.setAIGenerated(rs.getBoolean("is_ai_generated"));
                    } catch (SQLException e) {
                        q.setAIGenerated(false);
                    }
                    try {
                        q.setDifficulty(rs.getString("difficulty"));
                        q.setCategory(rs.getString("category"));
                    } catch (SQLException e) {
                        q.setDifficulty("medium");
                        q.setCategory("conceptual");
                    }
                    return q;
                }
            }
        }
        return null;
    }

    public void insert(Question question) throws SQLException {
        String sql = "INSERT INTO question (question, image_id, lesson_id, question_type, is_ai_generated, difficulty, category) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, question.getQuestion());
            if (question.getImage_id() == 0) {
                stmt.setNull(2, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(2, question.getImage_id());
            }
            stmt.setInt(3, question.getLesson_id());
            stmt.setString(4, question.getQuestion_type());
            stmt.setBoolean(5, question.isAIGenerated());
            stmt.setString(6, question.getDifficulty() != null ? question.getDifficulty() : "medium");
            stmt.setString(7, question.getCategory() != null ? question.getCategory() : "conceptual");
            stmt.executeUpdate();
        }
    }

    public void update(Question question) throws SQLException {
        String sql = "UPDATE Question SET question = ?, image_id = ?, lesson_id = ?, question_type = ?, is_ai_generated = ?, difficulty = ?, category = ? WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, question.getQuestion());
            if (question.getImage_id() == 0) {
                stmt.setNull(2, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(2, question.getImage_id());
            }
            stmt.setInt(3, question.getLesson_id());
            stmt.setString(4, question.getQuestion_type());
            stmt.setBoolean(5, question.isAIGenerated());
            stmt.setString(6, question.getDifficulty() != null ? question.getDifficulty() : "medium");
            stmt.setString(7, question.getCategory() != null ? question.getCategory() : "conceptual");
            stmt.setInt(8, question.getId());
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Question WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Question> findByQuestion(String keyword) throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE question LIKE ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getInt("image_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("question_type")
                    );
                    list.add(q);
                }
            }
        }
        return list;
    }

    // Lấy câu hỏi theo test
    public List<Question> getQuestionsByTest(int testId) throws SQLException {
        System.out.println("\n----- GETTING QUESTIONS FOR TEST " + testId + " -----");
        List<Question> list = new ArrayList<>();

        // Đầu tiên kiểm tra test có tồn tại không
        String checkTestSql = "SELECT id, name, is_practice FROM test WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(checkTestSql)) {
            stmt.setInt(1, testId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("Found test: ID=" + rs.getInt("id")
                            + ", Name='" + rs.getString("name")
                            + "', is_practice=" + rs.getBoolean("is_practice"));
                } else {
                    System.out.println("WARNING: Test ID " + testId + " not found!");
                }
            }
        }

        String sql = """
            SELECT q.* FROM question q
            JOIN test_question tq ON q.id = tq.question_id
            WHERE tq.test_id = ?
        """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, testId);
            System.out.println("Executing SQL: " + sql.replace("\n", " ") + " with test_id=" + testId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getInt("image_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("question_type")
                    );
                    list.add(q);
                    System.out.println("Found question: ID=" + q.getId()
                            + ", Lesson ID=" + q.getLesson_id()
                            + ", Question='" + q.getQuestion().substring(0, Math.min(30, q.getQuestion().length())) + "...'");
                }
            }
        }

        // Kiểm tra số lượng câu hỏi tìm thấy
        System.out.println("Total questions found for test " + testId + ": " + list.size());

        // Nếu không tìm thấy câu hỏi nào, kiểm tra xem bảng test_question có dữ liệu không
        if (list.isEmpty()) {
            String checkSql = "SELECT COUNT(*) as count FROM test_question WHERE test_id = ?";
            try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(checkSql)) {
                stmt.setInt(1, testId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt("count");
                        System.out.println("Test_question table has " + count + " entries for test " + testId);

                        if (count == 0) {
                            // Nếu không có question nào được gán cho test này, thử lấy tất cả câu hỏi từ lesson_id
                            String testLessonSql = "SELECT lesson_id FROM test WHERE id = ?";
                            try (PreparedStatement lessonStmt = conn.prepareStatement(testLessonSql)) {
                                lessonStmt.setInt(1, testId);
                                try (ResultSet lessonRs = lessonStmt.executeQuery()) {
                                    if (lessonRs.next()) {
                                        int lessonId = lessonRs.getInt("lesson_id");
                                        if (lessonId > 0) {
                                            System.out.println("Test is linked to lesson ID: " + lessonId + ". Getting questions from that lesson.");
                                            List<Question> lessonQuestions = getQuestionsByLesson(lessonId);
                                            return lessonQuestions;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        System.out.println("----- FINISHED GETTING QUESTIONS -----\n");
        return list;
    }

    // Lấy tất cả câu hỏi của một lesson
    public List<Question> getQuestionsByLesson(int lessonId) throws SQLException {
        System.out.println("\n----- GETTING QUESTIONS FOR LESSON " + lessonId + " -----");
        List<Question> list = new ArrayList<>();

        // Kiểm tra lesson có tồn tại không
        String checkLessonSql = "SELECT id, title FROM lesson WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(checkLessonSql)) {
            stmt.setInt(1, lessonId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("Found lesson: ID=" + rs.getInt("id")
                            + ", Title='" + rs.getString("title") + "'");
                } else {
                    System.out.println("WARNING: Lesson ID " + lessonId + " not found!");
                }
            }
        }

        String sql = "SELECT * FROM question WHERE lesson_id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, lessonId);
            System.out.println("Executing SQL: " + sql + " with lesson_id=" + lessonId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getInt("image_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("question_type")
                    );
                    list.add(q);
                    System.out.println("Found question: ID=" + q.getId()
                            + ", Question='" + q.getQuestion().substring(0, Math.min(30, q.getQuestion().length())) + "...'");
                }
            }
        }

        System.out.println("Total questions found for lesson " + lessonId + ": " + list.size());
        System.out.println("----- FINISHED GETTING QUESTIONS -----\n");
        return list;
    }

    // Lấy câu hỏi ngẫu nhiên theo category
    public List<Question> getRandomQuestionsByCategory(int categoryId, int numQuestions) throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT q.* FROM question q
            JOIN lesson l ON q.lesson_id = l.id
            JOIN chapter ch ON l.chapter_id = ch.id
            JOIN subject s ON ch.subject_id = s.id
            JOIN test t ON t.category_id = ?
            ORDER BY RAND()
            LIMIT ?
        """;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            stmt.setInt(2, numQuestions);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getInt("image_id"),
                            rs.getInt("lesson_id"),
                            rs.getString("question_type")
                    );
                    list.add(q);
                }
            }
        }
        return list;
    }
}
