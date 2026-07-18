CREATE DATABASE IF NOT EXISTS extreme_testdb3;
USE extreme_testdb3;

DROP TABLE IF EXISTS t_100;
DROP TABLE IF EXISTS t_99;
DROP TABLE IF EXISTS t_98;
DROP TABLE IF EXISTS t_97;
DROP TABLE IF EXISTS t_96;
DROP TABLE IF EXISTS t_95;
DROP TABLE IF EXISTS t_94;
DROP TABLE IF EXISTS t_93;
DROP TABLE IF EXISTS t_92;
DROP TABLE IF EXISTS t_91;
DROP TABLE IF EXISTS t_90;
DROP TABLE IF EXISTS t_89;
DROP TABLE IF EXISTS t_88;
DROP TABLE IF EXISTS t_87;
DROP TABLE IF EXISTS t_86;
DROP TABLE IF EXISTS t_85;
DROP TABLE IF EXISTS t_84;
DROP TABLE IF EXISTS t_83;
DROP TABLE IF EXISTS t_82;
DROP TABLE IF EXISTS t_81;
DROP TABLE IF EXISTS t_80;
DROP TABLE IF EXISTS t_79;
DROP TABLE IF EXISTS t_78;
DROP TABLE IF EXISTS t_77;
DROP TABLE IF EXISTS t_76;
DROP TABLE IF EXISTS t_75;
DROP TABLE IF EXISTS t_74;
DROP TABLE IF EXISTS t_73;
DROP TABLE IF EXISTS t_72;
DROP TABLE IF EXISTS t_71;
DROP TABLE IF EXISTS t_70;
DROP TABLE IF EXISTS t_69;
DROP TABLE IF EXISTS t_68;
DROP TABLE IF EXISTS t_67;
DROP TABLE IF EXISTS t_66;
DROP TABLE IF EXISTS t_65;
DROP TABLE IF EXISTS t_64;
DROP TABLE IF EXISTS t_63;
DROP TABLE IF EXISTS t_62;
DROP TABLE IF EXISTS t_61;
DROP TABLE IF EXISTS t_60;
DROP TABLE IF EXISTS t_59;
DROP TABLE IF EXISTS t_58;
DROP TABLE IF EXISTS t_57;
DROP TABLE IF EXISTS t_56;
DROP TABLE IF EXISTS t_55;
DROP TABLE IF EXISTS t_54;
DROP TABLE IF EXISTS t_53;
DROP TABLE IF EXISTS t_52;
DROP TABLE IF EXISTS t_51;
DROP TABLE IF EXISTS t_50;
DROP TABLE IF EXISTS t_49;
DROP TABLE IF EXISTS t_48;
DROP TABLE IF EXISTS t_47;
DROP TABLE IF EXISTS t_46;
DROP TABLE IF EXISTS t_45;
DROP TABLE IF EXISTS t_44;
DROP TABLE IF EXISTS t_43;
DROP TABLE IF EXISTS t_42;
DROP TABLE IF EXISTS t_41;
DROP TABLE IF EXISTS t_40;
DROP TABLE IF EXISTS t_39;
DROP TABLE IF EXISTS t_38;
DROP TABLE IF EXISTS t_37;
DROP TABLE IF EXISTS t_36;
DROP TABLE IF EXISTS t_35;
DROP TABLE IF EXISTS t_34;
DROP TABLE IF EXISTS t_33;
DROP TABLE IF EXISTS t_32;
DROP TABLE IF EXISTS t_31;
DROP TABLE IF EXISTS t_30;
DROP TABLE IF EXISTS t_29;
DROP TABLE IF EXISTS t_28;
DROP TABLE IF EXISTS t_27;
DROP TABLE IF EXISTS t_26;
DROP TABLE IF EXISTS t_25;
DROP TABLE IF EXISTS t_24;
DROP TABLE IF EXISTS t_23;
DROP TABLE IF EXISTS t_22;
DROP TABLE IF EXISTS t_21;
DROP TABLE IF EXISTS t_20;
DROP TABLE IF EXISTS t_19;
DROP TABLE IF EXISTS t_18;
DROP TABLE IF EXISTS t_17;
DROP TABLE IF EXISTS t_16;
DROP TABLE IF EXISTS t_15;
DROP TABLE IF EXISTS t_14;
DROP TABLE IF EXISTS t_13;
DROP TABLE IF EXISTS t_12;
DROP TABLE IF EXISTS t_11;
DROP TABLE IF EXISTS t_10;
DROP TABLE IF EXISTS t_9;
DROP TABLE IF EXISTS t_8;
DROP TABLE IF EXISTS t_7;
DROP TABLE IF EXISTS t_6;
DROP TABLE IF EXISTS t_5;
DROP TABLE IF EXISTS t_4;
DROP TABLE IF EXISTS t_3;
DROP TABLE IF EXISTS t_2;
DROP TABLE IF EXISTS t_1;

CREATE TABLE t_1 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    col_4 DATE
);

INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (1, 100, 'val_1_0', 2.00, '2026-01-01');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (2, 101, 'val_1_1', 2.01, '2026-01-02');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (3, 102, 'val_1_2', 2.02, '2026-01-03');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (4, 103, 'val_1_3', 2.03, '2026-01-04');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (5, 104, 'val_1_4', 2.04, '2026-01-05');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (6, 105, 'val_1_5', 2.05, '2026-01-06');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (7, 106, 'val_1_6', 2.06, '2026-01-07');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (8, 107, 'val_1_7', 2.07, '2026-01-08');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (9, 108, 'val_1_8', 2.08, '2026-01-09');
INSERT INTO t_1 (id, col_1, col_2, col_3, col_4) VALUES (10, 109, 'val_1_9', 2.09, '2026-01-10');

CREATE TABLE t_2 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_2 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_3 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_3 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_4 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_4 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_5 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_5 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_6 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_6 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_7 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_7 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_8 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_8 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_9 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_9 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_10 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_10 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_11 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_11 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_12 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_12 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_13 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_13 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_14 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_14 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_15 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_15 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_16 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_16 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_17 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_17 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_18 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_18 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_19 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_19 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_20 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_20 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_21 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_21 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_22 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_22 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_23 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_23 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_24 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_24 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_25 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_25 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_26 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_26 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_27 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_27 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_28 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_28 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_29 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_29 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_30 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_30 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_31 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_31 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_32 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_32 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_33 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_33 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_34 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_34 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_35 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_35 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_36 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_36 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_37 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_37 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_38 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_38 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_39 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_39 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_40 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_40 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_41 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_41 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_42 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_42 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_43 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_43 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_44 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_44 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_45 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_45 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_46 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_46 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_47 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_47 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_48 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_48 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_49 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_49 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_50 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_50 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_51 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_51 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_52 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_52 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_53 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_53 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_54 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_54 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_55 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_55 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_56 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_56 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_57 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_57 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_58 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_58 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_59 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_59 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_60 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_60 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_61 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_61 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_62 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_62 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_63 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_63 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_64 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_64 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_65 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_65 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_66 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_66 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_67 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_67 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_68 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_68 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_69 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_69 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_70 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_70 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_71 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_71 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_72 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_72 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_73 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_73 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_74 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_74 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_75 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_75 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_76 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_76 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_77 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_77 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_78 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_78 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_79 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_79 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_80 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_80 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_81 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_81 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_82 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_82 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_83 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_83 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_84 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_84 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_85 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_85 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_86 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_86 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_87 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_87 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_88 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_88 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_89 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_89 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_90 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_90 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_91 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_91 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_92 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_92 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_93 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_93 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_94 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_94 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_95 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_95 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_96 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_96 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_97 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_97 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_98 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_98 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_99 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_99 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);

CREATE TABLE t_100 (
    id INT PRIMARY KEY,
    col_1 INT,
    col_2 VARCHAR(50),
    col_3 DECIMAL(10,2),
    fk_t_1 INT,
    FOREIGN KEY (fk_t_1) REFERENCES t_1(id)
);

INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (1, 100, 'val_1_0', 2.00, 1);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (2, 101, 'val_1_1', 2.01, 2);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (3, 102, 'val_1_2', 2.02, 3);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (4, 103, 'val_1_3', 2.03, 4);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (5, 104, 'val_1_4', 2.04, 5);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (6, 105, 'val_1_5', 2.05, 6);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (7, 106, 'val_1_6', 2.06, 7);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (8, 107, 'val_1_7', 2.07, 8);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (9, 108, 'val_1_8', 2.08, 9);
INSERT INTO t_100 (id, col_1, col_2, col_3, fk_t_1) VALUES (10, 109, 'val_1_9', 2.09, 10);
