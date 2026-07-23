-- Vytvorenie databázy (ak ju spúšťaš pod admin účtom, inak tento krok môžeš vynechať)
-- CREATE DATABASE testdb;
-- \c testdb;

-- Štruktúra tabuľky pre `users`

\c testdb
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL
);

-- Vkladanie dát do tabuľky `users`
INSERT INTO users (id, name, email) VALUES 
(1, 'Aneta Valekova', 'aneta@test.com'),
(2, 'Martin Hrac', 'martin@test.com'),
(3, 'Jana Novak', 'jana@test.com'),
(4, 'Peter Horak', 'peter@test.com'),
(5, 'Maria Kovac', 'maria@test.com'),
(6, 'Jan Novak', 'jan@test.com'),
(7, 'Pvel Cerny', 'pavel@test.com'),
(8, 'Frantisek Kucera', 'frantisek@test.com'),
(9, 'Eva Vesela', 'eva@gmail.com'),
(10, 'Stepan Horak', 'stepan@bing.com');

-- Reštartovanie sekvencie pre SERIAL, keďže sme id vkladali natvrdo
SELECT setval(pg_get_serial_sequence('users', 'id'), COALESCE(MAX(id), 1)) FROM users;