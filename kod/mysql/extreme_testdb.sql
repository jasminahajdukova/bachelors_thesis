CREATE DATABASE IF NOT EXISTS extreme_testdb;
USE extreme_testdb;

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
