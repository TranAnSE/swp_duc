/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.TestRecord;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;
/**
 *
 * @author Na
 */
public class TestRecordDAO extends DBContext {
    private Connection conn;

    public TestRecordDAO() {
        try {
            this.conn = getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Tạo test record mới khi học sinh bắt đầu làm bài
    public int createTestRecord(int studentId, int testId) {
        String sql = "INSERT INTO test_record (student_id, test_id, started_at) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, studentId);
            ps.setInt(2, testId);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Cập nhật thời gian bắt đầu của test record
    public boolean updateStartTime(int testRecordId, Timestamp startTime) {
        String sql = "UPDATE test_record SET started_at = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, startTime);
            ps.setInt(2, testRecordId);
            int rowsAffected = ps.executeUpdate();
            
            System.out.println("Updated start time for test record ID " + testRecordId + ": " + startTime);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating start time: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Hoàn thành test và tính điểm
    public void finishTestRecord(int testRecordId, double score) {
        System.out.println("\n** SAVING TEST RECORD: ID=" + testRecordId + ", SCORE=" + score + " **\n");
        
        // Method 1: Standard JDBC update
        String sql = "UPDATE test_record SET finish_at = ?, score = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setDouble(2, score);
            ps.setInt(3, testRecordId);
            int updated = ps.executeUpdate();
            
            System.out.println("Method 1: Updated " + updated + " rows");
            
            // Verify save was successful
            String verifySql = "SELECT score FROM test_record WHERE id = ?";
            try (PreparedStatement psVerify = conn.prepareStatement(verifySql)) {
                psVerify.setInt(1, testRecordId);
                ResultSet rs = psVerify.executeQuery();
                if (rs.next()) {
                    double savedScore = rs.getDouble("score");
                    System.out.println("VERIFIED: Score saved in DB = " + savedScore);
                } else {
                    System.out.println("ERROR: Record not found after save!");
                }
            }
        } catch (SQLException e) {
            System.out.println("ERROR in finishTestRecord: " + e.getMessage());
            
            // Method 2: Fallback to direct statement
            try {
                String directSql = "UPDATE test_record SET finish_at = NOW(), score = " + score + " WHERE id = " + testRecordId;
                System.out.println("Trying direct SQL: " + directSql);
                
                try (Statement stmt = conn.createStatement()) {
                    int updated = stmt.executeUpdate(directSql);
                    System.out.println("Method 2: Updated " + updated + " rows with direct SQL");
                }
            } catch (SQLException e2) {
                System.out.println("ERROR in fallback update: " + e2.getMessage());
                e2.printStackTrace();
            }
        }
    }

    // Lấy test record theo ID
    public TestRecord getTestRecordById(int id) {
        String sql = "SELECT * FROM test_record WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TestRecord record = new TestRecord();
                record.setId(rs.getInt("id"));
                record.setStudent_id(rs.getInt("student_id"));
                record.setTest_id(rs.getInt("test_id"));
                
                Timestamp startedAt = rs.getTimestamp("started_at");
                if (startedAt != null) {
                    record.setStarted_at(startedAt.toLocalDateTime());
                }
                
                Timestamp finishAt = rs.getTimestamp("finish_at");
                if (finishAt != null) {
                    record.setFinish_at(finishAt.toLocalDateTime());
                }
                
                double score = rs.getDouble("score");
                record.setScore(score);
                
                // DEBUG: Print retrieved score
                String debugMsg = "GET_TEST_RECORD_DEBUG: id=" + id + ", retrieved score=" + score;
                System.err.println(debugMsg);
                
                // Write to file for debug
                try {
                    java.io.FileWriter fw = new java.io.FileWriter("get_test_record_debug.txt", true);
                    fw.write(java.time.LocalDateTime.now() + ": " + debugMsg + "\n");
                    fw.close();
                } catch (Exception fe) {
                    System.err.println("File write error: " + fe.getMessage());
                }
                
                return record;
            }
        } catch (SQLException e) {
            System.err.println("GET_TEST_RECORD_ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Lấy tất cả test records đã hoàn thành của một học sinh
    public List<TestRecord> getTestRecordsByStudent(int studentId) {
        List<TestRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM test_record WHERE student_id = ? AND finish_at IS NOT NULL ORDER BY started_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TestRecord record = new TestRecord();
                record.setId(rs.getInt("id"));
                record.setStudent_id(rs.getInt("student_id"));
                record.setTest_id(rs.getInt("test_id"));
                
                Timestamp startedAt = rs.getTimestamp("started_at");
                if (startedAt != null) {
                    record.setStarted_at(startedAt.toLocalDateTime());
                }
                
                Timestamp finishAt = rs.getTimestamp("finish_at");
                if (finishAt != null) {
                    record.setFinish_at(finishAt.toLocalDateTime());
                }
                
                record.setScore(rs.getDouble("score"));
                records.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    // Kiểm tra xem học sinh đã làm test này chưa (cho test chính thức)
    public boolean hasStudentTakenTest(int studentId, int testId) {
        String sql = "SELECT COUNT(*) FROM test_record WHERE student_id = ? AND test_id = ? AND finish_at IS NOT NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, testId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy test record đang thực hiện (chưa hoàn thành)
    public TestRecord getActiveTestRecord(int studentId, int testId) {
        String sql = "SELECT * FROM test_record WHERE student_id = ? AND test_id = ? AND finish_at IS NULL";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, testId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TestRecord record = new TestRecord();
                record.setId(rs.getInt("id"));
                record.setStudent_id(rs.getInt("student_id"));
                record.setTest_id(rs.getInt("test_id"));
                
                Timestamp startedAt = rs.getTimestamp("started_at");
                if (startedAt != null) {
                    record.setStarted_at(startedAt.toLocalDateTime());
                }
                
                record.setScore(rs.getDouble("score"));
                return record;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
} 
