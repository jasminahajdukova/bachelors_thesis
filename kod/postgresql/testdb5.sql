-- Štruktúra tabuľky pre `victims`
\c testdb5
DROP TABLE IF EXISTS victims CASCADE;

CREATE TABLE victims (
  victim_id SERIAL PRIMARY KEY,
  victim_status_code VARCHAR(50) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  middle_name VARCHAR(100) DEFAULT NULL,
  last_name VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL,
  date_first_suspected DATE NOT NULL,
  date_confirmed DATE DEFAULT NULL,
  date_of_death DATE DEFAULT NULL,
  other_details TEXT
);

-- Vkladanie dát do tabuľky `victims`
INSERT INTO victims (victim_id, victim_status_code, first_name, middle_name, last_name, address, date_first_suspected, date_confirmed, date_of_death, other_details) VALUES 
(1, 'CONFIRMED', 'John', 'Kofi', 'Mensah', '72 High Street, Accra', '2026-01-10', '2026-01-12', NULL, 'Patient in isolation unit, showing signs of recovery.'),
(2, 'DECEASED', 'Amara', NULL, 'Camara', 'Conakry Outskirts Block B', '2026-01-15', '2026-01-16', '2026-01-20', 'Deceased upon arrival at the red zone clinic.'),
(3, 'SUSPECTED', 'Moussa', 'Alhassan', 'Diallo', 'Bo Town, Sector 3', '2026-02-01', NULL, NULL, 'Family member was confirmed positive. Awaiting lab results.'),
(4, 'RECOVERED', 'Fatoumata', NULL, 'Bah', 'Kenema Highway 14', '2026-01-05', '2026-01-07', NULL, 'Discharged after two consecutive negative PCR tests.'),
(5, 'DECEASED', 'Samuel', 'Tamba', 'Bangura', 'Koidu Village', '2026-02-10', '2026-02-11', '2026-02-15', 'Funeral conducted under safe biological protocols.'),
(6, 'CONFIRMED', 'Zainab', 'Sheriff', 'Kamara', 'Makeni Central', '2026-02-18', '2026-02-20', NULL, 'Currently undergoing experimental antibody treatment.'),
(7, 'SUSPECTED', 'Ibrahim', NULL, 'Sow', 'Labe District', '2026-03-01', NULL, NULL, 'Presented with high fever and joint pain. Isolated at home.'),
(8, 'RECOVERED', 'Kwame', 'Osei', 'Appiah', 'Kumasi Market Area', '2025-12-20', '2025-12-22', NULL, 'Antibodies present, plasma donation requested.'),
(9, 'DECEASED', 'Marie', 'Claire', 'Loua', 'Nzerekore Route 4', '2026-03-05', '2026-03-06', '2026-03-09', 'Epidemiological link to the initial index case cluster.'),
(10, 'CONFIRMED', 'Abubakarr', NULL, 'Jalloh', 'Waterloo Camp, Freetown', '2026-03-12', '2026-03-13', NULL, 'Transferred from community health post.'),
(11, 'SUSPECTED', 'Efe', 'Godwin', 'Okoro', 'Benin City bypass', '2026-04-02', NULL, NULL, 'Travel history to affected border region.'),
(12, 'DECEASED', 'Sia', 'Finda', 'Kondo', 'Yengema Road', '2026-03-20', '2026-03-22', '2026-03-27', 'Advanced stage hemorrhagic symptoms recorded.'),
(13, 'CONFIRMED', 'Sekou', NULL, 'Traore', 'Macenta Center', '2026-04-10', '2026-04-11', NULL, 'Stable vital signs, receiving intensive hydration.'),
(14, 'RECOVERED', 'Amina', 'Yusuf', 'Bello', 'Kano Ward 5', '2026-02-25', '2026-02-27', NULL, 'Full clinical recovery documented by field team.'),
(15, 'SUSPECTED', 'David', 'Kojo', 'Turay', 'Lungi Airport Area', '2026-05-15', NULL, NULL, 'Flagged at thermal screening checkpoint with elevated temp.');

-- Korekcia sekvencie po manuálnom vložení ID kľúčov
SELECT setval(pg_get_serial_sequence('victims', 'victim_id'), COALESCE(MAX(victim_id), 1)) FROM victims;