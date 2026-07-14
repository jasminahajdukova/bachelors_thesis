-- extreme_temporal
-- Mechanism: date, datetime and time columns with narrow value ranges.
--   Targets documented dinterval degeneracy (z3 returns interval lower
--   bound -> generated dates cluster at minimum) and doubles as the
--   Gate-1 serialization check (datetime must serialize with a space
--   separator, not 'T'; time as HH:MM:SS).
-- Expectation: L1-L2 pass; generated date/datetime values cluster at
--   interval minimum (dataster_dinterval finding reproduced on the
--   reconstructed set); samples line in log shows space-separated
--   datetime.
DROP DATABASE IF EXISTS testdb23;
CREATE DATABASE testdb23 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb23;


DROP TABLE IF EXISTS `events`;

CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_date` date NOT NULL,
  `created_at` datetime NOT NULL,
  `start_time` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `events` (`id`,`event_date`,`created_at`,`start_time`) VALUES
(1,'2024-03-01','2024-03-01 08:15:00','08:30:00'),
(2,'2024-03-01','2024-03-01 09:40:00','10:00:00'),
(3,'2024-03-02','2024-03-02 07:05:00','09:15:00'),
(4,'2024-03-02','2024-03-02 11:20:00','13:45:00'),
(5,'2024-03-03','2024-03-03 06:55:00','07:30:00'),
(6,'2024-03-03','2024-03-03 14:10:00','15:00:00'),
(7,'2024-03-04','2024-03-04 10:25:00','11:10:00'),
(8,'2024-03-05','2024-03-05 16:45:00','17:20:00');
