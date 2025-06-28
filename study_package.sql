USE `db-script`;

-- Add new columns to study_package table
ALTER TABLE study_package 
ADD COLUMN type ENUM('SUBJECT_COMBO', 'GRADE_ALL') DEFAULT 'SUBJECT_COMBO',
ADD COLUMN grade_id INT NULL,
ADD COLUMN max_students INT DEFAULT 1,
ADD COLUMN duration_days INT DEFAULT 365,
ADD COLUMN description TEXT,
ADD COLUMN is_active BIT(1) DEFAULT b'1',
ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Add foreign key for grade_id
ALTER TABLE study_package 
ADD CONSTRAINT study_package_grade_id_fk 
FOREIGN KEY (grade_id) REFERENCES grade(id);

-- Create student_package table to track package assignments
CREATE TABLE student_package (
    id INT NOT NULL AUTO_INCREMENT,
    student_id INT NOT NULL,
    package_id INT NOT NULL,
    parent_id INT NOT NULL,
    purchased_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    is_active BIT(1) DEFAULT b'1',
    PRIMARY KEY (id),
    UNIQUE KEY unique_student_package (student_id, package_id),
    KEY student_package_student_id_fk (student_id),
    KEY student_package_package_id_fk (package_id),
    KEY student_package_parent_id_fk (parent_id),
    CONSTRAINT student_package_student_id_fk FOREIGN KEY (student_id) REFERENCES student(id),
    CONSTRAINT student_package_package_id_fk FOREIGN KEY (package_id) REFERENCES study_package(id),
    CONSTRAINT student_package_parent_id_fk FOREIGN KEY (parent_id) REFERENCES account(id)
);

-- Create package_access_log table to track access
CREATE TABLE package_access_log (
    id INT NOT NULL AUTO_INCREMENT,
    student_id INT NOT NULL,
    package_id INT NOT NULL,
    lesson_id INT NULL,
    access_type ENUM('VIDEO_VIEW', 'TEST_TAKE', 'LESSON_ACCESS') NOT NULL,
    accessed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY package_access_log_student_id_fk (student_id),
    KEY package_access_log_package_id_fk (package_id),
    KEY package_access_log_lesson_id_fk (lesson_id),
    CONSTRAINT package_access_log_student_id_fk FOREIGN KEY (student_id) REFERENCES student(id),
    CONSTRAINT package_access_log_package_id_fk FOREIGN KEY (package_id) REFERENCES study_package(id),
    CONSTRAINT package_access_log_lesson_id_fk FOREIGN KEY (lesson_id) REFERENCES lesson(id)
);

-- Update invoice_line to include student assignment
ALTER TABLE invoice_line 
ADD COLUMN student_id INT NULL,
ADD CONSTRAINT invoice_line_student_id_fk FOREIGN KEY (student_id) REFERENCES student(id);

-- Create view for package access checking
CREATE OR REPLACE VIEW student_package_access AS
SELECT 
    sp.student_id,
    sp.package_id,
    sp.parent_id,
    sp.purchased_at,
    sp.expires_at,
    sp.is_active,
    pkg.name as package_name,
    pkg.type as package_type,
    pkg.grade_id as package_grade_id,
    CASE 
        WHEN sp.expires_at > NOW() AND sp.is_active = 1 THEN 1 
        ELSE 0 
    END as has_access
FROM student_package sp
JOIN study_package pkg ON sp.package_id = pkg.id;

-- Create package_subject table for SUBJECT_COMBO packages
CREATE TABLE package_subject (
    id INT NOT NULL AUTO_INCREMENT,
    package_id INT NOT NULL,
    subject_id INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_package_subject (package_id, subject_id),
    KEY package_subject_package_id_fk (package_id),
    KEY package_subject_subject_id_fk (subject_id),
    CONSTRAINT package_subject_package_id_fk FOREIGN KEY (package_id) REFERENCES study_package(id),
    CONSTRAINT package_subject_subject_id_fk FOREIGN KEY (subject_id) REFERENCES subject(id)
);