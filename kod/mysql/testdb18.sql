-- extreme_fk_chain
-- Mechanism: FK chain regions -> warehouses -> shipments -> packages
--   (depth 4) plus audits with FKs to two different parents (breadth).
-- Expectation: sort_tables_multi_level orders generation correctly;
--   FROM cascade resolves; L3 completes without fk_violation.
DROP DATABASE IF EXISTS testdb18;
CREATE DATABASE testdb18 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb18;

DROP TABLE IF EXISTS `audits`;
DROP TABLE IF EXISTS `packages`;
DROP TABLE IF EXISTS `shipments`;
DROP TABLE IF EXISTS `warehouses`;
DROP TABLE IF EXISTS `regions`;

CREATE TABLE `regions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `regions` (`id`,`name`) VALUES
(1,'North'),(2,'South'),(3,'East'),(4,'West');

CREATE TABLE `warehouses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `region_id` int NOT NULL,
  `capacity` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_wh_region` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `warehouses` (`id`,`region_id`,`capacity`) VALUES
(1,1,500),(2,1,800),(3,2,300),(4,3,1200),(5,4,650),(6,2,450);

CREATE TABLE `shipments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `warehouse_id` int NOT NULL,
  `shipped_on` date NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sh_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `shipments` (`id`,`warehouse_id`,`shipped_on`) VALUES
(1,1,'2024-01-10'),(2,2,'2024-01-12'),(3,3,'2024-01-15'),(4,4,'2024-01-18'),
(5,5,'2024-01-20'),(6,6,'2024-01-22'),(7,1,'2024-01-25'),(8,4,'2024-01-28');

CREATE TABLE `packages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shipment_id` int NOT NULL,
  `weight_kg` decimal(6,2) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pk_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `packages` (`id`,`shipment_id`,`weight_kg`) VALUES
(1,1,12.50),(2,1,3.20),(3,2,45.00),(4,3,7.75),(5,4,120.10),
(6,5,0.80),(7,6,15.60),(8,7,22.40),(9,8,9.90),(10,8,31.05);

CREATE TABLE `audits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `region_id` int NOT NULL,
  `shipment_id` int NOT NULL,
  `passed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_au_region` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`),
  CONSTRAINT `fk_au_shipment` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `audits` (`id`,`region_id`,`shipment_id`,`passed`) VALUES
(1,1,1,1),(2,2,3,0),(3,3,4,1),(4,4,5,1),(5,1,7,0),(6,2,6,1);
