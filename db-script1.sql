-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: db-script1
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `role` varchar(30) DEFAULT NULL,
  `full_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sex` int DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `image_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_uk_email` (`email`),
  KEY `account_image_id_fk` (`image_id`),
  CONSTRAINT `account_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chapter`
--

DROP TABLE IF EXISTS `chapter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chapter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `description` text,
  `subject_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `chapter_subject_id_fk` (`subject_id`),
  CONSTRAINT `chapter_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_chapter`
--

DROP TABLE IF EXISTS `course_chapter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_chapter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `chapter_id` int NOT NULL,
  `display_order` int NOT NULL DEFAULT '1',
  `is_active` bit(1) DEFAULT b'1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_course_chapter` (`course_id`,`chapter_id`),
  KEY `course_chapter_course_id_fk` (`course_id`),
  KEY `course_chapter_chapter_id_fk` (`chapter_id`),
  KEY `idx_course_active` (`course_id`,`is_active`),
  CONSTRAINT `course_chapter_chapter_id_fk` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`),
  CONSTRAINT `course_chapter_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `study_package` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_content_order`
--

DROP TABLE IF EXISTS `course_content_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_content_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `content_type` enum('CHAPTER','LESSON','TEST') NOT NULL,
  `content_id` int NOT NULL,
  `display_order` int NOT NULL DEFAULT '1',
  `parent_content_id` int DEFAULT NULL COMMENT 'For lessons under chapters',
  `is_active` bit(1) DEFAULT b'1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_course_content` (`course_id`,`content_type`,`content_id`),
  KEY `course_content_order_course_id_fk` (`course_id`),
  CONSTRAINT `course_content_order_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `study_package` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_lesson`
--

DROP TABLE IF EXISTS `course_lesson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_lesson` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `lesson_id` int NOT NULL,
  `chapter_id` int NOT NULL,
  `display_order` int NOT NULL DEFAULT '1',
  `lesson_type` enum('LESSON','PRACTICE_TEST','OFFICIAL_TEST') DEFAULT 'LESSON',
  `is_active` bit(1) DEFAULT b'1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_active_course_lesson` (`course_id`,`lesson_id`),
  UNIQUE KEY `unique_active_course_lesson_v2` (`course_id`,`lesson_id`,`is_active`),
  KEY `course_lesson_course_id_fk` (`course_id`),
  KEY `course_lesson_lesson_id_fk` (`lesson_id`),
  KEY `course_lesson_chapter_id_fk` (`chapter_id`),
  KEY `idx_course_chapter_lesson` (`course_id`,`chapter_id`,`lesson_id`),
  KEY `idx_course_chapter_active` (`course_id`,`chapter_id`,`is_active`),
  KEY `idx_lesson_active` (`lesson_id`,`is_active`),
  CONSTRAINT `course_lesson_chapter_id_fk` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`),
  CONSTRAINT `course_lesson_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `study_package` (`id`),
  CONSTRAINT `course_lesson_lesson_id_fk` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `course_management_view`
--

DROP TABLE IF EXISTS `course_management_view`;
/*!50001 DROP VIEW IF EXISTS `course_management_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `course_management_view` AS SELECT 
 1 AS `course_id`,
 1 AS `course_title`,
 1 AS `price`,
 1 AS `duration_days`,
 1 AS `description`,
 1 AS `approval_status`,
 1 AS `is_active`,
 1 AS `created_at`,
 1 AS `submitted_at`,
 1 AS `approved_at`,
 1 AS `created_by`,
 1 AS `approved_by`,
 1 AS `rejection_reason`,
 1 AS `allow_edit_after_approval`,
 1 AS `grade_name`,
 1 AS `subject_name`,
 1 AS `subject_id`,
 1 AS `grade_id`,
 1 AS `created_by_name`,
 1 AS `approved_by_name`,
 1 AS `thumbnail_url`,
 1 AS `image_thumbnail_id`,
 1 AS `total_chapters`,
 1 AS `total_lessons`,
 1 AS `total_tests`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `course_test`
--

DROP TABLE IF EXISTS `course_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_test` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `test_id` int NOT NULL,
  `chapter_id` int DEFAULT NULL,
  `display_order` int NOT NULL DEFAULT '1',
  `test_type` enum('PRACTICE','OFFICIAL') DEFAULT 'PRACTICE',
  `is_active` bit(1) DEFAULT b'1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `prerequisites` text COMMENT 'JSON string of prerequisite lessons/chapters',
  `available_after` datetime DEFAULT NULL COMMENT 'When this test becomes available',
  `max_attempts` int DEFAULT '1' COMMENT 'Maximum attempts allowed (1 for official, unlimited for practice)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_course_test` (`course_id`,`test_id`),
  KEY `course_test_course_id_fk` (`course_id`),
  KEY `course_test_test_id_fk` (`test_id`),
  KEY `course_test_chapter_id_fk` (`chapter_id`),
  CONSTRAINT `course_test_chapter_id_fk` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`),
  CONSTRAINT `course_test_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `study_package` (`id`),
  CONSTRAINT `course_test_test_id_fk` FOREIGN KEY (`test_id`) REFERENCES `test` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grade`
--

DROP TABLE IF EXISTS `grade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `description` text,
  `teacher_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `grade_account_id_fk` (`teacher_id`),
  CONSTRAINT `grade_account_id_fk` FOREIGN KEY (`teacher_id`) REFERENCES `account` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `id` int NOT NULL AUTO_INCREMENT,
  `image_data` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `total_amount` mediumtext,
  `parent_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_account_id_fk` (`parent_id`),
  CONSTRAINT `invoice_account_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `account` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_line`
--

DROP TABLE IF EXISTS `invoice_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_line` (
  `invoice_id` int NOT NULL,
  `package_id` int NOT NULL,
  `student_id` int DEFAULT NULL,
  PRIMARY KEY (`invoice_id`,`package_id`),
  KEY `invoice_line_study_package_id_fk` (`package_id`),
  KEY `invoice_line_student_id_fk` (`student_id`),
  CONSTRAINT `invoice_line_invoice_id_fk` FOREIGN KEY (`invoice_id`) REFERENCES `invoice` (`id`),
  CONSTRAINT `invoice_line_student_id_fk` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
  CONSTRAINT `invoice_line_study_package_id_fk` FOREIGN KEY (`package_id`) REFERENCES `study_package` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lesson`
--

DROP TABLE IF EXISTS `lesson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` longtext,
  `chapter_id` int DEFAULT NULL,
  `video_link` text,
  PRIMARY KEY (`id`),
  KEY `lesson_chapter_id_fk` (`chapter_id`),
  CONSTRAINT `lesson_chapter_id_fk` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `package_access_log`
--

DROP TABLE IF EXISTS `package_access_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `package_access_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `package_id` int NOT NULL,
  `lesson_id` int DEFAULT NULL,
  `access_type` enum('VIDEO_VIEW','TEST_TAKE','LESSON_ACCESS') NOT NULL,
  `accessed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `package_access_log_student_id_fk` (`student_id`),
  KEY `package_access_log_package_id_fk` (`package_id`),
  KEY `package_access_log_lesson_id_fk` (`lesson_id`),
  CONSTRAINT `package_access_log_lesson_id_fk` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`),
  CONSTRAINT `package_access_log_package_id_fk` FOREIGN KEY (`package_id`) REFERENCES `study_package` (`id`),
  CONSTRAINT `package_access_log_student_id_fk` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `package_assignment_summary`
--

DROP TABLE IF EXISTS `package_assignment_summary`;
/*!50001 DROP VIEW IF EXISTS `package_assignment_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `package_assignment_summary` AS SELECT 
 1 AS `package_id`,
 1 AS `package_name`,
 1 AS `max_students_per_parent`,
 1 AS `total_parents`,
 1 AS `total_active_assignments`,
 1 AS `total_assignments`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `package_purchase`
--

DROP TABLE IF EXISTS `package_purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `package_purchase` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL,
  `package_id` int NOT NULL,
  `purchase_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `total_amount` varchar(50) NOT NULL,
  `invoice_id` int DEFAULT NULL,
  `status` enum('PENDING','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `max_assignable_students` int NOT NULL COMMENT 'How many students this purchase allows',
  PRIMARY KEY (`id`),
  KEY `package_purchase_parent_id_fk` (`parent_id`),
  KEY `package_purchase_package_id_fk` (`package_id`),
  KEY `package_purchase_invoice_id_fk` (`invoice_id`),
  CONSTRAINT `package_purchase_invoice_id_fk` FOREIGN KEY (`invoice_id`) REFERENCES `invoice` (`id`),
  CONSTRAINT `package_purchase_package_id_fk` FOREIGN KEY (`package_id`) REFERENCES `study_package` (`id`),
  CONSTRAINT `package_purchase_parent_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `parent_package_available_slots`
--

DROP TABLE IF EXISTS `parent_package_available_slots`;
/*!50001 DROP VIEW IF EXISTS `parent_package_available_slots`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `parent_package_available_slots` AS SELECT 
 1 AS `parent_id`,
 1 AS `package_id`,
 1 AS `package_name`,
 1 AS `total_purchased_slots`,
 1 AS `currently_assigned`,
 1 AS `available_slots`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `parent_package_management`
--

DROP TABLE IF EXISTS `parent_package_management`;
/*!50001 DROP VIEW IF EXISTS `parent_package_management`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `parent_package_management` AS SELECT 
 1 AS `assignment_id`,
 1 AS `parent_id`,
 1 AS `package_id`,
 1 AS `student_id`,
 1 AS `purchased_at`,
 1 AS `expires_at`,
 1 AS `is_active`,
 1 AS `package_name`,
 1 AS `max_students`,
 1 AS `price`,
 1 AS `student_name`,
 1 AS `student_username`,
 1 AS `grade_name`,
 1 AS `status`,
 1 AS `days_remaining`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `parent_package_slots`
--

DROP TABLE IF EXISTS `parent_package_slots`;
/*!50001 DROP VIEW IF EXISTS `parent_package_slots`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `parent_package_slots` AS SELECT 
 1 AS `parent_id`,
 1 AS `package_id`,
 1 AS `package_name`,
 1 AS `max_students_per_parent`,
 1 AS `active_assignments`,
 1 AS `available_slots`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `parent_package_stats`
--

DROP TABLE IF EXISTS `parent_package_stats`;
/*!50001 DROP VIEW IF EXISTS `parent_package_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `parent_package_stats` AS SELECT 
 1 AS `parent_id`,
 1 AS `package_id`,
 1 AS `package_name`,
 1 AS `max_per_parent`,
 1 AS `active_assignments`,
 1 AS `total_assignments`,
 1 AS `available_slots`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `parent_purchase_history`
--

DROP TABLE IF EXISTS `parent_purchase_history`;
/*!50001 DROP VIEW IF EXISTS `parent_purchase_history`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `parent_purchase_history` AS SELECT 
 1 AS `purchase_id`,
 1 AS `parent_id`,
 1 AS `package_id`,
 1 AS `purchase_date`,
 1 AS `total_amount`,
 1 AS `max_assignable_students`,
 1 AS `status`,
 1 AS `package_name`,
 1 AS `parent_name`,
 1 AS `students_assigned`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question` text NOT NULL,
  `image_id` int DEFAULT NULL,
  `lesson_id` int DEFAULT NULL,
  `question_type` varchar(20) NOT NULL DEFAULT 'SINGLE',
  `is_ai_generated` bit(1) DEFAULT b'0',
  `difficulty` varchar(20) DEFAULT 'medium',
  `category` varchar(50) DEFAULT 'conceptual',
  PRIMARY KEY (`id`),
  KEY `question_lesson_id_fk` (`lesson_id`),
  KEY `question_image_id_fk` (`image_id`),
  KEY `idx_lesson_id` (`lesson_id`),
  KEY `idx_difficulty` (`difficulty`),
  KEY `idx_category` (`category`),
  KEY `idx_ai_generated` (`is_ai_generated`),
  CONSTRAINT `question_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`),
  CONSTRAINT `question_lesson_id_fk` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`),
  CONSTRAINT `chk_category` CHECK ((`category` in (_utf8mb4'conceptual',_utf8mb4'application',_utf8mb4'analysis',_utf8mb4'synthesis',_utf8mb4'evaluation',_utf8mb4'mixed'))),
  CONSTRAINT `chk_difficulty` CHECK ((`difficulty` in (_utf8mb4'easy',_utf8mb4'medium',_utf8mb4'hard',_utf8mb4'mixed')))
) ENGINE=InnoDB AUTO_INCREMENT=263 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `question_option`
--

DROP TABLE IF EXISTS `question_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_option` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int DEFAULT NULL,
  `content` text,
  `is_correct` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_option_question_id_fk` (`question_id`),
  CONSTRAINT `question_option_question_id_fk` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=968 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `question_record`
--

DROP TABLE IF EXISTS `question_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `test_record_id` int DEFAULT NULL,
  `question_id` int DEFAULT NULL,
  `option_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_record_question_id_fk` (`question_id`),
  KEY `question_record_question_option_id_fk` (`option_id`),
  KEY `question_record_test_record_id_fk` (`test_record_id`),
  CONSTRAINT `question_record_question_id_fk` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`),
  CONSTRAINT `question_record_question_option_id_fk` FOREIGN KEY (`option_id`) REFERENCES `question_option` (`id`),
  CONSTRAINT `question_record_test_record_id_fk` FOREIGN KEY (`test_record_id`) REFERENCES `test_record` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `question_with_lesson_info`
--

DROP TABLE IF EXISTS `question_with_lesson_info`;
/*!50001 DROP VIEW IF EXISTS `question_with_lesson_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `question_with_lesson_info` AS SELECT 
 1 AS `id`,
 1 AS `question`,
 1 AS `image_id`,
 1 AS `lesson_id`,
 1 AS `question_type`,
 1 AS `is_ai_generated`,
 1 AS `difficulty`,
 1 AS `category`,
 1 AS `lesson_name`,
 1 AS `chapter_name`,
 1 AS `subject_name`,
 1 AS `grade_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `id` int NOT NULL AUTO_INCREMENT,
  `grade_id` int NOT NULL,
  `parent_id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `full_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `sex` bit(1) DEFAULT NULL,
  `image_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_pk_username` (`username`),
  KEY `student_account_id_fk_2` (`parent_id`),
  KEY `student_grade_id_fk` (`grade_id`),
  KEY `student_image_id_fk` (`image_id`),
  CONSTRAINT `student_account_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `account` (`id`),
  CONSTRAINT `student_grade_id_fk` FOREIGN KEY (`grade_id`) REFERENCES `grade` (`id`),
  CONSTRAINT `student_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_package`
--

DROP TABLE IF EXISTS `student_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_package` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `package_id` int NOT NULL COMMENT 'Now refers to course_id',
  `parent_id` int NOT NULL,
  `purchased_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `is_active` bit(1) DEFAULT b'1',
  `assigned_by` int DEFAULT NULL COMMENT 'Who assigned this package',
  `assignment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `package_slots_purchased` int DEFAULT '1' COMMENT 'Number of slots this parent purchased for this package',
  `purchase_id` int DEFAULT NULL COMMENT 'Link to the purchase that enabled this assignment',
  `enrollment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `completion_status` enum('NOT_STARTED','IN_PROGRESS','COMPLETED') DEFAULT 'NOT_STARTED',
  PRIMARY KEY (`id`),
  KEY `student_package_student_id_fk` (`student_id`),
  KEY `student_package_package_id_fk` (`package_id`),
  KEY `student_package_parent_id_fk` (`parent_id`),
  KEY `idx_student_package_active` (`student_id`,`package_id`,`is_active`),
  KEY `idx_package_assignments` (`package_id`,`is_active`,`expires_at`),
  KEY `student_package_assigned_by_fk` (`assigned_by`),
  KEY `idx_parent_package_active` (`parent_id`,`package_id`,`is_active`,`expires_at`),
  KEY `idx_student_active_package` (`student_id`,`package_id`,`is_active`,`expires_at`),
  KEY `student_package_purchase_id_fk` (`purchase_id`),
  CONSTRAINT `student_package_assigned_by_fk` FOREIGN KEY (`assigned_by`) REFERENCES `account` (`id`),
  CONSTRAINT `student_package_package_id_fk` FOREIGN KEY (`package_id`) REFERENCES `study_package` (`id`),
  CONSTRAINT `student_package_parent_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `account` (`id`),
  CONSTRAINT `student_package_purchase_id_fk` FOREIGN KEY (`purchase_id`) REFERENCES `package_purchase` (`id`),
  CONSTRAINT `student_package_student_id_fk` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `student_package_access`
--

DROP TABLE IF EXISTS `student_package_access`;
/*!50001 DROP VIEW IF EXISTS `student_package_access`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `student_package_access` AS SELECT 
 1 AS `student_id`,
 1 AS `package_id`,
 1 AS `parent_id`,
 1 AS `purchased_at`,
 1 AS `expires_at`,
 1 AS `is_active`,
 1 AS `package_name`,
 1 AS `package_type`,
 1 AS `package_grade_id`,
 1 AS `has_access`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `study_package`
--

DROP TABLE IF EXISTS `study_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_package` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `price` mediumtext,
  `type` enum('COURSE') DEFAULT 'COURSE',
  `grade_id` int DEFAULT NULL,
  `subject_id` int NOT NULL,
  `max_students` int DEFAULT '1' COMMENT 'Always 1 for new course system',
  `duration_days` int DEFAULT '365',
  `description` text,
  `is_active` bit(1) DEFAULT b'1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `course_title` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `image_thumbnail_id` int DEFAULT NULL,
  `approval_status` enum('DRAFT','PENDING_APPROVAL','APPROVED','REJECTED') DEFAULT 'DRAFT',
  `submitted_at` datetime DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `rejection_reason` text,
  `created_by` int NOT NULL,
  `allow_edit_after_approval` tinyint(1) DEFAULT '0' COMMENT 'Admin allows teacher to edit approved course',
  PRIMARY KEY (`id`),
  KEY `study_package_grade_id_fk` (`grade_id`),
  KEY `study_package_subject_id_fk` (`subject_id`),
  KEY `study_package_image_thumbnail_fk` (`image_thumbnail_id`),
  KEY `study_package_approved_by_fk` (`approved_by`),
  KEY `study_package_created_by_fk` (`created_by`),
  CONSTRAINT `study_package_approved_by_fk` FOREIGN KEY (`approved_by`) REFERENCES `account` (`id`),
  CONSTRAINT `study_package_created_by_fk` FOREIGN KEY (`created_by`) REFERENCES `account` (`id`),
  CONSTRAINT `study_package_image_thumbnail_fk` FOREIGN KEY (`image_thumbnail_id`) REFERENCES `image` (`id`),
  CONSTRAINT `study_package_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `description` text,
  `grade_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_grade_id_fk` (`grade_id`),
  CONSTRAINT `subject_grade_id_fk` FOREIGN KEY (`grade_id`) REFERENCES `grade` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `description` text,
  `is_practice` bit(1) DEFAULT NULL,
  `duration_minutes` int DEFAULT '30' COMMENT 'Duration in minutes for this specific test',
  `num_questions` int DEFAULT '10' COMMENT 'Number of questions for this test',
  `course_id` int DEFAULT NULL COMMENT 'Course this test belongs to',
  `chapter_id` int DEFAULT NULL COMMENT 'Chapter this test belongs to (optional)',
  `lesson_id` int DEFAULT NULL,
  `test_order` int DEFAULT '1' COMMENT 'Order of test within course/chapter',
  `created_by` int DEFAULT NULL COMMENT 'Teacher who created this test',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `test_chapter_id_fk` (`chapter_id`),
  KEY `idx_test_course_chapter` (`course_id`,`chapter_id`,`test_order`),
  KEY `idx_test_practice_course` (`is_practice`,`course_id`),
  KEY `idx_test_created_by` (`created_by`,`created_at`),
  KEY `idx_test_course_integration` (`course_id`,`chapter_id`,`test_order`),
  KEY `idx_test_practice_type` (`is_practice`,`course_id`),
  KEY `idx_test_created_by_date` (`created_by`,`created_at`),
  KEY `idx_test_lesson` (`lesson_id`),
  CONSTRAINT `test_chapter_id_fk` FOREIGN KEY (`chapter_id`) REFERENCES `chapter` (`id`),
  CONSTRAINT `test_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `study_package` (`id`),
  CONSTRAINT `test_created_by_fk` FOREIGN KEY (`created_by`) REFERENCES `account` (`id`),
  CONSTRAINT `test_lesson_id_fk` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `test_management_view`
--

DROP TABLE IF EXISTS `test_management_view`;
/*!50001 DROP VIEW IF EXISTS `test_management_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `test_management_view` AS SELECT 
 1 AS `test_id`,
 1 AS `test_name`,
 1 AS `test_description`,
 1 AS `is_practice`,
 1 AS `duration_minutes`,
 1 AS `num_questions`,
 1 AS `test_order`,
 1 AS `created_at`,
 1 AS `updated_at`,
 1 AS `course_id`,
 1 AS `course_name`,
 1 AS `chapter_id`,
 1 AS `chapter_name`,
 1 AS `subject_name`,
 1 AS `grade_name`,
 1 AS `created_by_name`,
 1 AS `total_questions_assigned`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `test_question`
--

DROP TABLE IF EXISTS `test_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_question` (
  `test_id` int NOT NULL,
  `question_id` int NOT NULL,
  PRIMARY KEY (`question_id`,`test_id`),
  KEY `test_question_test_id_fk` (`test_id`),
  CONSTRAINT `test_question_question_id_fk` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`),
  CONSTRAINT `test_question_test_id_fk` FOREIGN KEY (`test_id`) REFERENCES `test` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_record`
--

DROP TABLE IF EXISTS `test_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `test_id` int DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finish_at` datetime DEFAULT NULL,
  `score` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `test_record_account_id_fk` (`student_id`),
  KEY `test_record_test_id_fk` (`test_id`),
  CONSTRAINT `test_record_student_id_fk` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
  CONSTRAINT `test_record_test_id_fk` FOREIGN KEY (`test_id`) REFERENCES `test` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `course_management_view`
--

/*!50001 DROP VIEW IF EXISTS `course_management_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `course_management_view` AS select `sp`.`id` AS `course_id`,`sp`.`course_title` AS `course_title`,`sp`.`price` AS `price`,`sp`.`duration_days` AS `duration_days`,`sp`.`description` AS `description`,`sp`.`approval_status` AS `approval_status`,`sp`.`is_active` AS `is_active`,`sp`.`created_at` AS `created_at`,`sp`.`submitted_at` AS `submitted_at`,`sp`.`approved_at` AS `approved_at`,`sp`.`created_by` AS `created_by`,`sp`.`approved_by` AS `approved_by`,`sp`.`rejection_reason` AS `rejection_reason`,`sp`.`allow_edit_after_approval` AS `allow_edit_after_approval`,`g`.`name` AS `grade_name`,`s`.`name` AS `subject_name`,`s`.`id` AS `subject_id`,`g`.`id` AS `grade_id`,`creator`.`full_name` AS `created_by_name`,`approver`.`full_name` AS `approved_by_name`,`img`.`image_data` AS `thumbnail_url`,`sp`.`image_thumbnail_id` AS `image_thumbnail_id`,count(distinct `cc`.`chapter_id`) AS `total_chapters`,count(distinct `cl`.`lesson_id`) AS `total_lessons`,count(distinct `ct`.`test_id`) AS `total_tests` from ((((((((`study_package` `sp` left join `subject` `s` on((`sp`.`subject_id` = `s`.`id`))) left join `grade` `g` on((`s`.`grade_id` = `g`.`id`))) left join `account` `creator` on((`sp`.`created_by` = `creator`.`id`))) left join `account` `approver` on((`sp`.`approved_by` = `approver`.`id`))) left join `image` `img` on((`sp`.`image_thumbnail_id` = `img`.`id`))) left join `course_chapter` `cc` on(((`sp`.`id` = `cc`.`course_id`) and (`cc`.`is_active` = 1)))) left join `course_lesson` `cl` on(((`sp`.`id` = `cl`.`course_id`) and (`cl`.`is_active` = 1)))) left join `course_test` `ct` on(((`sp`.`id` = `ct`.`course_id`) and (`ct`.`is_active` = 1)))) where (`sp`.`type` = 'COURSE') group by `sp`.`id`,`sp`.`course_title`,`sp`.`price`,`sp`.`duration_days`,`sp`.`description`,`sp`.`approval_status`,`sp`.`is_active`,`sp`.`created_at`,`sp`.`submitted_at`,`sp`.`approved_at`,`sp`.`created_by`,`sp`.`approved_by`,`sp`.`rejection_reason`,`sp`.`allow_edit_after_approval`,`g`.`name`,`s`.`name`,`s`.`id`,`g`.`id`,`creator`.`full_name`,`approver`.`full_name`,`img`.`image_data`,`sp`.`image_thumbnail_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `package_assignment_summary`
--

/*!50001 DROP VIEW IF EXISTS `package_assignment_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `package_assignment_summary` AS select `pkg`.`id` AS `package_id`,`pkg`.`name` AS `package_name`,`pkg`.`max_students` AS `max_students_per_parent`,count(distinct `sp`.`parent_id`) AS `total_parents`,count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end)) AS `total_active_assignments`,count(0) AS `total_assignments` from (`study_package` `pkg` left join `student_package` `sp` on((`pkg`.`id` = `sp`.`package_id`))) where (`pkg`.`is_active` = 1) group by `pkg`.`id`,`pkg`.`name`,`pkg`.`max_students` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `parent_package_available_slots`
--

/*!50001 DROP VIEW IF EXISTS `parent_package_available_slots`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `parent_package_available_slots` AS select `pp`.`parent_id` AS `parent_id`,`pp`.`package_id` AS `package_id`,`pkg`.`name` AS `package_name`,sum(`pp`.`max_assignable_students`) AS `total_purchased_slots`,count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end)) AS `currently_assigned`,(sum(`pp`.`max_assignable_students`) - count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end))) AS `available_slots` from ((`package_purchase` `pp` join `study_package` `pkg` on((`pp`.`package_id` = `pkg`.`id`))) left join `student_package` `sp` on((`pp`.`id` = `sp`.`purchase_id`))) where (`pp`.`status` = 'COMPLETED') group by `pp`.`parent_id`,`pp`.`package_id`,`pkg`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `parent_package_management`
--

/*!50001 DROP VIEW IF EXISTS `parent_package_management`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `parent_package_management` AS select `sp`.`id` AS `assignment_id`,`sp`.`parent_id` AS `parent_id`,`sp`.`package_id` AS `package_id`,`sp`.`student_id` AS `student_id`,`sp`.`purchased_at` AS `purchased_at`,`sp`.`expires_at` AS `expires_at`,`sp`.`is_active` AS `is_active`,`pkg`.`name` AS `package_name`,`pkg`.`max_students` AS `max_students`,`pkg`.`price` AS `price`,`s`.`full_name` AS `student_name`,`s`.`username` AS `student_username`,`g`.`name` AS `grade_name`,(case when ((`sp`.`expires_at` > now()) and (`sp`.`is_active` = 1)) then 'ACTIVE' when (`sp`.`expires_at` <= now()) then 'EXPIRED' else 'INACTIVE' end) AS `status`,(to_days(`sp`.`expires_at`) - to_days(now())) AS `days_remaining` from (((`student_package` `sp` join `study_package` `pkg` on((`sp`.`package_id` = `pkg`.`id`))) join `student` `s` on((`sp`.`student_id` = `s`.`id`))) join `grade` `g` on((`s`.`grade_id` = `g`.`id`))) order by `sp`.`purchased_at` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `parent_package_slots`
--

/*!50001 DROP VIEW IF EXISTS `parent_package_slots`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `parent_package_slots` AS select `sp`.`parent_id` AS `parent_id`,`sp`.`package_id` AS `package_id`,`pkg`.`name` AS `package_name`,`pkg`.`max_students` AS `max_students_per_parent`,count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end)) AS `active_assignments`,(`pkg`.`max_students` - count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end))) AS `available_slots` from (`study_package` `pkg` left join `student_package` `sp` on((`pkg`.`id` = `sp`.`package_id`))) where (`pkg`.`is_active` = 1) group by `sp`.`parent_id`,`sp`.`package_id`,`pkg`.`name`,`pkg`.`max_students` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `parent_package_stats`
--

/*!50001 DROP VIEW IF EXISTS `parent_package_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `parent_package_stats` AS select `sp`.`parent_id` AS `parent_id`,`sp`.`package_id` AS `package_id`,`pkg`.`name` AS `package_name`,`pkg`.`max_students` AS `max_per_parent`,count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end)) AS `active_assignments`,count(0) AS `total_assignments`,(`pkg`.`max_students` - count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end))) AS `available_slots` from (`study_package` `pkg` left join `student_package` `sp` on((`pkg`.`id` = `sp`.`package_id`))) where (`pkg`.`is_active` = 1) group by `sp`.`parent_id`,`sp`.`package_id`,`pkg`.`name`,`pkg`.`max_students` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `parent_purchase_history`
--

/*!50001 DROP VIEW IF EXISTS `parent_purchase_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `parent_purchase_history` AS select `pp`.`id` AS `purchase_id`,`pp`.`parent_id` AS `parent_id`,`pp`.`package_id` AS `package_id`,`pp`.`purchase_date` AS `purchase_date`,`pp`.`total_amount` AS `total_amount`,`pp`.`max_assignable_students` AS `max_assignable_students`,`pp`.`status` AS `status`,`pkg`.`name` AS `package_name`,`a`.`full_name` AS `parent_name`,count((case when ((`sp`.`is_active` = 1) and (`sp`.`expires_at` > now())) then 1 end)) AS `students_assigned` from (((`package_purchase` `pp` join `study_package` `pkg` on((`pp`.`package_id` = `pkg`.`id`))) join `account` `a` on((`pp`.`parent_id` = `a`.`id`))) left join `student_package` `sp` on((`pp`.`id` = `sp`.`purchase_id`))) group by `pp`.`id`,`pp`.`parent_id`,`pp`.`package_id`,`pp`.`purchase_date`,`pp`.`total_amount`,`pp`.`max_assignable_students`,`pp`.`status`,`pkg`.`name`,`a`.`full_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `question_with_lesson_info`
--

/*!50001 DROP VIEW IF EXISTS `question_with_lesson_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `question_with_lesson_info` AS select `q`.`id` AS `id`,`q`.`question` AS `question`,`q`.`image_id` AS `image_id`,`q`.`lesson_id` AS `lesson_id`,`q`.`question_type` AS `question_type`,`q`.`is_ai_generated` AS `is_ai_generated`,`q`.`difficulty` AS `difficulty`,`q`.`category` AS `category`,`l`.`name` AS `lesson_name`,`c`.`name` AS `chapter_name`,`s`.`name` AS `subject_name`,`g`.`name` AS `grade_name` from ((((`question` `q` left join `lesson` `l` on((`q`.`lesson_id` = `l`.`id`))) left join `chapter` `c` on((`l`.`chapter_id` = `c`.`id`))) left join `subject` `s` on((`c`.`subject_id` = `s`.`id`))) left join `grade` `g` on((`s`.`grade_id` = `g`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `student_package_access`
--

/*!50001 DROP VIEW IF EXISTS `student_package_access`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `student_package_access` AS select `sp`.`student_id` AS `student_id`,`sp`.`package_id` AS `package_id`,`sp`.`parent_id` AS `parent_id`,`sp`.`purchased_at` AS `purchased_at`,`sp`.`expires_at` AS `expires_at`,`sp`.`is_active` AS `is_active`,`pkg`.`name` AS `package_name`,`pkg`.`type` AS `package_type`,`pkg`.`grade_id` AS `package_grade_id`,(case when ((`sp`.`expires_at` > now()) and (`sp`.`is_active` = 1)) then 1 else 0 end) AS `has_access` from (`student_package` `sp` join `study_package` `pkg` on((`sp`.`package_id` = `pkg`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `test_management_view`
--

/*!50001 DROP VIEW IF EXISTS `test_management_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `test_management_view` AS select `t`.`id` AS `test_id`,`t`.`name` AS `test_name`,`t`.`description` AS `test_description`,`t`.`is_practice` AS `is_practice`,`t`.`duration_minutes` AS `duration_minutes`,`t`.`num_questions` AS `num_questions`,`t`.`test_order` AS `test_order`,`t`.`created_at` AS `created_at`,`t`.`updated_at` AS `updated_at`,`sp`.`id` AS `course_id`,`sp`.`course_title` AS `course_name`,`c`.`id` AS `chapter_id`,`c`.`name` AS `chapter_name`,`s`.`name` AS `subject_name`,`g`.`name` AS `grade_name`,`creator`.`full_name` AS `created_by_name`,count(`tq`.`question_id`) AS `total_questions_assigned` from ((((((`test` `t` left join `study_package` `sp` on((`t`.`course_id` = `sp`.`id`))) left join `chapter` `c` on((`t`.`chapter_id` = `c`.`id`))) left join `subject` `s` on((`sp`.`subject_id` = `s`.`id`))) left join `grade` `g` on((`s`.`grade_id` = `g`.`id`))) left join `account` `creator` on((`t`.`created_by` = `creator`.`id`))) left join `test_question` `tq` on((`t`.`id` = `tq`.`test_id`))) group by `t`.`id`,`t`.`name`,`t`.`description`,`t`.`is_practice`,`t`.`duration_minutes`,`t`.`num_questions`,`t`.`test_order`,`t`.`created_at`,`t`.`updated_at`,`sp`.`id`,`sp`.`course_title`,`c`.`id`,`c`.`name`,`s`.`name`,`g`.`name`,`creator`.`full_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
