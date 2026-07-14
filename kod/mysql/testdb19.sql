-- extreme_junction
-- Mechanism: pure M:N junction table (composite PK of two FKs, no
--   own columns) - the documented Dataster architectural limitation
--   (independent random.choice per FK column, no combination dedup).
-- Expectation: junction table is EXCLUDED with an excluded_dependency
--   audit record; pipeline does not crash; parent tables pass L1-L3.
--   Tests that the documented exclusion works, not that M:N works.
DROP DATABASE IF EXISTS testdb19;
CREATE DATABASE testdb19 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb19;

DROP TABLE IF EXISTS `enrollments`;
DROP TABLE IF EXISTS `courses`;
DROP TABLE IF EXISTS `students`;

CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `students` (`id`,`full_name`) VALUES
(1,'Adam Kral'),(2,'Beata Siva'),(3,'Cyril Mokry'),
(4,'Dana Ostra'),(5,'Emil Tichy'),(6,'Filip Rychly');

CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `credits` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `courses` (`id`,`title`,`credits`) VALUES
(1,'Databases',5),(2,'Testing',4),(3,'Compilers',6),(4,'Networks',5);

CREATE TABLE `enrollments` (
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  PRIMARY KEY (`student_id`,`course_id`),
  CONSTRAINT `fk_en_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  CONSTRAINT `fk_en_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `enrollments` (`student_id`,`course_id`) VALUES
(1,1),(1,2),(2,1),(3,3),(4,2),(4,4),(5,1),(6,3),(6,4);
