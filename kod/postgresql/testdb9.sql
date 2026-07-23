-- Štruktúra tabuľky pre `account_transactions`
\c testdb9
DROP TABLE IF EXISTS account_transactions CASCADE;

CREATE TABLE account_transactions (
  transaction_id SERIAL PRIMARY KEY,
  account_id INT NOT NULL,
  invoice_number VARCHAR(50) NOT NULL,
  payment_id INT NOT NULL,
  transaction_type_code VARCHAR(50) NOT NULL
);

-- Vkladanie dát do tabuľky `account_transactions`
INSERT INTO account_transactions (transaction_id, account_id, invoice_number, payment_id, transaction_type_code) VALUES 
(1, 9001, 'INV-2026-01', 100, 'BANK_TRANSFER'),
(2, 9001, 'INV-2026-02', 101, 'BANK_TRANSFER'),
(3, 9002, 'INV-2026-03', 102, 'CARD_PAYMENT'),
(4, 9001, 'INV-2026-04', 103, 'CASH'),
(5, 9003, 'INV-2026-05', 104, 'BANK_TRANSFER'),
(6, 9002, 'INV-2026-06', 105, 'CARD_PAYMENT'),
(7, 9003, 'INV-2026-07', 106, 'BANK_TRANSFER'),
(8, 9001, 'INV-2026-08', 107, 'BANK_TRANSFER'),
(9, 9002, 'INV-2026-09', 108, 'CARD_PAYMENT'),
(10, 9003, 'INV-2026-10', 109, 'BANK_TRANSFER');

-- Korekcia sekvencie po manuálnom vložení ID kľúčov
SELECT setval(pg_get_serial_sequence('account_transactions', 'transaction_id'), COALESCE(MAX(transaction_id), 1)) FROM account_transactions;