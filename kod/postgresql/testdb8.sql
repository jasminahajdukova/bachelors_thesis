
\c testdb8
-- Štruktúra tabuľky pre `company_customers`

DROP TABLE IF EXISTS company_customers CASCADE;

CREATE TABLE company_customers (
  customer_id INT NOT NULL,
  company_name VARCHAR(150) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  credit_score INT NOT NULL,
  date_credit_score_reviewed DATE NOT NULL,
  date_credit_class_reviewed DATE NOT NULL,
  PRIMARY KEY (customer_id)
);

-- Vkladanie dát do tabuľky `company_customers`
INSERT INTO company_customers (customer_id, company_name, phone_number, credit_score, date_credit_score_reviewed, date_credit_class_reviewed) VALUES 
(1, 'TechLogix s.r.o.', '421905123456', 750, '2026-01-15', '2026-01-15'),
(2, 'EuroTrade Slovakia a.s.', '421911234567', 620, '2026-02-10', '2026-02-11'),
(3, 'AutoServis Jn & synovia', '421948345678', 450, '2025-11-20', '2025-11-20'),
(4, 'Alpha Developer Group', '421903456789', 820, '2026-03-01', '2026-03-02'),
(5, 'BioFoods Distribution', '421915567890', 580, '2026-01-22', '2026-01-22'),
(6, 'StavbaTrend ilina', '421907678901', 690, '2026-04-05', '2026-04-05'),
(7, 'EcoEnergy Solutions', '421944789012', 710, '2026-02-18', '2026-02-20'),
(8, 'Logistika Tatry d.o.o.', '421910890123', 500, '2025-12-15', '2025-12-15'),
(9, 'Kreatvna Agentra Pixel', '421902901234', 780, '2026-05-12', '2026-05-12'),
(10, 'Prvne Sluby Partneri', '421918012345', 850, '2026-03-30', '2026-04-01'),
(11, 'MetalKov Koice', '421905223344', 640, '2026-01-08', '2026-01-10'),
(12, 'Kaviare a Praiare s.r.o.', '421911334455', 530, '2026-02-27', '2026-02-27'),
(13, 'Zhradn Centrum Garden', '421948445566', 600, '2026-04-14', '2026-04-15'),
(14, 'MediCura Poliklinika', '421903556677', 790, '2026-05-20', '2026-05-20'),
(15, 'SmartHome Security', '421915667788', 720, '2026-01-19', '2026-01-20'),
(16, 'Drevovroba Hron', '421907778899', 410, '2025-10-05', '2025-10-05'),
(17, 'NextGen Telco a.s.', '421944889900', 880, '2026-03-11', '2026-03-11'),
(18, 'Mdny Svet E-shop', '421910990011', 660, '2026-02-04', '2026-02-04'),
(19, 'STK a Emisn Kontroly', '421902112233', 570, '2026-04-22', '2026-04-22'),
(20, 'Consulting & Tax Slovakia', '421918223344', 800, '2026-05-02', '2026-05-03'),
(21, 'Pekre Krka', '421905334455', 490, '2025-12-18', '2025-12-20'),
(22, 'CleanStart Upratovac Servis', '421911445566', 610, '2026-01-30', '2026-01-30'),
(23, 'Farma GreenValley', '421948556677', 670, '2026-03-17', '2026-03-17'),
(24, 'IT Core Systems', '421903667788', 760, '2026-04-29', '2026-04-30'),
(25, 'Hotel Panorma Tatry', '421915778899', 700, '2026-02-14', '2026-02-15');