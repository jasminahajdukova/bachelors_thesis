-- extreme_messy
-- Mechanism (three cheap, independent ones in one DB):
--   1. CamelCase table and column names -> case-insensitive
--      reconciliation (go_over_found_columns) on a live path.
--   2. NULL-heavy column (Notes: 7 of 10 NULL) -> UNION sampling
--      WHERE IS NOT NULL under real NULL pressure.
--   3. Two-distinct-value column (IsActive) -> low-cardinality
--      degradation of the UNION sample.
-- Expectation: schema/types sections use correct original casing;
--   samples for Notes contain no None; IsActive sample has exactly
--   two values; L1-L3 pass.

DROP DATABASE IF EXISTS testdb20;
CREATE DATABASE testdb20 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb20;

DROP TABLE IF EXISTS `CustomerOrders`;

CREATE TABLE `CustomerOrders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `CustomerName` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `Notes` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `CustomerOrders` (`OrderID`,`CustomerName`,`IsActive`,`Notes`) VALUES
(1,'Alfa s.r.o.',1,NULL),
(2,'Beta a.s.',0,'priority customer'),
(3,'Gamma spol.',1,NULL),
(4,'Delta plus',1,NULL),
(5,'Epsilon trade',0,NULL),
(6,'Zeta group',1,'requires invoice'),
(7,'Eta market',1,NULL),
(8,'Theta shop',0,NULL),
(9,'Iota store',1,'pickup only'),
(10,'Kappa retail',1,NULL);
