-- extreme_smt
-- Mechanism: PK spans 1..50 (seq-derived generate count = 50) while
--   non-PK columns have tiny value ranges (rating 1..3, flag 0..1,
--   Cartesian product = 6 < 50). Targets the documented Dataster
--   SMT uniqueness failure (generator.py:96-106).
-- Expectation: L1 pass, L2 FAIL classified as dataster_smt_count
--   (Dataster-attributable). This database is SUPPOSED to fail L2;
--   its value is verifying the failure classification.
DROP DATABASE IF EXISTS testdb22;
CREATE DATABASE testdb22 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb22;


DROP TABLE IF EXISTS `slots`;

CREATE TABLE `slots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rating` int NOT NULL,
  `flag` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `slots` (`id`,`rating`,`flag`) VALUES
(1,1,0),
(5,2,1),
(10,3,0),
(15,1,1),
(20,2,0),
(25,3,1),
(30,1,0),
(35,2,1),
(40,3,0),
(45,1,1),
(50,2,0);
