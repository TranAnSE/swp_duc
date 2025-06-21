package dal;

import model.QuestionRecord;
import java.sql.*;
import java.util.*;

public class QuestionRecordDAO extends DBContext {
    private Connection conn;

    public QuestionRecordDAO() {
        try {
            this.conn = getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Debug logger ghi vào file
    private void debugLog(String message) {
        try {
            String filePath = System.getProperty("user.dir") + "/debug_score.log";
            java.io.FileWriter fw = new java.io.FileWriter(filePath, true);
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            fw.write("[" + now + "] " + message + "\n");
            fw.close();
            System.out.println("DEBUG_LOG_FILE: " + filePath + " - " + message); // Console output với path
            System.err.println("DEBUG_ERROR: " + message); // Error stream
        } catch (Exception e) {
            System.err.println("Error writing debug log to " + System.getProperty("user.dir") + "/debug_score.log: " + e.getMessage());
        }
    }

    // Lưu câu trả lời của học sinh
    public void saveQuestionRecord(int testRecordId, int questionId, int optionId) {
        System.out.println("\n===== SAVE QUESTION RECORD START =====");
        System.out.println("RECEIVED PARAMS: testRecordId=" + testRecordId + 
                         ", questionId=" + questionId + ", optionId=" + optionId);
        
        // Kiểm tra các tham số đầu vào
        if (optionId <= 0) {
            System.out.println("ERROR: Invalid optionId " + optionId);
            return;
        }
        
        // Kiểm tra option có tồn tại không
        try {
            String validateOption = "SELECT id FROM question_option WHERE id = ? AND question_id = ?";
            PreparedStatement validatePs = conn.prepareStatement(validateOption);
            validatePs.setInt(1, optionId);
            validatePs.setInt(2, questionId);
            ResultSet validateRs = validatePs.executeQuery();
            if (!validateRs.next()) {
                System.out.println("ERROR: Option ID " + optionId + " does not exist for question " + questionId);
                validateRs.close();
                validatePs.close();
                return;
            }
            validateRs.close();
            validatePs.close();
        } catch (SQLException e) {
            System.out.println("Error validating option: " + e.getMessage());
            return;
        }
        
        // Kiểm tra xem đã trả lời câu hỏi này chưa
        String checkSql = "SELECT id, option_id FROM question_record WHERE test_record_id = ? AND question_id = ?";
        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, testRecordId);
            checkPs.setInt(2, questionId);
            System.out.println("Executing query: " + checkSql + " with params [" + testRecordId + "," + questionId + "]");
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Đã có câu trả lời, update
                int recordId = rs.getInt("id");
                int oldOptionId = rs.getInt("option_id");
                System.out.println("Found existing record ID=" + recordId + " with optionId=" + oldOptionId);
                System.out.println("Will update to new optionId=" + optionId);
                updateQuestionRecord(recordId, optionId);
            } else {
                // Chưa có câu trả lời, insert mới
                System.out.println("No existing record found. Will insert new record with optionId=" + optionId);
                insertQuestionRecord(testRecordId, questionId, optionId);
            }
            
            // Verify the save worked
            verifyQuestionRecordSaved(testRecordId, questionId, optionId);
            System.out.println("===== SAVE QUESTION RECORD END =====\n");
        } catch (SQLException e) {
            System.out.println("SQL Error in saveQuestionRecord: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void insertQuestionRecord(int testRecordId, int questionId, int optionId) {
        System.out.println("\n----- INSERT QUESTION RECORD -----");
        System.out.println("PARAMS: testRecordId=" + testRecordId + ", questionId=" + questionId + ", optionId=" + optionId);
        // KIỂM TRA THAM SỐ trước khi insert
        if (testRecordId <= 0 || questionId <= 0 || optionId <= 0) {
            System.out.println("ERROR: Invalid parameters for insert! Skipping insert.");
            return;
        }
        String sql = "INSERT INTO question_record (test_record_id, question_id, option_id) VALUES (?, ?, ?)";
        try {
            Connection freshConn = new DBContext().getConnection();
            PreparedStatement ps = freshConn.prepareStatement(sql);
            ps.setInt(1, testRecordId);
            ps.setInt(2, questionId);
            ps.setInt(3, optionId);
            System.out.println("Executing SQL: " + sql + " with values [" + testRecordId + ", " + questionId + ", " + optionId + "]");
            int inserted = ps.executeUpdate();
            System.out.println("INSERT RESULT: " + (inserted > 0 ? "SUCCESS" : "FAILED") + " - Rows affected: " + inserted);
            ps.close();
            freshConn.close();
            verifyInsert(testRecordId, questionId, optionId);
        } catch (SQLException e) {
            System.out.println("SQL ERROR in insertQuestionRecord: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("GENERAL ERROR in insertQuestionRecord: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("----- INSERT COMPLETED -----\n");
    }

    private void updateQuestionRecord(int recordId, int optionId) {
        System.out.println("\n----- UPDATE QUESTION RECORD -----");
        System.out.println("PARAMS: recordId=" + recordId + ", new optionId=" + optionId);
        
        // KIỂM TRA THAM SỐ trước khi update
        if (recordId <= 0 || optionId <= 0) {
            System.out.println("ERROR: Invalid parameters for update! Skipping update.");
            return;
        }
        
        String sql = "UPDATE question_record SET option_id = ? WHERE id = ?";
        try {
            // Tạo PreparedStatement với kết nối mới để tránh vấn đề với connection
            Connection freshConn = new DBContext().getConnection();
            PreparedStatement ps = freshConn.prepareStatement(sql);
            
            ps.setInt(1, optionId); // Đảm bảo đúng optionId được đặt vào
            ps.setInt(2, recordId);
            
            // Log SQL query trước khi thực hiện
            System.out.println("Executing SQL: " + sql + " with values [" + optionId + ", " + recordId + "]");
            
            int updated = ps.executeUpdate();
            System.out.println("UPDATE RESULT: " + (updated > 0 ? "SUCCESS" : "FAILED") + " - Rows affected: " + updated);
            
            // Close resources
            ps.close();
            freshConn.close();
            
            // Kiểm tra lại sau khi update
            if (updated > 0) {
                String verifySql = "SELECT option_id FROM question_record WHERE id = ?";
                try {
                    PreparedStatement verifyPs = conn.prepareStatement(verifySql);
                    verifyPs.setInt(1, recordId);
                    ResultSet rs = verifyPs.executeQuery();
                    if (rs.next()) {
                        int savedOptionId = rs.getInt("option_id");
                        System.out.println("VERIFICATION: Record " + recordId + " now has optionId=" + savedOptionId + 
                                         (savedOptionId == optionId ? " (CORRECT)" : " (ERROR - expected " + optionId + ")"));
                    }
                    rs.close();
                    verifyPs.close();
                } catch (Exception e) {
                    System.out.println("Error verifying update: " + e.getMessage());
                }
            }
            
        } catch (SQLException e) {
            System.out.println("SQL ERROR in updateQuestionRecord: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("GENERAL ERROR in updateQuestionRecord: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("----- UPDATE COMPLETED -----\n");
    }
    
    // Phương thức kiểm tra sau khi insert
    private void verifyInsert(int testRecordId, int questionId, int expectedOptionId) {
        try {
            String verifySql = "SELECT id, option_id FROM question_record WHERE test_record_id = ? AND question_id = ?";
            PreparedStatement ps = conn.prepareStatement(verifySql);
            ps.setInt(1, testRecordId);
            ps.setInt(2, questionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int recordId = rs.getInt("id");
                int actualOptionId = rs.getInt("option_id");
                System.out.println("VERIFICATION: Found record ID=" + recordId + 
                                 ", optionId=" + actualOptionId + 
                                 (actualOptionId == expectedOptionId ? " (CORRECT)" : " (ERROR - expected " + expectedOptionId + ")"));
            } else {
                System.out.println("VERIFICATION FAILED: No record found after insert!");
            }
            
            rs.close();
            ps.close();
        } catch (Exception e) {
            System.out.println("Error verifying insert: " + e.getMessage());
        }
    }

    private void verifyQuestionRecordSaved(int testRecordId, int questionId, int expectedOptionId) {
        String sql = "SELECT option_id FROM question_record WHERE test_record_id = ? AND question_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testRecordId);
            ps.setInt(2, questionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int actualOptionId = rs.getInt("option_id");
                if (actualOptionId == expectedOptionId) {
                    debugLog("verify: ✓ Successfully saved optionId=" + actualOptionId + " for question " + questionId);
                } else {
                    debugLog("verify: ✗ ERROR: Expected optionId=" + expectedOptionId + " but found " + actualOptionId);
                }
            } else {
                debugLog("verify: ✗ ERROR: No record found after save for question " + questionId);
            }
        } catch (SQLException e) {
            debugLog("verify: Error verifying save: " + e.getMessage());
        }
    }

    // Lấy tất cả câu trả lời của một test record
    public List<QuestionRecord> getQuestionRecordsByTestRecord(int testRecordId) {
        List<QuestionRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM question_record WHERE test_record_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testRecordId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionRecord record = new QuestionRecord();
                record.setId(rs.getInt("id"));
                record.setTest_record_id(rs.getInt("test_record_id"));
                record.setQuestion_id(rs.getInt("question_id"));
                record.setOption_id(rs.getInt("option_id"));
                records.add(record);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return records;
    }

    // Lấy câu trả lời của học sinh cho một câu hỏi cụ thể
    public QuestionRecord getQuestionRecord(int testRecordId, int questionId) {
        String sql = "SELECT * FROM question_record WHERE test_record_id = ? AND question_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testRecordId);
            ps.setInt(2, questionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                QuestionRecord record = new QuestionRecord();
                record.setId(rs.getInt("id"));
                record.setTest_record_id(rs.getInt("test_record_id"));
                record.setQuestion_id(rs.getInt("question_id"));
                record.setOption_id(rs.getInt("option_id"));
                return record;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tính điểm cho test record
    public double calculateScore(int testRecordId) {
        System.out.println("=== CALCULATING SCORE FOR TEST " + testRecordId + " ===");
        try {
            // Lấy tất cả các câu hỏi trong test record
            String getQuestionsSql = "SELECT DISTINCT question_id FROM question_record WHERE test_record_id = ?";
            PreparedStatement psQ = conn.prepareStatement(getQuestionsSql);
            psQ.setInt(1, testRecordId);
            ResultSet rsQ = psQ.executeQuery();
            int totalQuestions = 0;
            int correctQuestions = 0;
            while (rsQ.next()) {
                int questionId = rsQ.getInt("question_id");
                totalQuestions++;
                // Lấy loại câu hỏi
                String typeSql = "SELECT question_type FROM question WHERE id = ?";
                PreparedStatement psType = conn.prepareStatement(typeSql);
                psType.setInt(1, questionId);
                ResultSet rsType = psType.executeQuery();
                String questionType = "SINGLE";
                if (rsType.next()) {
                    questionType = rsType.getString("question_type");
                }
                rsType.close();
                psType.close();
                // Lấy đáp án đúng
                List<Integer> correctOptionIds = new ArrayList<>();
                String correctSql = "SELECT id FROM question_option WHERE question_id = ? AND is_correct = 1";
                PreparedStatement psC = conn.prepareStatement(correctSql);
                psC.setInt(1, questionId);
                ResultSet rsC = psC.executeQuery();
                while (rsC.next()) {
                    correctOptionIds.add(rsC.getInt("id"));
                }
                rsC.close();
                psC.close();
                // Lấy đáp án học sinh chọn
                List<Integer> studentOptionIds = new ArrayList<>();
                String studentSql = "SELECT option_id FROM question_record WHERE test_record_id = ? AND question_id = ?";
                PreparedStatement psS = conn.prepareStatement(studentSql);
                psS.setInt(1, testRecordId);
                psS.setInt(2, questionId);
                ResultSet rsS = psS.executeQuery();
                while (rsS.next()) {
                    studentOptionIds.add(rsS.getInt("option_id"));
                }
                rsS.close();
                psS.close();
                // So sánh
                boolean isCorrect = false;
                if ("SINGLE".equals(questionType)) {
                    isCorrect = studentOptionIds.size() == 1 && correctOptionIds.size() == 1 && studentOptionIds.get(0).equals(correctOptionIds.get(0));
                } else {
                    Collections.sort(correctOptionIds);
                    Collections.sort(studentOptionIds);
                    isCorrect = correctOptionIds.equals(studentOptionIds);
                }
                if (isCorrect) correctQuestions++;
            }
            rsQ.close();
            psQ.close();
            if (totalQuestions == 0) return 0.0;
            double score = (double) correctQuestions / totalQuestions * 10.0;
            System.out.println("Final score: " + score);
            return score;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error calculating score: " + e.getMessage());
            return 0.0;
        }
    }

    // Xóa tất cả question records của một test record
    public void deleteQuestionRecordsByTestRecord(int testRecordId) {
        String sql = "DELETE FROM question_record WHERE test_record_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testRecordId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Debug method: Kiểm tra chi tiết các câu trả lời và options
    public void debugTestRecord(int testRecordId) {
        debugLog("=== DEBUG TEST RECORD " + testRecordId + " ===");
        
        // Lấy tất cả question records
        String sql1 = "SELECT * FROM question_record WHERE test_record_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql1)) {
            ps.setInt(1, testRecordId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int questionId = rs.getInt("question_id");
                int optionId = rs.getInt("option_id");
                debugLog("Question " + questionId + " -> Option " + optionId);
                
                // Kiểm tra option này có đúng không
                String sql2 = "SELECT is_correct FROM question_option WHERE id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                    ps2.setInt(1, optionId);
                    ResultSet rs2 = ps2.executeQuery();
                    if (rs2.next()) {
                        boolean isCorrect = rs2.getBoolean("is_correct");
                        int rawValue = rs2.getInt("is_correct"); // Get raw value to debug
                        debugLog("  -> Option " + optionId + " is_correct = " + isCorrect + " (raw value: " + rawValue + ")");
                    } else {
                        debugLog("  -> Option " + optionId + " NOT FOUND!");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        debugLog("=== END DEBUG ===");
    }
    
    // Method để tạo dữ liệu test nếu không có
    public void initializeTestDataIfNeeded() {
        try {
            // Kiểm tra xem có option nào được đánh dấu là correct không
            String checkSql = "SELECT COUNT(*) as count FROM question_option WHERE is_correct = 1 OR is_correct = true";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int correctOptionsCount = rs.getInt("count");
                    debugLog("Found " + correctOptionsCount + " correct options in database");
                    
                    if (correctOptionsCount == 0) {
                        debugLog("No correct options found. Creating test data...");
                        createTestData();
                    }
                }
            }
        } catch (SQLException e) {
            debugLog("Error checking test data: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void createTestData() {
        // Method 1: Đánh dấu option đầu tiên của mỗi question là đúng
        String sql1 = """
            UPDATE question_option qo1 
            SET is_correct = 1 
            WHERE qo1.id = (
                SELECT MIN(qo2.id) 
                FROM (SELECT * FROM question_option) qo2 
                WHERE qo2.question_id = qo1.question_id
            )
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(sql1)) {
            int updated = ps.executeUpdate();
            debugLog("Method 1: Updated " + updated + " options to be correct (first option of each question)");
        } catch (SQLException e1) {
            debugLog("Method 1 failed, trying Method 2: " + e1.getMessage());
            
            // Method 2: Simpler approach  
            try {
                String sql2 = "UPDATE question_option SET is_correct = 1 WHERE id IN (SELECT MIN(id) FROM question_option GROUP BY question_id)";
                try (PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                    int updated2 = ps2.executeUpdate();
                    debugLog("Method 2: Updated " + updated2 + " options to be correct");
                }
            } catch (SQLException e2) {
                debugLog("Method 2 also failed, trying Method 3: " + e2.getMessage());
                
                // Method 3: Manual approach
                try {
                    String getQuestions = "SELECT DISTINCT question_id FROM question_option";
                    try (PreparedStatement ps3 = conn.prepareStatement(getQuestions)) {
                        ResultSet rs = ps3.executeQuery();
                        int totalUpdated = 0;
                        while (rs.next()) {
                            int questionId = rs.getInt("question_id");
                            String updateSql = "UPDATE question_option SET is_correct = 1 WHERE question_id = ? AND id = (SELECT MIN(id) FROM (SELECT id FROM question_option WHERE question_id = ?) sub)";
                            try (PreparedStatement ps4 = conn.prepareStatement(updateSql)) {
                                ps4.setInt(1, questionId);
                                ps4.setInt(2, questionId);
                                totalUpdated += ps4.executeUpdate();
                            }
                        }
                        debugLog("Method 3: Updated " + totalUpdated + " options to be correct");
                    }
                } catch (SQLException e3) {
                    debugLog("All methods failed: " + e3.getMessage());
                }
            }
        }
    }
    
         // Simple manual scoring for debug
     public double calculateScoreSimple(int testRecordId) {
         debugLog("=== SIMPLE SCORE CALCULATION ===");
         try {
             String sql = "SELECT COUNT(*) as total FROM question_record WHERE test_record_id = ?";
             try (PreparedStatement ps = conn.prepareStatement(sql)) {
                 ps.setInt(1, testRecordId);
                 ResultSet rs = ps.executeQuery();
                 if (rs.next()) {
                     int total = rs.getInt("total");
                     debugLog("Total answers: " + total);
                     
                     if (total > 0) {
                         // For test: assume all answers are correct
                         double score = 10.0; // Full score for testing
                         debugLog("Returning test score: " + score);
                         return score;
                     }
                 }
             }
         } catch (SQLException e) {
             debugLog("Simple score calculation error: " + e.getMessage());
         }
         return 0.0;
     }
     
     // Test MySQL bit(1) directly
     public void testMySQLBitType() {
         System.err.println("=== TESTING MYSQL BIT(1) TYPE ===");
         try {
             String sql = "SELECT id, question_id, content, is_correct, CAST(is_correct AS UNSIGNED) as is_correct_int FROM question_option LIMIT 5";
             try (PreparedStatement ps = conn.prepareStatement(sql)) {
                 ResultSet rs = ps.executeQuery();
                 while (rs.next()) {
                     int id = rs.getInt("id");
                     int questionId = rs.getInt("question_id");
                     String content = rs.getString("content");
                     boolean isCorrectBool = rs.getBoolean("is_correct");
                     int isCorrectInt = rs.getInt("is_correct_int");
                     
                     System.err.println("Option " + id + " (Q" + questionId + "): '" + content + 
                                      "' -> boolean=" + isCorrectBool + ", int=" + isCorrectInt);
                 }
             }
         } catch (SQLException e) {
             System.err.println("Error testing MySQL bit type: " + e.getMessage());
         }
         System.err.println("=== END MYSQL BIT TEST ===");
    }

    public void deleteQuestionRecordsByTestRecordAndQuestion(int testRecordId, int questionId) {
        String sql = "DELETE FROM question_record WHERE test_record_id = ? AND question_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testRecordId);
            ps.setInt(2, questionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteByQuestionId(int questionId) throws SQLException {
        String sql = "DELETE FROM question_record WHERE question_id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            stmt.executeUpdate();
        }
    }
} 