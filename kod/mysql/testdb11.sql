-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb11
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
-- Current Database: `testdb11`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb11` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb11`;

--
-- Table structure for table `Addresses`
--

DROP TABLE IF EXISTS `Addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Addresses` (
  `Address_ID` int NOT NULL,
  `City_Name` varchar(100) NOT NULL,
  `Line_1` varchar(255) NOT NULL,
  `Line_2` varchar(100) DEFAULT NULL,
  `Line_3` varchar(100) DEFAULT NULL,
  `City_Code` varchar(10) DEFAULT NULL,
  `Region_Code` varchar(10) DEFAULT NULL,
  `ZIP_Code` varchar(20) DEFAULT NULL,
  `State` varchar(100) DEFAULT NULL,
  `Country` varchar(100) DEFAULT NULL,
  `Other_Details` text,
  PRIMARY KEY (`Address_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Addresses`
--

LOCK TABLES `Addresses` WRITE;
/*!40000 ALTER TABLE `Addresses` DISABLE KEYS */;
INSERT INTO `Addresses` VALUES (1,'New York','123 Broadway','Suite 400',NULL,'NYC','NY','10001','NY','USA','Commercial zone'),(2,'Los Angeles','555 Sunset Blvd',NULL,NULL,'LA','CA','90028','CA','USA','Near medical center'),(3,'Chicago','789 Michigan Ave','Floor 2',NULL,'CHI','IL','60611','IL','USA','Downtown location'),(4,'Houston','321 Texas St',NULL,NULL,'HOU','TX','77002','TX','USA','24/7 access parking'),(5,'Phoenix','654 Camelback Rd','Apt B',NULL,'PHX','AZ','85016','AZ','USA','Strip mall location'),(6,'Miami','990 Medical Plaza Way','Suite 10A',NULL,'MIA','FL','33101','FL','USA','Large multi-tenant medical complex'),(7,'Seattle','456 Pine St','Floor 1',NULL,'SEA','WA','98101','WA','USA','Located in busy downtown transit corridor'),(8,'Austin','1200 Congress Ave',NULL,NULL,'AUS','TX','78701','TX','USA','Standalone building with a dedicated drive-thru lane'),(9,'Boston','77 Massachusetts Ave','Room 3-100',NULL,'BOS','MA','02139','MA','USA','University campus health center branch'),(10,'Denver','888 Colfax Ave','Suite C',NULL,'DEN','CO','80202','CO','USA','Directly across from the public park'),(11,'Toronto','456 Yonge St','Unit 4',NULL,'TOR','ON','M4Y 1W9','Ontario','Canada','Multi-lingual staff onsite'),(12,'London','10-12 Piccadilly',NULL,NULL,'LON','ENG','W1J 0DA','Greater London','UK','Central London high street storefront'),(13,'Chicago','55 East Washington St','Suite 1200',NULL,'CHI','IL','60602','IL','USA','Located inside a high-rise medical office building'),(14,'San Francisco','801 Portola Dr','Suite 101',NULL,'SF','CA','94127','CA','USA','Neighborhood shopping center location'),(15,'Atlanta','201 Dowman Dr',NULL,NULL,'ATL','GA','30322','GA','USA','Located within the university medical wing');
/*!40000 ALTER TABLE `Addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pharmacies`
--

DROP TABLE IF EXISTS `Pharmacies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pharmacies` (
  `Pharmacy_ID` int NOT NULL,
  `Address_ID` int NOT NULL,
  `Pharmacy_Name` varchar(255) NOT NULL,
  `Pharmacy_Description` text,
  `Other_Details` text,
  PRIMARY KEY (`Pharmacy_ID`),
  KEY `Address_ID` (`Address_ID`),
  CONSTRAINT `Pharmacies_ibfk_1` FOREIGN KEY (`Address_ID`) REFERENCES `Addresses` (`Address_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pharmacies`
--

LOCK TABLES `Pharmacies` WRITE;
/*!40000 ALTER TABLE `Pharmacies` DISABLE KEYS */;
INSERT INTO `Pharmacies` VALUES (1,1,'CVS Pharmacy #102','Main downtown branch with drive-thru','Open 24 hours'),(2,2,'Walgreens Healthcare','Located next to City General Hospital','Accepts all major insurance'),(3,3,'Michigan Ave Pharmacy','Independent local community pharmacy','Offers free home delivery'),(4,4,'Rite Aid Express','Small format pharmacy focusing on prescriptions','Closed on Sundays'),(5,5,'WellCare Pharmacy','Specialized compound pharmacy','Compounding lab on site'),(6,6,'CareFirst Pharmacy','Specializes in senior care and prescription management','Offers automated monthly refills'),(7,6,'Plaza Medical Supplies & RX','Dual-purpose medical supply shop and pharmacy sharing the plaza space','Stocks durable medical equipment'),(8,7,'Emerald City Rx','Eco-friendly independent pharmacy focused on holistic wellness','Curbside pickup available'),(9,8,'Lone Star Drugs','Historic local pharmacy serving the downtown area since 1995','Features an old-fashioned soda fountain counter'),(10,9,'Campus Health Pharmacy','On-campus pharmacy offering student and faculty discounts','Requires valid university ID for discounts'),(11,11,'Maple Leaf Pharmacy','Full-service pharmacy offering provincial health plan billing','Flu shots available without appointment'),(12,12,'Boots Pharmacy Express','High-volume city center chemist and beauty retailer','Accepts NHS electronic prescriptions'),(13,13,'Loop Medical Pharmacy','Specialized pharmacy handling complex biologic medications','Coordinates directly with the specialty clinics upstairs'),(14,14,'Twin Peaks Rx','Family-owned independent drugstore serving the local community','Offers free delivery within a 5-mile radius'),(15,15,'Eagle Student Health Rx','Institutional pharmacy catering to university student prescriptions','Stocks low-cost generic alternatives and student health packs');
/*!40000 ALTER TABLE `Pharmacies` ENABLE KEYS */;
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

-- Dump completed on 2026-07-14  3:36:00
