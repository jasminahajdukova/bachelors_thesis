
-- Štruktúra tabuľky pre `students`
\c testdb6
DROP TABLE IF EXISTS students CASCADE;

CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  address_id INT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  middle_name VARCHAR(100) DEFAULT NULL,
  last_name VARCHAR(100) NOT NULL,
  cell_mobile_number VARCHAR(20) NOT NULL,
  email_address VARCHAR(150) NOT NULL,
  date_first_rental DATE NOT NULL,
  date_left_university DATE DEFAULT NULL,
  other_student_details TEXT
);

-- Vkladanie dát do tabuľky `students`
INSERT INTO students (student_id, address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, date_first_rental, date_left_university, other_student_details) VALUES 
(1, 1001, 'Luk', 'Peter', 'Horvth', '421905111222', 'lukas.horvath@stud.uniba.sk', '2024-09-01', NULL, 'Active Erasmus coordinator.'),
(2, 1002, 'Michala', NULL, 'Kovov', '421911133344', 'michaela.kovacova@stud.uniba.sk', '2023-02-15', '2026-05-30', 'Graduated with honors, keys returned.'),
(3, 1003, 'Martin', 'Jn', 'Molnr', '421948555666', 'martin.molnar@stud.tuke.sk', '2025-09-05', NULL, 'Accommodated in Block B, room 302.'),
(4, 1004, 'Zuzana', NULL, 'Tthov', '421903777888', 'zuzana.toth@stud.uniza.sk', '2024-10-01', NULL, 'Requires parking slot near dormitory.'),
(5, 1005, 'John', 'Robert', 'Smith', '447123456789', 'john.smith@exchange.sk', '2025-09-01', '2026-02-10', 'Foreign exchange student from the UK.'),
(6, 1006, 'Tom', NULL, 'Varga', '421915999000', 'tomas.varga@stud.stuba.sk', '2022-09-01', NULL, 'Doctoral student, prolonged rental contract.'),
(7, 1007, 'Katarna', 'Mria', 'evkov', '421907222333', 'katarina.s@stud.ukf.sk', '2025-01-10', NULL, 'No issues reported, standard contract.'),
(8, 1008, 'Patrik', NULL, 'Nagy', '421944444555', 'patrik.nagy@stud.tuke.sk', '2023-09-01', '2025-06-15', 'Left university after Bachelor state exams.'),
(9, 1009, 'Simona', NULL, 'Krajrov', '421910888999', 'simona.k@stud.truni.sk', '2024-09-02', NULL, 'Dormitory council member.'),
(10, 1010, 'Dvid', 'Alex', 'Bal', '421902111555', 'david.balaz@stud.uniba.sk', '2025-09-15', NULL, 'Late registration due to medical reasons.'),
(11, 1011, 'Aneta', NULL, 'Blahov', '421918333222', 'aneta.b@stud.uniza.sk', '2024-02-20', NULL, 'Subletting approved for summer holidays.'),
(12, 1012, 'Matej', 'Filip', 'Kuera', '421905666777', 'matej.kucera@stud.stuba.sk', '2023-09-01', '2026-06-01', 'Completed Master degree.'),
(13, 1013, 'Lucia', NULL, 'Malkov', '421911444888', 'lucia.m@stud.upjs.sk', '2025-09-01', NULL, 'Requesting room change for next semester.'),
(14, 1014, 'Oliver', NULL, 'Rusnk', '421949111000', 'oliver.rusnak@stud.umb.sk', '2024-09-01', NULL, 'Sports scholarship recipient.'),
(15, 1015, 'Veronika', 'Eva', 'Feketeov', '421903222999', 'veronika.f@stud.ukf.sk', '2025-10-05', NULL, 'First year student, accommodation granted.');

-- Nastavenie správnej hodnoty sekvencie pre SERIAL stĺpca `student_id`
SELECT setval(pg_get_serial_sequence('students', 'student_id'), COALESCE(MAX(student_id), 1)) FROM students;