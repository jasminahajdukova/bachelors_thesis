-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb12
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '1d0e90ad-7f1e-11f1-a597-fe8e1f563f91:1-80';

--
-- Current Database: `testdb12`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb12` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb12`;

--
-- Table structure for table `Authors_Tutors`
--

DROP TABLE IF EXISTS `Authors_Tutors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Authors_Tutors` (
  `author_id` int NOT NULL,
  `author_tutor_ATB` varchar(20) NOT NULL,
  `login_name` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `personal_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `family_name` varchar(100) NOT NULL,
  `gender_mf` char(1) DEFAULT NULL,
  `address_line_1` varchar(255) DEFAULT NULL,
  `address_line_2` varchar(100) DEFAULT NULL,
  `address_line_3` varchar(100) DEFAULT NULL,
  `other_details` text,
  PRIMARY KEY (`author_id`),
  UNIQUE KEY `login_name` (`login_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Authors_Tutors`
--

LOCK TABLES `Authors_Tutors` WRITE;
/*!40000 ALTER TABLE `Authors_Tutors` DISABLE KEYS */;
INSERT INTO `Authors_Tutors` VALUES (1,'Author','jdoe_write','hash_p@ss1','John','Alan','Doe','M','123 Quill Ln','Edmond','OK','Expert in Python programming'),(2,'Tutor','msmith_teach','hash_p@ss2','Mary','Lynn','Smith','F','456 Learn Ave','Boston','MA','Available for evening web development sessions'),(3,'Both','rjohnson_edu','hash_p@ss3','Robert','Edward','Johnson','M','789 Academy Rd','Austin','TX','Data Science professor and course designer'),(4,'Author','edavis_books','hash_p@ss4','Emily','Grace','Davis','F','321 Scholar St','Denver','CO','Specializes in introductory statistics algorithms'),(5,'Tutor','mbrown_tutor','hash_p@ss5','Michael','Scott','Brown','M','654 Campus Way','Seattle','WA','Focuses exclusively on calculus bootcamps'),(6,'Both','agarcia_prof','hash_p@ss6','Ana','Maria','Garcia','F','111 Matrix Blvd','Miami','FL','Teaches Machine Learning & Neural Networks'),(7,'Author','dwilson_code','hash_p@ss7','David','James','Wilson','M','222 Logic Dr','San Jose','CA','Former software engineer writing backend guides'),(8,'Tutor','lmartinez_ed','hash_p@ss8','Linda','Rose','Martinez','F','333 Binary Ct','Phoenix','AZ','Handles intro to JavaScript logic labs'),(9,'Both','janderson_ai','hash_p@ss9','James','Arthur','Anderson','M','444 Algorithm Rd','Chicago','IL','AI researcher publishing advanced NLP courses'),(10,'Author','ttaylor_hist','hash_p@ss10','Thomas','Henry','Taylor','M','555 Archive Way','Boston','MA','Curating historical data visualization syllabi'),(11,'Tutor','sthomas_dev','hash_p@ss11','Sarah','Jane','Thomas','F','666 Cloud Ln','Atlanta','GA','Cloud infrastructure remote workshop lab leader'),(12,'Both','mmoore_cyber','hash_p@ss12','Matthew','David','Moore','M','777 Security Pl','Dallas','TX','Certified ethical hacker publishing security courses'),(13,'Author','jjackson_ux','hash_p@ss13','Jessica','Ann','Jackson','F','888 Design St','New York','NY','UI/UX layout textbook editor and designer'),(14,'Tutor','cmartin_sql','hash_p@ss14','Charles','Lee','Martin','M','999 Query Ave','Portland','OR','Runs interactive relational database clinics'),(15,'Both','alee_mobile','hash_p@ss15','Amanda','Choi','Lee','F','101 App Dr','Los Angeles','CA','Mobile app framework creator and bootcamp runner');
/*!40000 ALTER TABLE `Authors_Tutors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Courses` (
  `course_id` int NOT NULL,
  `author_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `course_description` text,
  `other_details` text,
  PRIMARY KEY (`course_id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `Courses_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `Authors_Tutors` (`author_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Courses`
--

LOCK TABLES `Courses` WRITE;
/*!40000 ALTER TABLE `Courses` DISABLE KEYS */;
INSERT INTO `Courses` VALUES (1,1,101,'Python Fundamentals','Master the basics of variables, loops, and data structures.','Includes 12 coding assignments'),(2,1,101,'Object-Oriented Python','Intermediate study deep diving into classes, objects, and inheritance.','Requires completion of Fundamentals'),(3,3,102,'Data Analytics with Pandas','Learn how to clean, slice, and massage big datasets seamlessly.','Uses Jupyter Notebook environments'),(4,3,102,'Introduction to Data Science','High-level conceptual overview of machine learning algorithms.','Math heavy module'),(5,4,103,'Applied Statistics I','Covers normal distributions, z-scores, and hypothesis testing.','Includes statistical software labs'),(6,6,102,'Deep Learning Frameworks','Hands-on network design focusing on computer vision.','Requires Python mastery'),(7,6,102,'Natural Language Processing Masterclass','Building transformers and text classification algorithms from scratch.','Advanced tier course'),(8,7,101,'Backend Systems in Go','Architecting highly-performant, concurrent API frameworks.','Production-focused code setups'),(9,7,101,'Docker & Kubernetes Deployments','Containerization fundamentals for building scaling modern apps.','DevOps track core requirement'),(10,9,102,'AI Ethics and Corporate Governance','Analyzing societal biases built directly into dataset sampling models.','Reading intensive seminar format'),(11,10,104,'Data Mapping Through History','Plotting socio-economic change over centuries utilizing GIS mapping software.','Cross-listed with humanities'),(12,12,105,'Ethical Hacking 101','Introduction to penetration testing methodologies and toolsets.','Requires sandbox network setup'),(13,12,105,'Defensive Architecture Design','Hardening enterprise Linux servers against common OWASP vulnerabilities.','Includes practical firewall labs'),(14,13,106,'Figma Prototyping Basics','Wireframing components and constructing responsive UI/UX screen flows.','No programming background required'),(15,15,101,'iOS Swift App Foundations','Building native applications leveraging modern declarative SwiftUI code.','Requires access to macOS machine');
/*!40000 ALTER TABLE `Courses` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-14  3:36:01
