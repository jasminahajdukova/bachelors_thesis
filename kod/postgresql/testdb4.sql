-- Štruktúra tabuľky pre `database_records`
\c testdb4
DROP TABLE IF EXISTS database_records CASCADE;

CREATE TABLE database_records (
  id SERIAL PRIMARY KEY,
  database_algorithm_name VARCHAR(100) NOT NULL,
  database_name VARCHAR(100) NOT NULL,
  database_owner_name VARCHAR(100) NOT NULL,
  database_location VARCHAR(100) NOT NULL,
  contact_name VARCHAR(100) NOT NULL,
  contact_address VARCHAR(150) NOT NULL,
  contact_email VARCHAR(150) NOT NULL,
  other_details TEXT NOT NULL
);

-- Vkladanie dát do tabuľky `database_records`
INSERT INTO database_records (id, database_algorithm_name, database_name, database_owner_name, database_location, contact_name, contact_address, contact_email, other_details) VALUES 
(1, 'Minutiae Matching', 'National_ID_FPs', 'Ministry of Interior', 'Server Room A', 'Jan Kovac', 'Hlavna 12, Bratislava', 'j.kovac@interior.gov.sk', 'Main national database for citizen identification.'),
(2, 'Pattern Recognition', 'Border_Control_DB', 'Customs Office', 'Cloud Region Europe', 'Maria Horvathova', 'Letisko, Kosice', 'm.horvath@customs.sk', 'Used for airport border control checks.'),
(3, 'Deep Learning CNN', 'Research_Dataset_v2', 'Technical University', 'Lab 403 Storage', 'Peter Malik', 'Ilkovicova 3, Bratislava', 'peter.malik@stuba.sk', 'Academic research database, anonymous samples.'),
(4, 'Minutiae Matching', 'Corporate_Access_DB', 'Secure Tech Corp', 'On-Premises Server', 'John Doe', 'Tech Street 5, Zilina', 'j.doe@securetech.com', 'Employee access control for high-security zones.'),
(5, 'Wavelet Transform', 'Banking_Auth_Cloud', 'Global Bank IS', 'AWS Frankfurt', 'Anna Novakova', 'Mlynska Nivy, Bratislava', 'novakova@globalbank.com', 'Biometric login data for mobile banking application.'),
(6, 'Minutiae Matching', 'Police_Criminal_Records', 'Police HQ', 'Secure Vault B', 'Stefan Repka', 'Pribinova 2, Presov', 's.repka@police.sk', 'Restricted access, criminal investigation records.'),
(7, 'Deep Learning CNN', 'SmartLock_User_DB', 'HomeAutomation Ltd', 'Azure West Europe', 'Lukas Svoboda', 'Kollarova 8, Trnava', 'l.svoboda@homeauto.sk', 'IoT smart lock backup registry.'),
(8, 'Pattern Recognition', 'Military_Base_Access', 'Ministry of Defence', 'Underground Bunker', 'Major Milan Ruzicka', 'Vojenska 1, Trencin', 'milan.ruzicka@mod.gov.sk', 'Top secret access clearance database.'),
(9, 'Minutiae Matching', 'Gym_Members_FPs', 'Fitness City', 'Local PC-Database', 'Eva Szaboova', 'Okruzna 44, Nitra', 'info@fitcity.sk', 'Membership verification for gym entries.'),
(10, 'Ridge Frequency', 'Gov_Logistics_Track', 'Postal Services', 'Data Center Central', 'Tomas Beranek', 'Postova 1, Banska Bystrica', 't.beranek@skposta.sk', 'Driver authentication system for high-value cargo.'),
(11, 'Minutiae Matching', 'University_Exam_Check', 'University of Zilina', 'Server Room 2', 'Prof. Igor Janci', 'Univerzitna 1, Zilina', 'igor.janci@uniza.sk', 'Student attendance validation for final exams.'),
(12, 'Deep Learning CNN', 'AI_Trainer_Set_Large', 'Vision AI Labs', 'GPU Cluster Local', 'Dr. Alex Mercer', 'Science Park, Martin', 'mercer@visionailabs.com', 'Massive training set for neural network calibration.'),
(13, 'Pattern Recognition', 'Hospital_Staff_Auth', 'St. Michael Hospital', 'Internal Server Block', 'Katarina Liptakova', 'Satinskeho 1, Bratislava', 'k.liptakova@nsm.sk', 'Access control to drug storage rooms.'),
(14, 'Minutiae Matching', 'Automotive_Start_DB', 'CarTech Slovakia', 'Embedded Flash Memo', 'Jozef Marecek', 'Priemyselna Zona, Trnava', 'j.marecek@cartech.sk', 'Biometric ignition systems for luxury car line.'),
(15, 'Wavelet Transform', 'Airport_Staff_Secure', 'Bratislava Airport', 'Main Terminal Server', 'Robert Nemec', 'Ivanska cesta, Bratislava', 'r.nemec@bts.aero', 'Ground crew and pilot biometric verification.'),
(16, 'Minutiae Matching', 'School_Attendance_Syst', 'Gymnazium Kukucinova', 'Principal Office PC', 'Elena Vrbova', 'Kukucinova 12, Poprad', 'vrbova@gympoprad.sk', 'Pilot project for student attendance monitoring.'),
(17, 'Ridge Frequency', 'Casino_VIP_Registry', 'Royal Casino Group', 'Offshore Cloud', 'Marcello Silva', 'Vodna 2, Komarno', 'm.silva@royalcasino.com', 'VIP client identification and loyalty system.'),
(18, 'Deep Learning CNN', 'Customs_Cargo_Drivers', 'Financial Administration', 'HQ Server Room', 'Ivan Drabek', 'Mierova 23, Bratislava', 'ivan.drabek@fs.sk', 'Verification of international cargo drivers.'),
(19, 'Minutiae Matching', 'DataCenter_Biometrics', 'Telco Cloud Europe', 'Rack 14-A Room 1', 'Gabriel Kiss', 'Sturova 5, Dunajska Streda', 'g.kiss@telcocloud.sk', 'Physical access logs for server housing clients.'),
(20, 'Pattern Recognition', 'Hotel_Smart_CheckIn', 'Resort Paradiso', 'Cloud Database', 'Lucia Blahova', 'Tatranska 100, Strbske Pleso', 'l.blahova@paradiso.sk', 'Self-service biometric kiosk registrations.');

-- Korekcia sekvencie po manuálnom vložení ID kľúčov
SELECT setval(pg_get_serial_sequence('database_records', 'id'), COALESCE(MAX(id), 1)) FROM database_records;