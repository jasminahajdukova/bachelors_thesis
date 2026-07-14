-- extreme_numeric
-- Mechanism: DECIMAL(10,2) and FLOAT columns target the documented
--   finterval defect (z3 Real -> rational fractions incompatible with
--   MySQL DECIMAL); INT UNSIGNED exercises fix_db_type normalization
--   ('int(10) unsigned') on a live extraction path.
-- Expectation: L3 failures on decimal/float columns classified
--   dataster_finterval_fraction (Dataster-attributable, excluded by
--   L3_ADJUSTED); unsigned column type string normalized correctly
--   in samples.

DROP DATABASE IF EXISTS testdb21;
CREATE DATABASE testdb21 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb21;

DROP TABLE IF EXISTS `items`;

CREATE TABLE `items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `unit_price` decimal(10,2) NOT NULL,
  `weight` float NOT NULL,
  `stock_count` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `items` (`id`,`unit_price`,`weight`,`stock_count`) VALUES
(1,19.99,0.25,120),
(2,4.50,1.10,4000),
(3,129.00,12.75,15),
(4,0.99,0.05,999),
(5,55.25,3.40,230),
(6,310.10,25.00,8),
(7,7.77,0.68,1500),
(8,42.00,5.55,64),
(9,88.60,9.99,310),
(10,15.35,2.05,72);
