USE `db-script`;
ALTER TABLE question ADD COLUMN is_ai_generated BIT(1) DEFAULT b'0';

ALTER TABLE question ADD COLUMN difficulty VARCHAR(20) DEFAULT 'medium';
ALTER TABLE question ADD COLUMN category VARCHAR(50) DEFAULT 'conceptual';

UPDATE question SET difficulty = 'medium', category = 'conceptual' WHERE difficulty IS NULL;

-- Add index to increase query performance
ALTER TABLE question ADD INDEX idx_lesson_id (lesson_id);
ALTER TABLE question ADD INDEX idx_difficulty (difficulty);
ALTER TABLE question ADD INDEX idx_category (category);
ALTER TABLE question ADD INDEX idx_ai_generated (is_ai_generated);

-- Add constraints to ensure data validity
ALTER TABLE question ADD CONSTRAINT chk_difficulty 
    CHECK (difficulty IN ('easy', 'medium', 'hard', 'mixed'));

ALTER TABLE question ADD CONSTRAINT chk_category 
    CHECK (category IN ('conceptual', 'application', 'analysis', 'synthesis', 'evaluation', 'mixed'));
 
-- Create a view to easily query question information with lesson name 
    CREATE OR REPLACE VIEW question_with_lesson_info AS
SELECT 
    q.id,
    q.question,
    q.image_id,
    q.lesson_id,
    q.question_type,
    q.is_ai_generated,
    q.difficulty,
    q.category,
    l.name as lesson_name,
    c.name as chapter_name,
    s.name as subject_name,
    g.name as grade_name
FROM question q
LEFT JOIN lesson l ON q.lesson_id = l.id
LEFT JOIN chapter c ON l.chapter_id = c.id
LEFT JOIN subject s ON c.subject_id = s.id
LEFT JOIN grade g ON s.grade_id = g.id;

-- Create stored procedure to get random questions based on criteria
DELIMITER //
CREATE PROCEDURE GetRandomQuestionsByLesson(
    IN p_lesson_id INT,
    IN p_count INT,
    IN p_difficulty VARCHAR(20),
    IN p_category VARCHAR(50)
)
BEGIN
    DECLARE sql_query TEXT;
    
    -- Gán giá trị tham số vào user-defined variables
    SET @lesson_id = p_lesson_id;
    
    SET sql_query = 'SELECT * FROM question WHERE lesson_id = ?';
    
    IF p_difficulty IS NOT NULL AND p_difficulty != 'all' THEN
        SET sql_query = CONCAT(sql_query, ' AND difficulty = ''', p_difficulty, '''');
    END IF;
    
    IF p_category IS NOT NULL AND p_category != 'all' THEN
        SET sql_query = CONCAT(sql_query, ' AND category = ''', p_category, '''');
    END IF;
    
    SET sql_query = CONCAT(sql_query, ' ORDER BY RAND() LIMIT ', p_count);
    
    SET @sql = sql_query;
    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @lesson_id;  -- Sử dụng @lesson_id thay vì p_lesson_id
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;