package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Lesson;

public class LessonDAO extends DBContext {

    public List<Lesson> getAllLessons() {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lesson";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Lesson lesson = new Lesson(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("content"),
                        rs.getInt("chapter_id"),
                        rs.getString("video_link")
                );
                list.add(lesson);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Lesson getLessonById(int id) {
        String sql = "SELECT * FROM lesson WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Lesson(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("content"),
                            rs.getInt("chapter_id"),
                            rs.getString("video_link")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addLesson(Lesson lesson) {
        String sql = "INSERT INTO lesson(name, content, chapter_id, video_link) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, lesson.getName());
            ps.setString(2, lesson.getContent());
            ps.setInt(3, lesson.getChapter_id());
            ps.setString(4, lesson.getVideo_link());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateLesson(Lesson lesson) {
        String sql = "UPDATE lesson SET name = ?, content = ?, chapter_id = ?, video_link = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, lesson.getName());
            ps.setString(2, lesson.getContent());
            ps.setInt(3, lesson.getChapter_id());
            ps.setString(4, lesson.getVideo_link());
            ps.setInt(5, lesson.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteLesson(int id) {
        String sql = "DELETE FROM lesson WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Lesson> searchByName(String name) {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM lesson WHERE name LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("content"),
                            rs.getInt("chapter_id"),
                            rs.getString("video_link")
                    );
                    list.add(lesson);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
