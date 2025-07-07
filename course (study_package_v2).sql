-- Update database structure for new course system
USE `db-script`;

-- Add course status and approval workflow
ALTER TABLE study_package 
ADD COLUMN subject_id INT NULL AFTER grade_id,
ADD COLUMN course_title VARCHAR(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
ADD COLUMN image_thumbnail_id INT NULL,
ADD COLUMN approval_status ENUM('DRAFT', 'PENDING_APPROVAL', 'APPROVED', 'REJECTED') DEFAULT 'DRAFT',
ADD COLUMN submitted_at DATETIME NULL,
ADD COLUMN approved_at DATETIME NULL,
ADD COLUMN approved_by INT NULL,
ADD COLUMN rejection_reason TEXT NULL,
ADD COLUMN created_by INT NULL,
MODIFY COLUMN type ENUM('COURSE') DEFAULT 'COURSE',
MODIFY COLUMN max_students INT DEFAULT 1 COMMENT 'Always 1 for new course system',
DROP FOREIGN KEY study_package_grade_id_fk;

-- Add foreign keys
ALTER TABLE study_package 
ADD CONSTRAINT study_package_subject_id_fk FOREIGN KEY (subject_id) REFERENCES subject(id),
ADD CONSTRAINT study_package_image_thumbnail_fk FOREIGN KEY (image_thumbnail_id) REFERENCES image(id),
ADD CONSTRAINT study_package_approved_by_fk FOREIGN KEY (approved_by) REFERENCES account(id),
ADD CONSTRAINT study_package_created_by_fk FOREIGN KEY (created_by) REFERENCES account(id);

-- Create course_chapter table to link courses with chapters
CREATE TABLE course_chapter (
    id INT NOT NULL AUTO_INCREMENT,
    course_id INT NOT NULL,
    chapter_id INT NOT NULL,
    display_order INT NOT NULL DEFAULT 1,
    is_active BIT(1) DEFAULT b'1',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY unique_course_chapter (course_id, chapter_id),
    KEY course_chapter_course_id_fk (course_id),
    KEY course_chapter_chapter_id_fk (chapter_id),
    CONSTRAINT course_chapter_course_id_fk FOREIGN KEY (course_id) REFERENCES study_package(id),
    CONSTRAINT course_chapter_chapter_id_fk FOREIGN KEY (chapter_id) REFERENCES chapter(id)
);

-- Create course_lesson table for lesson ordering within course
CREATE TABLE course_lesson (
    id INT NOT NULL AUTO_INCREMENT,
    course_id INT NOT NULL,
    lesson_id INT NOT NULL,
    chapter_id INT NOT NULL,
    display_order INT NOT NULL DEFAULT 1,
    lesson_type ENUM('LESSON', 'PRACTICE_TEST', 'OFFICIAL_TEST') DEFAULT 'LESSON',
    is_active BIT(1) DEFAULT b'1',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY unique_course_lesson (course_id, lesson_id),
    KEY course_lesson_course_id_fk (course_id),
    KEY course_lesson_lesson_id_fk (lesson_id),
    KEY course_lesson_chapter_id_fk (chapter_id),
    CONSTRAINT course_lesson_course_id_fk FOREIGN KEY (course_id) REFERENCES study_package(id),
    CONSTRAINT course_lesson_lesson_id_fk FOREIGN KEY (lesson_id) REFERENCES lesson(id),
    CONSTRAINT course_lesson_chapter_id_fk FOREIGN KEY (chapter_id) REFERENCES chapter(id)
);

-- Create course_test table for tests within course
CREATE TABLE course_test (
    id INT NOT NULL AUTO_INCREMENT,
    course_id INT NOT NULL,
    test_id INT NOT NULL,
    chapter_id INT NULL,
    display_order INT NOT NULL DEFAULT 1,
    test_type ENUM('PRACTICE', 'OFFICIAL') DEFAULT 'PRACTICE',
    is_active BIT(1) DEFAULT b'1',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY unique_course_test (course_id, test_id),
    KEY course_test_course_id_fk (course_id),
    KEY course_test_test_id_fk (test_id),
    KEY course_test_chapter_id_fk (chapter_id),
    CONSTRAINT course_test_course_id_fk FOREIGN KEY (course_id) REFERENCES study_package(id),
    CONSTRAINT course_test_test_id_fk FOREIGN KEY (test_id) REFERENCES test(id),
    CONSTRAINT course_test_chapter_id_fk FOREIGN KEY (chapter_id) REFERENCES chapter(id)
);

-- Update student_package for new course system
ALTER TABLE student_package 
MODIFY COLUMN package_id INT NOT NULL COMMENT 'Now refers to course_id',
ADD COLUMN enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN completion_status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'NOT_STARTED';

-- Create view for course management
CREATE OR REPLACE VIEW course_management_view AS
SELECT 
    sp.id as course_id,
    sp.course_title,
    sp.price,
    sp.duration_days,
    sp.description,
    sp.approval_status,
    sp.is_active,
    sp.created_at,
    sp.submitted_at,
    sp.approved_at,
    sp.created_by,
    sp.approved_by,
    sp.rejection_reason,
    g.name as grade_name,
    s.name as subject_name,
    s.id as subject_id,
    g.id as grade_id,
    creator.full_name as created_by_name,
    approver.full_name as approved_by_name,
    COUNT(DISTINCT cc.chapter_id) as total_chapters,
    COUNT(DISTINCT cl.lesson_id) as total_lessons,
    COUNT(DISTINCT ct.test_id) as total_tests
FROM study_package sp
LEFT JOIN subject s ON sp.subject_id = s.id
LEFT JOIN grade g ON s.grade_id = g.id
LEFT JOIN account creator ON sp.created_by = creator.id
LEFT JOIN account approver ON sp.approved_by = approver.id
LEFT JOIN course_chapter cc ON sp.id = cc.course_id AND cc.is_active = 1
LEFT JOIN course_lesson cl ON sp.id = cl.course_id AND cl.is_active = 1
LEFT JOIN course_test ct ON sp.id = ct.course_id AND ct.is_active = 1
WHERE sp.type = 'COURSE'
GROUP BY sp.id;

-- Update study_package table structure for new course system
ALTER TABLE study_package 
MODIFY COLUMN type ENUM('COURSE') DEFAULT 'COURSE',
MODIFY COLUMN max_students INT DEFAULT 1 COMMENT 'Always 1 for new course system';

-- Ensure all required columns exist
SET @col_subject_id := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'db-script' AND TABLE_NAME = 'study_package' AND COLUMN_NAME = 'subject_id');
SET @col_course_title := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'db-script' AND TABLE_NAME = 'study_package' AND COLUMN_NAME = 'course_title');
SET @col_approval_status := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'db-script' AND TABLE_NAME = 'study_package' AND COLUMN_NAME = 'approval_status');

-- Add missing columns if they don't exist
SET @sql := CASE 
  WHEN @col_subject_id = 0 THEN 'ALTER TABLE study_package ADD COLUMN subject_id INT NULL;'
  ELSE 'SELECT "subject_id column exists" as message;'
END;
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := CASE 
  WHEN @col_course_title = 0 THEN 'ALTER TABLE study_package ADD COLUMN course_title VARCHAR(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci;'
  ELSE 'SELECT "course_title column exists" as message;'
END;
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := CASE 
  WHEN @col_approval_status = 0 THEN 'ALTER TABLE study_package ADD COLUMN approval_status ENUM(\'DRAFT\', \'PENDING_APPROVAL\', \'APPROVED\', \'REJECTED\') DEFAULT \'DRAFT\';'
  ELSE 'SELECT "approval_status column exists" as message;'
END;
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add foreign key for subject_id if it doesn't exist
SET @fk_subject_exists := (SELECT COUNT(1) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = 'db-script' AND TABLE_NAME = 'study_package' AND CONSTRAINT_NAME = 'study_package_subject_id_fk');
SET @sql := IF(@fk_subject_exists = 0 AND @col_subject_id > 0, 'ALTER TABLE study_package ADD CONSTRAINT study_package_subject_id_fk FOREIGN KEY (subject_id) REFERENCES subject(id);', 'SELECT "Foreign key exists or column missing" as message;');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Create course content ordering table
CREATE TABLE IF NOT EXISTS course_content_order (
    id INT NOT NULL AUTO_INCREMENT,
    course_id INT NOT NULL,
    content_type ENUM('CHAPTER', 'LESSON', 'TEST') NOT NULL,
    content_id INT NOT NULL,
    display_order INT NOT NULL DEFAULT 1,
    parent_content_id INT NULL COMMENT 'For lessons under chapters',
    is_active BIT(1) DEFAULT b'1',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY unique_course_content (course_id, content_type, content_id),
    KEY course_content_order_course_id_fk (course_id),
    CONSTRAINT course_content_order_course_id_fk FOREIGN KEY (course_id) REFERENCES study_package(id)
);

CREATE TABLE IF NOT EXISTS course_lesson (
    id INT NOT NULL AUTO_INCREMENT,
    course_id INT NOT NULL,
    lesson_id INT NOT NULL,
    chapter_id INT NOT NULL,
    display_order INT NOT NULL DEFAULT 1,
    lesson_type ENUM('LESSON', 'PRACTICE_TEST', 'OFFICIAL_TEST') DEFAULT 'LESSON',
    is_active BIT(1) DEFAULT b'1',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY course_lesson_course_id_fk (course_id),
    KEY course_lesson_lesson_id_fk (lesson_id),
    KEY course_lesson_chapter_id_fk (chapter_id),
    KEY idx_course_chapter_order (course_id, chapter_id, display_order),
    CONSTRAINT course_lesson_course_id_fk FOREIGN KEY (course_id) REFERENCES study_package(id),
    CONSTRAINT course_lesson_lesson_id_fk FOREIGN KEY (lesson_id) REFERENCES lesson(id),
    CONSTRAINT course_lesson_chapter_id_fk FOREIGN KEY (chapter_id) REFERENCES chapter(id)
);

-- Remove any conflicting unique constraints
ALTER TABLE course_lesson DROP INDEX unique_course_lesson;

-- Add a better unique constraint that allows the same lesson in different courses
-- but prevents duplicate lesson in same course
ALTER TABLE course_lesson 
ADD UNIQUE INDEX unique_course_lesson_active (course_id, lesson_id, is_active);

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = 'db-script' 
     AND TABLE_NAME = 'course_lesson' 
     AND INDEX_NAME = 'unique_course_lesson_active') > 0,
    'ALTER TABLE course_lesson DROP INDEX unique_course_lesson_active',
    'SELECT "Index unique_course_lesson_active does not exist" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
     WHERE TABLE_SCHEMA = 'db-script' 
     AND TABLE_NAME = 'course_lesson' 
     AND INDEX_NAME = 'unique_active_course_lesson') > 0,
    'ALTER TABLE course_lesson DROP INDEX unique_active_course_lesson',
    'SELECT "Index unique_active_course_lesson does not exist" as message'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Clean up any duplicate data first
DELETE cl1 FROM course_lesson cl1
INNER JOIN course_lesson cl2 
WHERE cl1.id > cl2.id 
AND cl1.course_id = cl2.course_id 
AND cl1.lesson_id = cl2.lesson_id;

-- Add a better constraint that only prevents active duplicates
ALTER TABLE course_lesson 
ADD UNIQUE INDEX unique_active_course_lesson (course_id, lesson_id) 