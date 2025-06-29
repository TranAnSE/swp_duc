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

-- Update student_package table to support better package management
ALTER TABLE student_package 
DROP INDEX unique_student_package,
ADD INDEX idx_student_package_active (student_id, package_id, is_active),
ADD INDEX idx_package_assignments (package_id, is_active, expires_at);

-- Add assignment tracking columns
ALTER TABLE student_package 
ADD COLUMN assigned_by INT NULL COMMENT 'Who assigned this package',
ADD COLUMN assignment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT student_package_assigned_by_fk FOREIGN KEY (assigned_by) REFERENCES account(id);

-- Create package assignment summary view
CREATE OR REPLACE VIEW package_assignment_summary AS
SELECT 
    pkg.id as package_id,
    pkg.name as package_name,
    pkg.max_students as max_students_per_parent,
    COUNT(DISTINCT sp.parent_id) as total_parents,
    COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as total_active_assignments,
    COUNT(*) as total_assignments
FROM study_package pkg
LEFT JOIN student_package sp ON pkg.id = sp.package_id
WHERE pkg.is_active = 1
GROUP BY pkg.id, pkg.name, pkg.max_students;

-- Create parent package management view
CREATE OR REPLACE VIEW parent_package_management AS
SELECT 
    sp.id as assignment_id,
    sp.parent_id,
    sp.package_id,
    sp.student_id,
    sp.purchased_at,
    sp.expires_at,
    sp.is_active,
    pkg.name as package_name,
    pkg.max_students,
    pkg.price,
    s.full_name as student_name,
    s.username as student_username,
    g.name as grade_name,
    CASE 
        WHEN sp.expires_at > NOW() AND sp.is_active = 1 THEN 'ACTIVE'
        WHEN sp.expires_at <= NOW() THEN 'EXPIRED'
        ELSE 'INACTIVE'
    END as status,
    DATEDIFF(sp.expires_at, NOW()) as days_remaining
FROM student_package sp
JOIN study_package pkg ON sp.package_id = pkg.id
JOIN student s ON sp.student_id = s.id
JOIN grade g ON s.grade_id = g.id
ORDER BY sp.purchased_at DESC;

-- Add column to track per-parent limits
ALTER TABLE study_package 
MODIFY COLUMN max_students INT DEFAULT 1 COMMENT 'Maximum students per parent for this package';

-- Update student_package table to better support per-parent assignment tracking
ALTER TABLE student_package 
ADD COLUMN package_slots_purchased INT DEFAULT 1 COMMENT 'Number of slots this parent purchased for this package',
ADD INDEX idx_parent_package_active (parent_id, package_id, is_active);

-- Create view for parent package slot management
CREATE OR REPLACE VIEW parent_package_slots AS
SELECT 
    sp.parent_id,
    sp.package_id,
    pkg.name as package_name,
    pkg.max_students as max_students_per_parent,
    COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as active_assignments,
    pkg.max_students - COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as available_slots
FROM study_package pkg
LEFT JOIN student_package sp ON pkg.id = sp.package_id
WHERE pkg.is_active = 1
GROUP BY sp.parent_id, sp.package_id, pkg.name, pkg.max_students;

-- Update student_package table to support per-parent limits properly
SET @idx := (
  SELECT COUNT(1)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = 'db-script'
    AND TABLE_NAME = 'student_package'
    AND INDEX_NAME = 'idx_parent_package_active'
);

SET @sql := IF(@idx > 0, 'ALTER TABLE student_package DROP INDEX unique_student_package;', 'SELECT "Index does not exist"');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add proper indexes for per-parent package management
ALTER TABLE student_package 
ADD INDEX idx_parent_package_active (parent_id, package_id, is_active, expires_at),
ADD INDEX idx_student_active_package (student_id, package_id, is_active, expires_at);

-- Create view for parent package statistics
CREATE OR REPLACE VIEW parent_package_stats AS
SELECT 
    sp.parent_id,
    sp.package_id,
    pkg.name as package_name,
    pkg.max_students as max_per_parent,
    COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as active_assignments,
    COUNT(*) as total_assignments,
    (pkg.max_students - COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END)) as available_slots
FROM study_package pkg
LEFT JOIN student_package sp ON pkg.id = sp.package_id
WHERE pkg.is_active = 1
GROUP BY sp.parent_id, sp.package_id, pkg.name, pkg.max_students;

-- Add purchase tracking table to separate purchase from assignment
CREATE TABLE IF NOT EXISTS package_purchase (
    id INT NOT NULL AUTO_INCREMENT,
    parent_id INT NOT NULL,
    package_id INT NOT NULL,
    purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount VARCHAR(50) NOT NULL,
    invoice_id INT NULL,
    status ENUM('PENDING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    max_assignable_students INT NOT NULL COMMENT 'How many students this purchase allows',
    PRIMARY KEY (id),
    KEY package_purchase_parent_id_fk (parent_id),
    KEY package_purchase_package_id_fk (package_id),
    KEY package_purchase_invoice_id_fk (invoice_id),
    CONSTRAINT package_purchase_parent_id_fk FOREIGN KEY (parent_id) REFERENCES account(id),
    CONSTRAINT package_purchase_package_id_fk FOREIGN KEY (package_id) REFERENCES study_package(id),
    CONSTRAINT package_purchase_invoice_id_fk FOREIGN KEY (invoice_id) REFERENCES invoice(id)
);

-- Update student_package to link to purchase
ALTER TABLE student_package 
ADD COLUMN purchase_id INT NULL COMMENT 'Link to the purchase that enabled this assignment',
ADD CONSTRAINT student_package_purchase_id_fk FOREIGN KEY (purchase_id) REFERENCES package_purchase(id);

-- Create view to track parent's available slots across all purchases
CREATE OR REPLACE VIEW parent_package_available_slots AS
SELECT 
    pp.parent_id,
    pp.package_id,
    pkg.name as package_name,
    SUM(pp.max_assignable_students) as total_purchased_slots,
    COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END) as currently_assigned,
    (SUM(pp.max_assignable_students) - COUNT(CASE WHEN sp.is_active = 1 AND sp.expires_at > NOW() THEN 1 END)) as available_slots
FROM package_purchase pp
JOIN study_package pkg ON pp.package_id = pkg.id
LEFT JOIN student_package sp ON pp.id = sp.purchase_id
WHERE pp.status = 'COMPLETED'
GROUP BY pp.parent_id, pp.package_id, pkg.name;