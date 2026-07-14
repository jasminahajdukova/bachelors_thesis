-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb4
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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '1d0e90ad-7f1e-11f1-a597-fe8e1f563f91:1-37';

--
-- Current Database: `testdb4`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb4` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb4`;

--
-- Table structure for table `database_records`
--

DROP TABLE IF EXISTS `database_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `database_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `database_algorithm_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `database_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `database_owner_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `database_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_address` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `other_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `database_records`
--

LOCK TABLES `database_records` WRITE;
/*!40000 ALTER TABLE `database_records` DISABLE KEYS */;
INSERT INTO `database_records` VALUES (1,'Minutiae Matching','National_ID_FPs','Ministry of Interior','Server Room A','Jan Kovac','Hlavna 12, Bratislava','j.kovac@interior.gov.sk','Main national database for citizen identification.'),(2,'Pattern Recognition','Border_Control_DB','Customs Office','Cloud Region Europe','Maria Horvathova','Letisko, Kosice','m.horvath@customs.sk','Used for airport border control checks.'),(3,'Deep Learning CNN','Research_Dataset_v2','Technical University','Lab 403 Storage','Peter Malik','Ilkovicova 3, Bratislava','peter.malik@stuba.sk','Academic research database, anonymous samples.'),(4,'Minutiae Matching','Corporate_Access_DB','Secure Tech Corp','On-Premises Server','John Doe','Tech Street 5, Zilina','j.doe@securetech.com','Employee access control for high-security zones.'),(5,'Wavelet Transform','Banking_Auth_Cloud','Global Bank IS','AWS Frankfurt','Anna Novakova','Mlynska Nivy, Bratislava','novakova@globalbank.com','Biometric login data for mobile banking application.'),(6,'Minutiae Matching','Police_Criminal_Records','Police HQ','Secure Vault B','Stefan Repka','Pribinova 2, Presov','s.repka@police.sk','Restricted access, criminal investigation records.'),(7,'Deep Learning CNN','SmartLock_User_DB','HomeAutomation Ltd','Azure West Europe','Lukas Svoboda','Kollarova 8, Trnava','l.svoboda@homeauto.sk','IoT smart lock backup registry.'),(8,'Pattern Recognition','Military_Base_Access','Ministry of Defence','Underground Bunker','Major Milan Ruzicka','Vojenska 1, Trencin','milan.ruzicka@mod.gov.sk','Top secret access clearance database.'),(9,'Minutiae Matching','Gym_Members_FPs','Fitness City','Local PC-Database','Eva Szaboova','Okruzna 44, Nitra','info@fitcity.sk','Membership verification for gym entries.'),(10,'Ridge Frequency','Gov_Logistics_Track','Postal Services','Data Center Central','Tomas Beranek','Postova 1, Banska Bystrica','t.beranek@skposta.sk','Driver authentication system for high-value cargo.'),(11,'Minutiae Matching','University_Exam_Check','University of Zilina','Server Room 2','Prof. Igor Janci','Univerzitna 1, Zilina','igor.janci@uniza.sk','Student attendance validation for final exams.'),(12,'Deep Learning CNN','AI_Trainer_Set_Large','Vision AI Labs','GPU Cluster Local','Dr. Alex Mercer','Science Park, Martin','mercer@visionailabs.com','Massive training set for neural network calibration.'),(13,'Pattern Recognition','Hospital_Staff_Auth','St. Michael Hospital','Internal Server Block','Katarina Liptakova','Satinskeho 1, Bratislava','k.liptakova@nsm.sk','Access control to drug storage rooms.'),(14,'Minutiae Matching','Automotive_Start_DB','CarTech Slovakia','Embedded Flash Memo','Jozef Marecek','Priemyselna Zona, Trnava','j.marecek@cartech.sk','Biometric ignition systems for luxury car line.'),(15,'Wavelet Transform','Airport_Staff_Secure','Bratislava Airport','Main Terminal Server','Robert Nemec','Ivanska cesta, Bratislava','r.nemec@bts.aero','Ground crew and pilot biometric verification.'),(16,'Minutiae Matching','School_Attendance_Syst','Gymnazium Kukucinova','Principal Office PC','Elena Vrbova','Kukucinova 12, Poprad','vrbova@gympoprad.sk','Pilot project for student attendance monitoring.'),(17,'Ridge Frequency','Casino_VIP_Registry','Royal Casino Group','Offshore Cloud','Marcello Silva','Vodna 2, Komarno','m.silva@royalcasino.com','VIP client identification and loyalty system.'),(18,'Deep Learning CNN','Customs_Cargo_Drivers','Financial Administration','HQ Server Room','Ivan Drabek','Mierova 23, Bratislava','ivan.drabek@fs.sk','Verification of international cargo drivers.'),(19,'Minutiae Matching','DataCenter_Biometrics','Telco Cloud Europe','Rack 14-A Room 1','Gabriel Kiss','Sturova 5, Dunajska Streda','g.kiss@telcocloud.sk','Physical access logs for server housing clients.'),(20,'Pattern Recognition','Hotel_Smart_CheckIn','Resort Paradiso','Cloud Database','Lucia Blahova','Tatranska 100, Strbske Pleso','l.blahova@paradiso.sk','Self-service biometric kiosk registrations.');
/*!40000 ALTER TABLE `database_records` ENABLE KEYS */;
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
