/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Chapter;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Na
 */
public class ChapterDAO extends DBContext {

    //hien thi all chapter
    public List<Chapter> getChapter(String sql) {
        List<Chapter> list = new ArrayList<>();

        try {
            Statement state = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                int subject_id = rs.getInt("subject_id");
                Chapter chapter = new Chapter(id, name, description, subject_id);
                list.add(chapter);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    //add them new chapter
    public int addChapter(Chapter chapter) {
        int n = 0;
        String sql = "INSERT INTO chapter (id, name, description, subject_id)\n"
                + "     VALUES\n"
                + "(?, ?, ?, ?)";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, chapter.getId());
            pre.setString(2, chapter.getName());
            pre.setString(3, chapter.getDescription());
            pre.setInt(4, chapter.getSubject_id());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    //edit chapter
    public int editChapter(Chapter chapter) {
        int n = 0;
        String sql = """
                     UPDATE chapter
                        SET name = ?
                           ,description = ?
                           ,subject_id = ?
                     WHERE id = ?
                     """;

        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, chapter.getName());
            pre.setString(2, chapter.getDescription());
            pre.setInt(3, chapter.getSubject_id());
            pre.setInt(4, chapter.getId());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    //delete chapter theo id
    public int deleteChapter(int id) {
        int n = 0;
        String sql = "DELETE FROM chapter WHERE id = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, id);
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    //tim chapter theo id
    public Chapter findChapterById(int id) {
        String sql = "SELECT * FROM chapter WHERE id = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                return new Chapter(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("subject_id")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    //tim Chapter theo name
    public List<Chapter> findChapterByName(String name) {
        List<Chapter> list = new ArrayList<>();
        String sql = "SELECT * FROM CHAPTER WHERE name LIKE ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, "%" + name + "%");
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Chapter chapter = new Chapter(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("subject_id")
                );
                list.add(chapter);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    //tim chapter theo subject_id
    public List<Chapter> findChapterBySubjectId(int subject_id) {
        List<Chapter> list = new ArrayList<>();
        String sql = "SELECT * FROM CHAPTER WHERE subject_id = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, subject_id);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                Chapter chapter = new Chapter(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("subject_id")
                );
                list.add(chapter);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Chapter getChapterById(int id) throws Exception {
        String sql = "SELECT * FROM chapter WHERE id = ?";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                return new Chapter(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("subject_id")
                );
            }
        } catch (SQLException ex) {
            throw new Exception("Error getting chapter by ID: " + ex.getMessage());
        }
        return null;
    }

    public List<Chapter> findChaptersWithPagination(String name, Integer subjectId, int page, int pageSize) {
        List<Chapter> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM chapter WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + name.trim() + "%");
        }

        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        sql.append(" ORDER BY name LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Chapter chapter = new Chapter(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getInt("subject_id")
                    );
                    list.add(chapter);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public int getTotalChaptersCount(String name, Integer subjectId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM chapter WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + name.trim() + "%");
        }

        if (subjectId != null) {
            sql.append(" AND subject_id = ?");
            params.add(subjectId);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

//    public static void main(String[] args) {
//        ChapterDAO daoC = new ChapterDAO();
//        List<Chapter> list = daoC.getChapter("select * from chapter");
//        int n = daoC.addChapter(new Chapter(3, ":Rơi tự do", "Giới thiệu về rơi tự do",1));
//        for (Chapter chapter : list) {
//            System.out.println(chapter);
//        }
//    }
}
