-- Odstránenie starých tabuliek v správnom poradí
\c testdb10
DROP TABLE IF EXISTS children CASCADE;
DROP TABLE IF EXISTS parents CASCADE;

-- 1. Najprv vytvoríme tabuľku `parents`
CREATE TABLE parents (
  parent_id INT NOT NULL,
  parent_name VARCHAR(100) NOT NULL,
  gender VARCHAR(10) NOT NULL,
  parent_address VARCHAR(150) NOT NULL,
  home_phone VARCHAR(20) NOT NULL,
  cell_mobile_phone VARCHAR(20) NOT NULL,
  other_details TEXT,
  PRIMARY KEY (parent_id)
);

-- 2. Potom vytvoríme tabuľku `children` s referenciou na rodiča
CREATE TABLE children (
  child_id INT NOT NULL,
  parent_id INT NOT NULL,
  gender VARCHAR(10) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  age INT NOT NULL,
  date_of_birth DATE NOT NULL,
  other_details TEXT,
  PRIMARY KEY (child_id),
  CONSTRAINT fk_children_parents FOREIGN KEY (parent_id) REFERENCES parents (parent_id)
);

-- Vkladanie dát do tabuľky `parents`
INSERT INTO parents (parent_id, parent_name, gender, parent_address, home_phone, cell_mobile_phone, other_details) VALUES 
(1, 'John Doe', 'Male', '123 Maple St, Springfield', '555-0192', '555-4321', 'Prefers email updates'),
(2, 'Jane Smith', 'Female', '456 Oak Rd, Metropolis', '555-0143', '555-8765', 'Emergency contact listed'),
(3, 'Robert Johnson', 'Male', '789 Pine Ave, Gotham', '555-0177', '555-9812', 'No special requirements'),
(4, 'Emily Davis', 'Female', '321 Elm Blvd, Star City', '555-0155', '555-3456', 'Authorized for school pickup'),
(5, 'Michael Brown', 'Male', '654 Birch Ln, Central City', '555-0111', '555-6543', 'Speaks English and Spanish');

-- Vkladanie dát do tabuľky `children`
INSERT INTO children (child_id, parent_id, gender, first_name, last_name, age, date_of_birth, other_details) VALUES 
(1, 1, 'Male', 'Billy', 'Doe', 8, '2018-04-12', 'Allergic to peanuts'),
(2, 1, 'Female', 'Lily', 'Doe', 5, '2021-08-23', 'Enrolled in soccer league'),
(3, 2, 'Male', 'Tommy', 'Smith', 10, '2016-01-15', 'Wears glasses'),
(4, 3, 'Female', 'Sophia', 'Johnson', 12, '2014-11-05', 'Plays piano'),
(5, 4, 'Male', 'Ethan', 'Davis', 6, '2020-05-30', 'Requires afternoon daycare bus');