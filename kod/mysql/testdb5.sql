-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb5
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
-- Current Database: `testdb5`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb5` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb5`;

--
-- Table structure for table `victims`
--

DROP TABLE IF EXISTS `victims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `victims` (
  `victim_id` int NOT NULL AUTO_INCREMENT,
  `victim_status_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_first_suspected` date NOT NULL,
  `date_confirmed` date DEFAULT NULL,
  `date_of_death` date DEFAULT NULL,
  `other_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`victim_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `victims`
--

LOCK TABLES `victims` WRITE;
/*!40000 ALTER TABLE `victims` DISABLE KEYS */;
INSERT INTO `victims` VALUES (1,'CONFIRMED','John','Kofi','Mensah','72 High Street, Accra','2026-01-10','2026-01-12',NULL,'Patient in isolation unit, showing signs of recovery.'),(2,'DECEASED','Amara',NULL,'Camara','Conakry Outskirts Block B','2026-01-15','2026-01-16','2026-01-20','Deceased upon arrival at the red zone clinic.'),(3,'SUSPECTED','Moussa','Alhassan','Diallo','Bo Town, Sector 3','2026-02-01',NULL,NULL,'Family member was confirmed positive. Awaiting lab results.'),(4,'RECOVERED','Fatoumata',NULL,'Bah','Kenema Highway 14','2026-01-05','2026-01-07',NULL,'Discharged after two consecutive negative PCR tests.'),(5,'DECEASED','Samuel','Tamba','Bangura','Koidu Village','2026-02-10','2026-02-11','2026-02-15','Funeral conducted under safe biological protocols.'),(6,'CONFIRMED','Zainab','Sheriff','Kamara','Makeni Central','2026-02-18','2026-02-20',NULL,'Currently undergoing experimental antibody treatment.'),(7,'SUSPECTED','Ibrahim',NULL,'Sow','Labe District','2026-03-01',NULL,NULL,'Presented with high fever and joint pain. Isolated at home.'),(8,'RECOVERED','Kwame','Osei','Appiah','Kumasi Market Area','2025-12-20','2025-12-22',NULL,'Antibodies present, plasma donation requested.'),(9,'DECEASED','Marie','Claire','Loua','Nzerekore Route 4','2026-03-05','2026-03-06','2026-03-09','Epidemiological link to the initial index case cluster.'),(10,'CONFIRMED','Abubakarr',NULL,'Jalloh','Waterloo Camp, Freetown','2026-03-12','2026-03-13',NULL,'Transferred from community health post.'),(11,'SUSPECTED','Efe','Godwin','Okoro','Benin City bypass','2026-04-02',NULL,NULL,'Travel history to affected border region.'),(12,'DECEASED','Sia','Finda','Kondo','Yengema Road','2026-03-20','2026-03-22','2026-03-27','Advanced stage hemorrhagic symptoms recorded.'),(13,'CONFIRMED','Sekou',NULL,'Traore','Macenta Center','2026-04-10','2026-04-11',NULL,'Stable vital signs, receiving intensive hydration.'),(14,'RECOVERED','Amina','Yusuf','Bello','Kano Ward 5','2026-02-25','2026-02-27',NULL,'Full clinical recovery documented by field team.'),(15,'SUSPECTED','David','Kojo','Turay','Lungi Airport Area','2026-05-15',NULL,NULL,'Flagged at thermal screening checkpoint with elevated temp.');
/*!40000 ALTER TABLE `victims` ENABLE KEYS */;
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
