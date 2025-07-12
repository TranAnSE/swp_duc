/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.StudentLessonProgress;
import model.StudentCourseProgress;
import java.sql.*;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.*;

/**
 *
 * @author ankha
 */
public class StudentProgressDAO extends DBContext {

    // Lesson Progress Methods
    public StudentLessonProgress getLessonProgress(int studentId, int lessonId, int courseId) {
        String sql = "SELECT * FROM student_lesson_progress WHERE student_id = ? AND lesson_id = ? AND course_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, lessonId);
            ps.setInt(3, courseId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapLessonProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateLessonProgress(int studentId, int lessonId, int courseId,
            int watchDuration, int totalDuration, int lastPosition) {
        // Calculate completion percentage
        BigDecimal completionPercentage = BigDecimal.ZERO;
        boolean isCompleted = false;

        if (totalDuration > 0) {
            completionPercentage = new BigDecimal(watchDuration)
                    .divide(new BigDecimal(totalDuration), 4, BigDecimal.ROUND_HALF_UP)
                    .multiply(new BigDecimal(100));

            // Mark as completed if watched at least 30%
            isCompleted = completionPercentage.compareTo(new BigDecimal(30)) >= 0;
        }

        String sql = """
            INSERT INTO student_lesson_progress 
            (student_id, lesson_id, course_id, watch_duration, total_duration, 
             completion_percentage, is_completed, last_position, completed_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
            watch_duration = VALUES(watch_duration),
            total_duration = VALUES(total_duration),
            completion_percentage = VALUES(completion_percentage),
            is_completed = VALUES(is_completed),
            last_position = VALUES(last_position),
            last_watched_at = CURRENT_TIMESTAMP,
            completed_at = CASE WHEN VALUES(is_completed) = 1 AND completed_at IS NULL 
                              THEN CURRENT_TIMESTAMP ELSE completed_at END
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, lessonId);
            ps.setInt(3, courseId);
            ps.setInt(4, watchDuration);
            ps.setInt(5, totalDuration);
            ps.setBigDecimal(6, completionPercentage);
            ps.setBoolean(7, isCompleted);
            ps.setInt(8, lastPosition);
            ps.setTimestamp(9, isCompleted ? Timestamp.valueOf(LocalDateTime.now()) : null);

            int result = ps.executeUpdate();

            // Update course progress if lesson was just completed
            if (result > 0) {
                updateCourseProgress(studentId, courseId);
            }

            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<Integer, StudentLessonProgress> getLessonProgressMap(int studentId, int courseId) {
        Map<Integer, StudentLessonProgress> progressMap = new HashMap<>();
        String sql = "SELECT * FROM student_lesson_progress WHERE student_id = ? AND course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StudentLessonProgress progress = mapLessonProgress(rs);
                progressMap.put(progress.getLessonId(), progress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return progressMap;
    }

    // Course Progress Methods
    public StudentCourseProgress getCourseProgress(int studentId, int courseId) {
        String sql = """
            SELECT scp.*, sps.course_title, sps.teacher_name
            FROM student_course_progress scp
            LEFT JOIN student_progress_summary sps ON scp.student_id = sps.student_id 
                AND scp.course_id = sps.course_id
            WHERE scp.student_id = ? AND scp.course_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCourseProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCourseProgress(int studentId, int courseId) {
        // First, get total lessons in course
        String countSql = """
            SELECT COUNT(DISTINCT cl.lesson_id) as total_lessons
            FROM course_lesson cl
            WHERE cl.course_id = ? AND cl.is_active = 1
        """;

        int totalLessons = 0;
        try (PreparedStatement ps = connection.prepareStatement(countSql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totalLessons = rs.getInt("total_lessons");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Get completed lessons count
        String completedSql = """
            SELECT COUNT(*) as completed_lessons
            FROM student_lesson_progress slp
            WHERE slp.student_id = ? AND slp.course_id = ? AND slp.is_completed = 1
        """;

        int completedLessons = 0;
        try (PreparedStatement ps = connection.prepareStatement(completedSql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                completedLessons = rs.getInt("completed_lessons");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Calculate completion percentage
        BigDecimal completionPercentage = BigDecimal.ZERO;
        if (totalLessons > 0) {
            completionPercentage = new BigDecimal(completedLessons)
                    .divide(new BigDecimal(totalLessons), 4, BigDecimal.ROUND_HALF_UP)
                    .multiply(new BigDecimal(100));
        }

        // Update or insert course progress
        String sql = """
            INSERT INTO student_course_progress 
            (student_id, course_id, total_lessons, completed_lessons, completion_percentage)
            VALUES (?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
            total_lessons = VALUES(total_lessons),
            completed_lessons = VALUES(completed_lessons),
            completion_percentage = VALUES(completion_percentage),
            last_accessed_at = CURRENT_TIMESTAMP
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ps.setInt(3, totalLessons);
            ps.setInt(4, completedLessons);
            ps.setBigDecimal(5, completionPercentage);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper methods
    private StudentLessonProgress mapLessonProgress(ResultSet rs) throws SQLException {
        StudentLessonProgress progress = new StudentLessonProgress();
        progress.setId(rs.getInt("id"));
        progress.setStudentId(rs.getInt("student_id"));
        progress.setLessonId(rs.getInt("lesson_id"));
        progress.setCourseId(rs.getInt("course_id"));
        progress.setWatchDuration(rs.getInt("watch_duration"));
        progress.setTotalDuration(rs.getInt("total_duration"));
        progress.setCompletionPercentage(rs.getBigDecimal("completion_percentage"));
        progress.setCompleted(rs.getBoolean("is_completed"));
        progress.setLastPosition(rs.getInt("last_position"));

        Timestamp firstWatched = rs.getTimestamp("first_watched_at");
        if (firstWatched != null) {
            progress.setFirstWatchedAt(firstWatched.toLocalDateTime());
        }

        Timestamp lastWatched = rs.getTimestamp("last_watched_at");
        if (lastWatched != null) {
            progress.setLastWatchedAt(lastWatched.toLocalDateTime());
        }

        Timestamp completed = rs.getTimestamp("completed_at");
        if (completed != null) {
            progress.setCompletedAt(completed.toLocalDateTime());
        }

        return progress;
    }

    private StudentCourseProgress mapCourseProgress(ResultSet rs) throws SQLException {
        StudentCourseProgress progress = new StudentCourseProgress();
        progress.setId(rs.getInt("id"));
        progress.setStudentId(rs.getInt("student_id"));
        progress.setCourseId(rs.getInt("course_id"));
        progress.setTotalLessons(rs.getInt("total_lessons"));
        progress.setCompletedLessons(rs.getInt("completed_lessons"));
        progress.setCompletionPercentage(rs.getBigDecimal("completion_percentage"));

        Timestamp started = rs.getTimestamp("started_at");
        if (started != null) {
            progress.setStartedAt(started.toLocalDateTime());
        }

        Timestamp lastAccessed = rs.getTimestamp("last_accessed_at");
        if (lastAccessed != null) {
            progress.setLastAccessedAt(lastAccessed.toLocalDateTime());
        }

        Timestamp estimated = rs.getTimestamp("estimated_completion_date");
        if (estimated != null) {
            progress.setEstimatedCompletionDate(estimated.toLocalDateTime());
        }

        // Additional display fields
        progress.setCourseTitle(rs.getString("course_title"));
        progress.setTeacherName(rs.getString("teacher_name"));

        return progress;
    }

    /**
     * Mark text-based lesson as completed
     */
    public boolean markTextLessonAsCompleted(int studentId, int lessonId, int courseId) {
        String sql = """
        INSERT INTO student_lesson_progress 
        (student_id, lesson_id, course_id, watch_duration, total_duration, 
         completion_percentage, is_completed, last_position, completed_at)
        VALUES (?, ?, ?, 0, 0, 100.00, 1, 0, CURRENT_TIMESTAMP)
        ON DUPLICATE KEY UPDATE
        completion_percentage = 100.00,
        is_completed = 1,
        completed_at = CASE WHEN completed_at IS NULL THEN CURRENT_TIMESTAMP ELSE completed_at END,
        last_watched_at = CURRENT_TIMESTAMP
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, lessonId);
            ps.setInt(3, courseId);

            int result = ps.executeUpdate();

            // Update course progress if lesson was marked as completed
            if (result > 0) {
                updateCourseProgress(studentId, courseId);
            }

            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if text lesson is already completed
     */
    public boolean isTextLessonCompleted(int studentId, int lessonId, int courseId) {
        String sql = "SELECT is_completed FROM student_lesson_progress WHERE student_id = ? AND lesson_id = ? AND course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, lessonId);
            ps.setInt(3, courseId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBoolean("is_completed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
