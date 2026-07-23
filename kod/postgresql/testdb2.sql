-- Vytvorenie databázy (voliteľné)
-- CREATE DATABASE testdb2;
-- \c testdb2;

-- Štruktúra tabuľky pre `car_models`
\c testdb2
DROP TABLE IF EXISTS car_models CASCADE;

CREATE TABLE car_models (
  model_code SERIAL PRIMARY KEY,
  manufacturer_code VARCHAR(50) NOT NULL,
  model_name VARCHAR(100) NOT NULL
);

-- Vkladanie dát do tabuľky `car_models`
INSERT INTO car_models (model_code, manufacturer_code, model_name) VALUES 
(1, 'SKODA', 'Octavia'),
(2, 'SKODA', 'Superb'),
(3, 'VW', 'Golf'),
(4, 'VW', 'Passat'),
(5, 'BMW', 'Rad 3'),
(6, 'BMW', 'Rad 5'),
(7, 'AUDI', 'A4'),
(8, 'AUDI', 'A6'),
(9, 'TOYOTA', 'Corolla'),
(10, 'TOYOTA', 'RAV4');

-- Reštartovanie sekvencie pre SERIAL stĺpca `model_code`
SELECT setval(pg_get_serial_sequence('car_models', 'model_code'), COALESCE(MAX(model_code), 1)) FROM car_models;