-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb8
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
-- Current Database: `testdb8`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb8` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb8`;

--
-- Table structure for table `company_customers`
--

DROP TABLE IF EXISTS `company_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_customers` (
  `customer_id` int NOT NULL,
  `company_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `credit_score` int NOT NULL,
  `date_credit_score_reviewed` date NOT NULL,
  `date_credit_class_reviewed` date NOT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_customers`
--

LOCK TABLES `company_customers` WRITE;
/*!40000 ALTER TABLE `company_customers` DISABLE KEYS */;
INSERT INTO `company_customers` VALUES (1,'TechLogix s.r.o.','421905123456',750,'2026-01-15','2026-01-15'),(2,'EuroTrade Slovakia a.s.','421911234567',620,'2026-02-10','2026-02-11'),(3,'AutoServis Jn & synovia','421948345678',450,'2025-11-20','2025-11-20'),(4,'Alpha Developer Group','421903456789',820,'2026-03-01','2026-03-02'),(5,'BioFoods Distribution','421915567890',580,'2026-01-22','2026-01-22'),(6,'StavbaTrend ilina','421907678901',690,'2026-04-05','2026-04-05'),(7,'EcoEnergy Solutions','421944789012',710,'2026-02-18','2026-02-20'),(8,'Logistika Tatry d.o.o.','421910890123',500,'2025-12-15','2025-12-15'),(9,'Kreatvna Agentra Pixel','421902901234',780,'2026-05-12','2026-05-12'),(10,'Prvne Sluby Partneri','421918012345',850,'2026-03-30','2026-04-01'),(11,'MetalKov Koice','421905223344',640,'2026-01-08','2026-01-10'),(12,'Kaviare a Praiare s.r.o.','421911334455',530,'2026-02-27','2026-02-27'),(13,'Zhradn Centrum Garden','421948445566',600,'2026-04-14','2026-04-15'),(14,'MediCura Poliklinika','421903556677',790,'2026-05-20','2026-05-20'),(15,'SmartHome Security','421915667788',720,'2026-01-19','2026-01-20'),(16,'Drevovroba Hron','421907778899',410,'2025-10-05','2025-10-05'),(17,'NextGen Telco a.s.','421944889900',880,'2026-03-11','2026-03-11'),(18,'Mdny Svet E-shop','421910990011',660,'2026-02-04','2026-02-04'),(19,'STK a Emisn Kontroly','421902112233',570,'2026-04-22','2026-04-22'),(20,'Consulting & Tax Slovakia','421918223344',800,'2026-05-02','2026-05-03'),(21,'Pekre Krka','421905334455',490,'2025-12-18','2025-12-20'),(22,'CleanStart Upratovac Servis','421911445566',610,'2026-01-30','2026-01-30'),(23,'Farma GreenValley','421948556677',670,'2026-03-17','2026-03-17'),(24,'IT Core Systems','421903667788',760,'2026-04-29','2026-04-30'),(25,'Hotel Panorma Tatry','421915778899',700,'2026-02-14','2026-02-15');
/*!40000 ALTER TABLE `company_customers` ENABLE KEYS */;
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
