/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import config.PasswordUtil;
import model.Student;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author BuiNgocLinh
 */
public class StudentDAO extends DBContext {

    private final PasswordUtil passwordEncode = new PasswordUtil();

    public List<Student> searchByKeyword(String keyword) throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE full_name LIKE ? OR username LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String likePattern = "%" + keyword + "%";
            stmt.setString(1, likePattern);
            stmt.setString(2, likePattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Student s = new Student();
                    s.setId(rs.getInt("id"));
                    s.setGrade_id(rs.getInt("grade_id"));
                    s.setParent_id(rs.getInt("parent_id"));
                    s.setUsername(rs.getString("username"));
                    s.setPassword(rs.getString("password"));
                    s.setFull_name(rs.getString("full_name"));
                    s.setDob(rs.getDate("dob").toLocalDate());
                    s.setSex(rs.getBoolean("sex"));
                    s.setImage_id(rs.getInt("image_id"));
                    list.add(s);
                }
            }
        }
        return list;
    }

    public List<Student> findAll() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Student s = new Student(
                        rs.getInt("id"),
                        rs.getInt("grade_id"),
                        rs.getInt("parent_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getDate("dob").toLocalDate(),
                        rs.getBoolean("sex"),
                        rs.getInt("image_id")
                );
                list.add(s);
            }
        }
        return list;
    }

    public void insert(Student student) throws SQLException {
        String sql = "INSERT INTO student (grade_id, parent_id, username, password, full_name, dob, sex, image_id)\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, student.getGrade_id());
            stmt.setInt(2, student.getParent_id());
            stmt.setString(3, student.getUsername());
            stmt.setString(4, passwordEncode.hashPassword(student.getPassword()));
            stmt.setString(5, student.getFull_name());
            stmt.setDate(6, java.sql.Date.valueOf(student.getDob()));
            stmt.setBoolean(7, student.isSex());
            if (student.getImage_id() == 0) {
                stmt.setNull(8, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(8, student.getImage_id());
            }
            stmt.executeUpdate();
        }
    }

    public void update(Student student) throws SQLException {
        String sql = "UPDATE Student SET grade_id = ?, parent_id = ?, username = ?, password = ?, full_name = ?, dob = ?, sex = ?, image_id = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, student.getGrade_id());
            stmt.setInt(2, student.getParent_id());
            stmt.setString(3, student.getUsername());
            stmt.setString(4, passwordEncode.hashPassword(student.getPassword()));
            stmt.setString(5, student.getFull_name());
            stmt.setDate(6, java.sql.Date.valueOf(student.getDob()));
            stmt.setBoolean(7, student.isSex());
            if (student.getImage_id() == 0) {
                stmt.setNull(8, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(8, student.getImage_id());
            }
            stmt.setInt(9, student.getId());

            stmt.executeUpdate();
        }
    }

    /**
     * Validates if the provided password matches the stored password for a
     * student
     *
     * @param student The student object containing the stored password
     * @param providedPassword The password to validate
     * @return true if the password matches, false otherwise
     */
    public boolean validatePassword(Student student, String providedPassword) {
        String storedPassword = student.getPassword();
        return passwordEncode.checkPassword(providedPassword, storedPassword);
    }

    public void delete(int id) throws SQLException {
        String deleteQuesRecordSql = "DELETE FROM question_record WHERE test_record_id IN (SELECT id FROM test_record WHERE student_id = ?)";
        String deleteTestRecordSql = "DELETE FROM test_record WHERE student_id = ?";
        String deleteStudentSql = "DELETE FROM student WHERE id = ?";

        try (
                PreparedStatement stmt1 = connection.prepareStatement(deleteQuesRecordSql); PreparedStatement stmt2 = connection.prepareStatement(deleteTestRecordSql); PreparedStatement stmt3 = connection.prepareStatement(deleteStudentSql)) {
            connection.setAutoCommit(false);

            // 1. Xóa các bản ghi question_record liên quan
            stmt1.setInt(1, id);
            stmt1.executeUpdate();

            // 2. Xóa test_record của học sinh
            stmt2.setInt(1, id);
            stmt2.executeUpdate();

            // 3. Xóa học sinh
            stmt3.setInt(1, id);
            stmt3.executeUpdate();

            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public Student findById(int id) throws SQLException {
        String sql = "SELECT * FROM student WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Student(
                            rs.getInt("id"),
                            rs.getInt("grade_id"),
                            rs.getInt("parent_id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("full_name"),
                            rs.getDate("dob").toLocalDate(),
                            rs.getBoolean("sex"),
                            rs.getInt("image_id")
                    );
                }
            }
        }
        return null;
    }

    public List<Student> getStudentsByPage(int offset, int limit) throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student LIMIT ?, ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student(
                        rs.getInt("id"),
                        rs.getInt("grade_id"),
                        rs.getInt("parent_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getDate("dob").toLocalDate(),
                        rs.getBoolean("sex"),
                        rs.getInt("image_id")
                );
                list.add(s);
            }
        }
        return list;
    }

    public int countStudents() throws SQLException {
        String sql = "SELECT COUNT(*) FROM student";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public Student checkLogin(String username, String password) {
        Student student = null;
        String sql = "SELECT * FROM student WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    String passwordHash = rs.getString("password");
                    if (passwordEncode.checkPassword(password, passwordHash)) {
                        int grade_id = rs.getInt("grade_id");
                        int parent_id = rs.getInt("parent_id");
                        String fullName = rs.getString("full_name");
                        LocalDate dob = rs.getDate("dob").toLocalDate();
                        boolean sex = rs.getBoolean("sex");
                        int image_id = rs.getInt("image_id");
                        student = new Student(id, grade_id, parent_id, username, password, fullName, dob, sex, image_id);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return student;
    }

    public List<Student> getStudentsByParentId(int parentId) throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE parent_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, parentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Student s = new Student(
                            rs.getInt("id"),
                            rs.getInt("grade_id"),
                            rs.getInt("parent_id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("full_name"),
                            rs.getDate("dob").toLocalDate(),
                            rs.getBoolean("sex"),
                            rs.getInt("image_id")
                    );
                    list.add(s);
                }
            }
        }
        return list;
    }

    public static void main(String[] args) {
        StudentDAO dao = new StudentDAO();

        try {
            dao.delete(3);
            System.out.println("Xóa thành công!");
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
