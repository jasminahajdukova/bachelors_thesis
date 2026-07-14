-- MySQL dump 10.13  Distrib 9.6.0, for Linux (x86_64)
--
-- Host: localhost    Database: testdb14
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
-- Current Database: `testdb14`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `testdb14` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `testdb14`;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_id` int NOT NULL,
  `product_category_code` varchar(10) DEFAULT NULL,
  `product_name` varchar(150) NOT NULL,
  `product_description` varchar(255) DEFAULT NULL,
  `product_weight` int NOT NULL,
  `calculated_product_cost` decimal(10,2) NOT NULL,
  `product_image_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `product_category_code` (`product_category_code`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`product_category_code`) REFERENCES `product_category` (`product_category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'FRUIT','Honeycrisp Apples','Crisp and sweet premium apples',1,2.50,'honeycrisp_apple.jpg'),(2,'FRUIT','Honeycrisp Apples (Bulk)','Crisp and sweet premium apples bulk bag',5,11.25,'honeycrisp_apple_5lb.jpg'),(3,'FRUIT','Cavendish Bananas','Ripe yellow bananas',1,2.50,'banana_1lb.jpg'),(4,'FRUIT','Organic Strawberries','Sweet red organic strawberries',1,2.50,'strawberry.jpg'),(5,'FRUIT','Navel Oranges','Juicy seedless navel oranges',5,11.25,'navel_orange_5lb.jpg'),(6,'FRUIT','Navel Oranges (Large)','Juicy seedless navel oranges large crate',10,20.00,'navel_orange_10lb.jpg'),(7,'FRUIT','Blueberries','Fresh highbush blueberries',1,2.50,'blueberries_1lb.jpg'),(8,'FRUIT','Red Seedless Grapes','Sweet and crisp red grapes',1,2.50,'red_grapes.jpg'),(9,'FRUIT','Hass Avocados','Creamy green flesh avocados',1,2.50,'avocado.jpg'),(10,'FRUIT','Tommy Atkins Mangoes','Sweet tropical mangoes bag',5,11.25,'mango_5lb.jpg'),(11,'VEG','Russet Potatoes','Perfect baking potatoes',5,8.10,'russet_potato_5lb.jpg'),(12,'VEG','Russet Potatoes (Bulk)','Perfect baking potatoes large sack',10,14.40,'russet_potato_10lb.jpg'),(13,'VEG','Yellow Onions','Sharp cooking onions mesh bag',5,8.10,'yellow_onion_5lb.jpg'),(14,'VEG','Carrots','Sweet orange whole carrots',1,1.80,'carrots_1lb.jpg'),(15,'VEG','Roma Tomatoes','Plum tomatoes for sauces',1,1.80,'roma_tomato.jpg'),(16,'VEG','Broccoli Florets','Fresh green broccoli crowns',1,1.80,'broccoli.jpg'),(17,'VEG','Crisp Iceberg Lettuce','Fresh crunchy head lettuce',1,1.80,'iceberg_lettuce.jpg'),(18,'VEG','Red Bell Peppers','Sweet red slicing peppers',1,1.80,'red_peppers.jpg'),(19,'VEG','Organic Spinach','Tender baby spinach leaves',1,1.80,'baby_spinach.jpg'),(20,'VEG','Celery Stalks','Crisp green celery stalks',1,1.80,'celery.jpg'),(21,'GRAIN','Long Grain White Rice','Enriched white polished rice',5,5.40,'white_rice_5lb.jpg'),(22,'GRAIN','Long Grain White Rice (Bulk)','Enriched white polished rice bulk sack',10,9.60,'white_rice_10lb.jpg'),(23,'GRAIN','Brown Jasmine Rice','Aromatic whole grain brown rice',5,5.40,'brown_jasmine_5lb.jpg'),(24,'GRAIN','Rolled Oats','Old fashioned whole grain oats',1,1.20,'rolled_oats_1lb.jpg'),(25,'GRAIN','Rolled Oats (Bulk)','Old fashioned whole grain oats tub',5,5.40,'rolled_oats_5lb.jpg'),(26,'GRAIN','Organic Quinoa','White premium saponin-free quinoa',1,1.20,'quinoa_1lb.jpg'),(27,'GRAIN','Pearl Barley','Chewy whole grain soup barley',1,1.20,'barley_1lb.jpg'),(28,'GRAIN','Yellow Cornmeal','Stone ground coarse cornmeal',1,1.20,'cornmeal_1lb.jpg'),(29,'GRAIN','Buckwheat Groats','Raw toasted buckwheat hulled kernels',1,1.20,'buckwheat.jpg'),(30,'GRAIN','Wild Rice Blend','Gourmet wild and brown rice mix',1,1.20,'wild_rice.jpg'),(31,'NUTS','Raw Almonds','Whole natural raw almonds',1,6.00,'raw_almonds_1lb.jpg'),(32,'NUTS','Raw Almonds (Bulk)','Whole natural raw almonds family bag',5,27.00,'raw_almonds_5lb.jpg'),(33,'NUTS','Roasted Salted Cashews','Premium jumbo roasted cashews',1,6.00,'salted_cashews.jpg'),(34,'NUTS','Roasted Salted Cashews (Bulk)','Premium jumbo roasted cashews tub',5,27.00,'salted_cashews_5lb.jpg'),(35,'NUTS','English Walnut Halves','Raw natural walnut halves',1,6.00,'walnuts_1lb.jpg'),(36,'NUTS','English Walnut Halves (Bulk)','Raw natural walnut halves large box',10,48.00,'walnuts_10lb.jpg'),(37,'NUTS','Raw Pecan Halves','Rich buttery southern pecan halves',1,6.00,'pecans.jpg'),(38,'NUTS','Shelled Pistachios','Roasted unsalted pistachio kernels',1,6.00,'pistachios.jpg'),(39,'NUTS','Macadamia Nuts','Dry roasted luxury macadamia nuts',1,6.00,'macadamia.jpg'),(40,'NUTS','Raw Brazil Nuts','Whole selenium-rich wild Brazil nuts',1,6.00,'brazil_nuts.jpg'),(41,'BAKE','All-Purpose Flour','Bleached enriched baking flour',5,4.05,'ap_flour_5lb.jpg'),(42,'BAKE','All-Purpose Flour (Bulk)','Bleached enriched baking flour commercial sack',10,7.20,'ap_flour_10lb.jpg'),(43,'BAKE','Granulated White Sugar','Pure cane fine sugar',5,4.05,'white_sugar_5lb.jpg'),(44,'BAKE','Granulated White Sugar (Bulk)','Pure cane fine sugar heavy bag',10,7.20,'white_sugar_10lb.jpg'),(45,'BAKE','Dark Brown Sugar','Pure cane sugar with molasses',1,0.90,'brown_sugar_1lb.jpg'),(46,'BAKE','Powdered Confectioners Sugar','Finely ground icing sugar',1,0.90,'powdered_sugar.jpg'),(47,'BAKE','Whole Wheat Flour','Stone ground 100% whole wheat flour',5,4.05,'whole_wheat_5lb.jpg'),(48,'BAKE','Baking Soda','Pure sodium bicarbonate raising agent',1,0.90,'baking_soda.jpg'),(49,'BAKE','Corn Starch','Pure food-grade thickening powder',1,0.90,'corn_starch.jpg'),(50,'BAKE','Almond Flour','Super-fine blanched gluten-free baking flour',1,0.90,'almond_flour.jpg');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_category`
--

DROP TABLE IF EXISTS `product_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category` (
  `product_category_code` varchar(10) NOT NULL,
  `product_category_description` varchar(255) NOT NULL,
  `cost_per_1_lb` decimal(10,2) NOT NULL,
  `cost_per_5_lb` decimal(10,2) NOT NULL,
  `cost_per_10_lb` decimal(10,2) NOT NULL,
  `eg_fruit_vegetables` varchar(100) NOT NULL,
  PRIMARY KEY (`product_category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_category`
--

LOCK TABLES `product_category` WRITE;
/*!40000 ALTER TABLE `product_category` DISABLE KEYS */;
INSERT INTO `product_category` VALUES ('BAKE','Flour, sugar, and baking essentials',0.90,4.05,7.20,'Baking Supplies'),('FRUIT','Fresh seasonal and exotic fruits',2.50,11.25,20.00,'Fruit'),('GRAIN','Bulk whole grains, rice, and oats',1.20,5.40,9.60,'Grains'),('NUTS','Raw, roasted, and salted nuts',6.00,27.00,48.00,'NUTS'),('VEG','Organic and conventionally grown vegetables',1.80,8.10,14.40,'Vegetables');
/*!40000 ALTER TABLE `product_category` ENABLE KEYS */;
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
