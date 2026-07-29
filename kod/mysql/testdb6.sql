-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb6
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


--
-- Current Database: `testdb6`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb6` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb6`;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `address_id` int NOT NULL,
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cell_mobile_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_address` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_first_rental` date NOT NULL,
  `date_left_university` date DEFAULT NULL,
  `other_student_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,1001,'Luk','Peter','Horvth','421905111222','lukas.horvath@stud.uniba.sk','2024-09-01',NULL,'Active Erasmus coordinator.'),(2,1002,'Michala',NULL,'Kovov','421911133344','michaela.kovacova@stud.uniba.sk','2023-02-15','2026-05-30','Graduated with honors, keys returned.'),(3,1003,'Martin','Jn','Molnr','421948555666','martin.molnar@stud.tuke.sk','2025-09-05',NULL,'Accommodated in Block B, room 302.'),(4,1004,'Zuzana',NULL,'Tthov','421903777888','zuzana.toth@stud.uniza.sk','2024-10-01',NULL,'Requires parking slot near dormitory.'),(5,1005,'John','Robert','Smith','447123456789','john.smith@exchange.sk','2025-09-01','2026-02-10','Foreign exchange student from the UK.'),(6,1006,'Tom',NULL,'Varga','421915999000','tomas.varga@stud.stuba.sk','2022-09-01',NULL,'Doctoral student, prolonged rental contract.'),(7,1007,'Katarna','Mria','evkov','421907222333','katarina.s@stud.ukf.sk','2025-01-10',NULL,'No issues reported, standard contract.'),(8,1008,'Patrik',NULL,'Nagy','421944444555','patrik.nagy@stud.tuke.sk','2023-09-01','2025-06-15','Left university after Bachelor state exams.'),(9,1009,'Simona',NULL,'Krajrov','421910888999','simona.k@stud.truni.sk','2024-09-02',NULL,'Dormitory council member.'),(10,1010,'Dvid','Alex','Bal','421902111555','david.balaz@stud.uniba.sk','2025-09-15',NULL,'Late registration due to medical reasons.'),(11,1011,'Aneta',NULL,'Blahov','421918333222','aneta.b@stud.uniza.sk','2024-02-20',NULL,'Subletting approved for summer holidays.'),(12,1012,'Matej','Filip','Kuera','421905666777','matej.kucera@stud.stuba.sk','2023-09-01','2026-06-01','Completed Master degree.'),(13,1013,'Lucia',NULL,'Malkov','421911444888','lucia.m@stud.upjs.sk','2025-09-01',NULL,'Requesting room change for next semester.'),(14,1014,'Oliver',NULL,'Rusnk','421949111000','oliver.rusnak@stud.umb.sk','2024-09-01',NULL,'Sports scholarship recipient.'),(15,1015,'Veronika','Eva','Feketeov','421903222999','veronika.f@stud.ukf.sk','2025-10-05',NULL,'First year student, accommodation granted.');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
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

-- Dump completed on 2026-07-14  1:19:05
