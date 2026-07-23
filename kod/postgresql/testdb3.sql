-- Vytvorenie databázy (voliteľné)
-- CREATE DATABASE testdb3;
-- \c testdb3;
\c testdb3
-- Štruktúra tabuľky pre `customer_payments`
DROP TABLE IF EXISTS customer_payments CASCADE;

CREATE TABLE customer_payments (
  customer_payment_id SERIAL PRIMARY KEY,
  car_sold_id INT NOT NULL,
  customer_id INT NOT NULL,
  payment_status_code VARCHAR(20) NOT NULL,
  customer_payment_date_due DATE DEFAULT NULL,
  customer_payment_date_made DATE DEFAULT NULL,
  actual_payment_amount DECIMAL(10,2) DEFAULT NULL
);

-- Vkladanie dát do tabuľky `customer_payments`
INSERT INTO customer_payments (customer_payment_id, car_sold_id, customer_id, payment_status_code, customer_payment_date_due, customer_payment_date_made, actual_payment_amount) VALUES 
(1, 101, 501, 'PAID', '2026-01-15', '2026-01-14', 15000.00),
(2, 102, 502, 'PAID', '2026-01-20', '2026-01-20', 22500.50),
(3, 103, 503, 'PENDING', '2026-06-20', NULL, NULL),
(4, 104, 504, 'PAID', '2026-02-10', '2026-02-12', 18900.00),
(5, 105, 505, 'OVERDUE', '2026-05-01', NULL, NULL),
(6, 106, 506, 'PAID', '2026-03-01', '2026-02-28', 31000.00),
(7, 107, 507, 'PENDING', '2026-06-25', NULL, NULL),
(8, 108, 508, 'PAID', '2026-03-15', '2026-03-15', 12350.00),
(9, 109, 509, 'PAID', '2026-04-05', '2026-04-04', 45000.00),
(10, 110, 510, 'OVERDUE', '2026-05-15', NULL, NULL),
(11, 111, 511, 'PAID', '2026-04-20', '2026-04-22', 17500.00),
(12, 112, 512, 'PENDING', '2026-07-01', NULL, NULL),
(13, 113, 513, 'PAID', '2026-05-10', '2026-05-09', 28990.99),
(14, 114, 514, 'PAID', '2026-05-20', '2026-05-20', 16000.00),
(15, 115, 515, 'PENDING', NULL, NULL, NULL);

-- Nastavenie správnej hodnoty sekvencie pre SERIAL stĺpca `customer_payment_id`
SELECT setval(pg_get_serial_sequence('customer_payments', 'customer_payment_id'), COALESCE(MAX(customer_payment_id), 1)) FROM customer_payments;