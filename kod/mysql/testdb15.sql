-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb15
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
-- Current Database: `testdb15`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb15` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb15`;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `account_id` int NOT NULL,
  `customer_id` int DEFAULT NULL,
  `date_account_opened` date NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `other_account_details` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`account_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,1,'2026-01-15','Alice Smith Primary','Checking and loyalty rewards activated'),(2,2,'2026-02-20','Bob Jones Business','Commercial line of credit approved'),(3,3,'2026-03-05','Charlie Brown Personal','Standard personal credit ledger profile'),(4,4,'2026-04-12','Diana Prince Corporate','Corporate expense account framework linked'),(5,5,'2026-05-18','Evan Wright Standard','Default store credit monitoring profile');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL,
  `customer_first_name` varchar(50) NOT NULL,
  `customer_middle_initial` char(1) DEFAULT NULL,
  `customer_last_name` varchar(50) NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `email_address` varchar(100) DEFAULT NULL,
  `login_name` varchar(50) DEFAULT NULL,
  `login_password` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address_line_1` varchar(150) DEFAULT NULL,
  `address_line_2` varchar(150) DEFAULT NULL,
  `address_line_3` varchar(150) DEFAULT NULL,
  `address_line_4` varchar(150) DEFAULT NULL,
  `town_city` varchar(100) DEFAULT NULL,
  `state_county_province` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `other_details` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Alice','M','Smith','Female','alice@email.com','asmith99','pass123','555-0101','123 Main St','Apt 4B',NULL,NULL,'New York','NY','USA','Preferred buyer program'),(2,'Bob','J','Jones','Male','bob@email.com','bjones22','secure456','555-0102','456 Oak Ave',NULL,NULL,NULL,'Los Angeles','CA','USA','Standard customer tier'),(3,'Charlie','K','Brown','Male','charlie@email.com','cbrown33','pass789','555-0103','789 Pine Rd','Floor 2',NULL,NULL,'Chicago','IL','USA','Subscribed to newsletters'),(4,'Diana','L','Prince','Female','diana@email.com','dprint44','wonder88','555-0104','321 Elm Blvd',NULL,NULL,NULL,'Miami','FL','USA','VIP premium member'),(5,'Evan','R','Wright','Male','evan@email.com','ewright55','wright99','555-0105','654 Maple Dr',NULL,NULL,NULL,'Seattle','WA','USA','Requires text notifications');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `customer_id` int DEFAULT NULL,
  `date_order_placed` date NOT NULL,
  `order_details` varchar(255) NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'2026-06-01','1x Wireless Headphones, 2x Charging Cables'),(2,1,'2026-06-15','1x Ergonomic Office Chair'),(3,2,'2026-06-03','5x Mechanical Keyboard Kits for office setup'),(4,4,'2026-06-10','1x UltraWide Monitor 34-inch, 1x Monitor Stand'),(5,5,'2026-06-12','1x Bluetooth Speaker, 1x Portable Power Bank');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
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
