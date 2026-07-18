CREATE DATABASE IF NOT EXISTS extreme_testdb7;
USE extreme_testdb7;

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
    id INT PRIMARY KEY
);

INSERT INTO t_1 (id) VALUES (1);
INSERT INTO t_1 (id) VALUES (2);
INSERT INTO t_1 (id) VALUES (3);
INSERT INTO t_1 (id) VALUES (4);
INSERT INTO t_1 (id) VALUES (5);
INSERT INTO t_1 (id) VALUES (6);
INSERT INTO t_1 (id) VALUES (7);
INSERT INTO t_1 (id) VALUES (8);
INSERT INTO t_1 (id) VALUES (9);
INSERT INTO t_1 (id) VALUES (10);

CREATE TABLE t_2 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_1(id)
);

INSERT INTO t_2 (id, parent_id) VALUES (1, 1);
INSERT INTO t_2 (id, parent_id) VALUES (2, 2);
INSERT INTO t_2 (id, parent_id) VALUES (3, 3);
INSERT INTO t_2 (id, parent_id) VALUES (4, 4);
INSERT INTO t_2 (id, parent_id) VALUES (5, 5);
INSERT INTO t_2 (id, parent_id) VALUES (6, 6);
INSERT INTO t_2 (id, parent_id) VALUES (7, 7);
INSERT INTO t_2 (id, parent_id) VALUES (8, 8);
INSERT INTO t_2 (id, parent_id) VALUES (9, 9);
INSERT INTO t_2 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_3 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_2(id)
);

INSERT INTO t_3 (id, parent_id) VALUES (1, 1);
INSERT INTO t_3 (id, parent_id) VALUES (2, 2);
INSERT INTO t_3 (id, parent_id) VALUES (3, 3);
INSERT INTO t_3 (id, parent_id) VALUES (4, 4);
INSERT INTO t_3 (id, parent_id) VALUES (5, 5);
INSERT INTO t_3 (id, parent_id) VALUES (6, 6);
INSERT INTO t_3 (id, parent_id) VALUES (7, 7);
INSERT INTO t_3 (id, parent_id) VALUES (8, 8);
INSERT INTO t_3 (id, parent_id) VALUES (9, 9);
INSERT INTO t_3 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_4 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_3(id)
);

INSERT INTO t_4 (id, parent_id) VALUES (1, 1);
INSERT INTO t_4 (id, parent_id) VALUES (2, 2);
INSERT INTO t_4 (id, parent_id) VALUES (3, 3);
INSERT INTO t_4 (id, parent_id) VALUES (4, 4);
INSERT INTO t_4 (id, parent_id) VALUES (5, 5);
INSERT INTO t_4 (id, parent_id) VALUES (6, 6);
INSERT INTO t_4 (id, parent_id) VALUES (7, 7);
INSERT INTO t_4 (id, parent_id) VALUES (8, 8);
INSERT INTO t_4 (id, parent_id) VALUES (9, 9);
INSERT INTO t_4 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_5 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_4(id)
);

INSERT INTO t_5 (id, parent_id) VALUES (1, 1);
INSERT INTO t_5 (id, parent_id) VALUES (2, 2);
INSERT INTO t_5 (id, parent_id) VALUES (3, 3);
INSERT INTO t_5 (id, parent_id) VALUES (4, 4);
INSERT INTO t_5 (id, parent_id) VALUES (5, 5);
INSERT INTO t_5 (id, parent_id) VALUES (6, 6);
INSERT INTO t_5 (id, parent_id) VALUES (7, 7);
INSERT INTO t_5 (id, parent_id) VALUES (8, 8);
INSERT INTO t_5 (id, parent_id) VALUES (9, 9);
INSERT INTO t_5 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_6 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_5(id)
);

INSERT INTO t_6 (id, parent_id) VALUES (1, 1);
INSERT INTO t_6 (id, parent_id) VALUES (2, 2);
INSERT INTO t_6 (id, parent_id) VALUES (3, 3);
INSERT INTO t_6 (id, parent_id) VALUES (4, 4);
INSERT INTO t_6 (id, parent_id) VALUES (5, 5);
INSERT INTO t_6 (id, parent_id) VALUES (6, 6);
INSERT INTO t_6 (id, parent_id) VALUES (7, 7);
INSERT INTO t_6 (id, parent_id) VALUES (8, 8);
INSERT INTO t_6 (id, parent_id) VALUES (9, 9);
INSERT INTO t_6 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_7 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_6(id)
);

INSERT INTO t_7 (id, parent_id) VALUES (1, 1);
INSERT INTO t_7 (id, parent_id) VALUES (2, 2);
INSERT INTO t_7 (id, parent_id) VALUES (3, 3);
INSERT INTO t_7 (id, parent_id) VALUES (4, 4);
INSERT INTO t_7 (id, parent_id) VALUES (5, 5);
INSERT INTO t_7 (id, parent_id) VALUES (6, 6);
INSERT INTO t_7 (id, parent_id) VALUES (7, 7);
INSERT INTO t_7 (id, parent_id) VALUES (8, 8);
INSERT INTO t_7 (id, parent_id) VALUES (9, 9);
INSERT INTO t_7 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_8 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_7(id)
);

INSERT INTO t_8 (id, parent_id) VALUES (1, 1);
INSERT INTO t_8 (id, parent_id) VALUES (2, 2);
INSERT INTO t_8 (id, parent_id) VALUES (3, 3);
INSERT INTO t_8 (id, parent_id) VALUES (4, 4);
INSERT INTO t_8 (id, parent_id) VALUES (5, 5);
INSERT INTO t_8 (id, parent_id) VALUES (6, 6);
INSERT INTO t_8 (id, parent_id) VALUES (7, 7);
INSERT INTO t_8 (id, parent_id) VALUES (8, 8);
INSERT INTO t_8 (id, parent_id) VALUES (9, 9);
INSERT INTO t_8 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_9 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_8(id)
);

INSERT INTO t_9 (id, parent_id) VALUES (1, 1);
INSERT INTO t_9 (id, parent_id) VALUES (2, 2);
INSERT INTO t_9 (id, parent_id) VALUES (3, 3);
INSERT INTO t_9 (id, parent_id) VALUES (4, 4);
INSERT INTO t_9 (id, parent_id) VALUES (5, 5);
INSERT INTO t_9 (id, parent_id) VALUES (6, 6);
INSERT INTO t_9 (id, parent_id) VALUES (7, 7);
INSERT INTO t_9 (id, parent_id) VALUES (8, 8);
INSERT INTO t_9 (id, parent_id) VALUES (9, 9);
INSERT INTO t_9 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_10 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_9(id)
);

INSERT INTO t_10 (id, parent_id) VALUES (1, 1);
INSERT INTO t_10 (id, parent_id) VALUES (2, 2);
INSERT INTO t_10 (id, parent_id) VALUES (3, 3);
INSERT INTO t_10 (id, parent_id) VALUES (4, 4);
INSERT INTO t_10 (id, parent_id) VALUES (5, 5);
INSERT INTO t_10 (id, parent_id) VALUES (6, 6);
INSERT INTO t_10 (id, parent_id) VALUES (7, 7);
INSERT INTO t_10 (id, parent_id) VALUES (8, 8);
INSERT INTO t_10 (id, parent_id) VALUES (9, 9);
INSERT INTO t_10 (id, parent_id) VALUES (10, 10);
