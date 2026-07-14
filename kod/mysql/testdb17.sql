-- extreme_constraints
-- Mechanism: columns with natural inter-column and value constraints
--   (date pair pickup<=return, numeric pair min<max, positive rate,
--   categorical status, bounded age).
-- Expectation: constraints stage has material to infer relational
--   constraints; validator accepts them; L3 inserts respect bounds.
-- Note: column names deliberately differ from Modelfile few-shot
--   examples (order_date/delivery_date, min_stock_level) to measure
--   inference, not memorization.
DROP DATABASE IF EXISTS testdb17;
CREATE DATABASE testdb17 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb17;

DROP TABLE IF EXISTS `rentals`;
DROP TABLE IF EXISTS `equipment`;

CREATE TABLE `equipment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `daily_rate` decimal(8,2) NOT NULL,
  `min_capacity` int NOT NULL,
  `max_capacity` int NOT NULL,
  `condition_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `equipment` (`id`,`name`,`daily_rate`,`min_capacity`,`max_capacity`,`condition_status`) VALUES
(1,'Excavator XS',120.50,1,3,'available'),
(2,'Crane T40',540.00,2,8,'maintenance'),
(3,'Loader L2',210.75,1,4,'available'),
(4,'Drill D9',45.20,1,2,'retired'),
(5,'Mixer M3',88.00,1,5,'available'),
(6,'Scaffold S1',30.00,2,12,'available'),
(7,'Generator G5',150.30,1,6,'maintenance'),
(8,'Compressor C2',95.90,1,4,'available'),
(9,'Forklift F8',310.00,2,6,'available'),
(10,'Pump P1',60.45,1,3,'retired');

CREATE TABLE `rentals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `renter_age` int NOT NULL,
  `pickup_date` date NOT NULL,
  `return_date` date NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `rentals` (`id`,`renter_age`,`pickup_date`,`return_date`,`total_price`) VALUES
(1,25,'2024-02-01','2024-02-05',482.00),
(2,34,'2024-02-03','2024-02-04',120.50),
(3,41,'2024-02-10','2024-02-18',2480.00),
(4,29,'2024-02-11','2024-02-14',632.25),
(5,52,'2024-02-15','2024-02-20',450.00),
(6,19,'2024-02-18','2024-02-19',30.00),
(7,63,'2024-02-20','2024-02-27',1052.10),
(8,38,'2024-02-22','2024-02-25',287.70),
(9,45,'2024-03-01','2024-03-08',2170.00),
(10,27,'2024-03-02','2024-03-05',181.35);
