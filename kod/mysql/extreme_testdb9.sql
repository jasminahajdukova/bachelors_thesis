CREATE DATABASE IF NOT EXISTS extreme_testdb9;
USE extreme_testdb9;

DROP TABLE IF EXISTS t_child_20;
DROP TABLE IF EXISTS t_child_19;
DROP TABLE IF EXISTS t_child_18;
DROP TABLE IF EXISTS t_child_17;
DROP TABLE IF EXISTS t_child_16;
DROP TABLE IF EXISTS t_child_15;
DROP TABLE IF EXISTS t_child_14;
DROP TABLE IF EXISTS t_child_13;
DROP TABLE IF EXISTS t_child_12;
DROP TABLE IF EXISTS t_child_11;
DROP TABLE IF EXISTS t_child_10;
DROP TABLE IF EXISTS t_child_9;
DROP TABLE IF EXISTS t_child_8;
DROP TABLE IF EXISTS t_child_7;
DROP TABLE IF EXISTS t_child_6;
DROP TABLE IF EXISTS t_child_5;
DROP TABLE IF EXISTS t_child_4;
DROP TABLE IF EXISTS t_child_3;
DROP TABLE IF EXISTS t_child_2;
DROP TABLE IF EXISTS t_child_1;
DROP TABLE IF EXISTS t_parent;

CREATE TABLE t_parent (
    id INT PRIMARY KEY
);

INSERT INTO t_parent (id) VALUES (1);
INSERT INTO t_parent (id) VALUES (2);
INSERT INTO t_parent (id) VALUES (3);
INSERT INTO t_parent (id) VALUES (4);
INSERT INTO t_parent (id) VALUES (5);
INSERT INTO t_parent (id) VALUES (6);
INSERT INTO t_parent (id) VALUES (7);
INSERT INTO t_parent (id) VALUES (8);
INSERT INTO t_parent (id) VALUES (9);
INSERT INTO t_parent (id) VALUES (10);

CREATE TABLE t_child_1 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_1 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_1 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_1 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_1 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_1 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_1 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_1 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_1 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_1 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_1 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_2 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_2 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_2 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_2 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_2 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_2 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_2 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_2 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_2 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_2 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_2 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_3 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_3 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_3 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_3 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_3 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_3 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_3 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_3 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_3 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_3 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_3 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_4 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_4 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_4 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_4 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_4 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_4 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_4 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_4 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_4 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_4 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_4 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_5 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_5 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_5 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_5 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_5 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_5 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_5 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_5 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_5 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_5 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_5 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_6 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_6 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_6 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_6 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_6 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_6 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_6 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_6 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_6 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_6 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_6 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_7 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_7 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_7 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_7 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_7 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_7 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_7 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_7 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_7 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_7 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_7 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_8 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_8 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_8 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_8 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_8 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_8 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_8 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_8 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_8 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_8 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_8 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_9 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_9 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_9 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_9 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_9 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_9 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_9 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_9 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_9 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_9 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_9 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_10 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_10 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_10 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_10 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_10 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_10 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_10 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_10 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_10 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_10 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_10 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_11 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_11 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_11 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_11 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_11 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_11 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_11 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_11 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_11 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_11 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_11 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_12 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_12 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_12 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_12 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_12 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_12 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_12 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_12 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_12 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_12 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_12 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_13 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_13 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_13 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_13 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_13 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_13 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_13 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_13 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_13 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_13 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_13 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_14 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_14 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_14 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_14 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_14 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_14 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_14 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_14 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_14 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_14 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_14 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_15 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_15 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_15 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_15 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_15 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_15 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_15 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_15 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_15 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_15 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_15 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_16 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_16 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_16 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_16 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_16 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_16 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_16 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_16 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_16 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_16 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_16 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_17 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_17 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_17 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_17 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_17 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_17 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_17 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_17 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_17 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_17 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_17 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_18 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_18 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_18 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_18 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_18 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_18 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_18 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_18 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_18 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_18 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_18 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_19 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_19 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_19 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_19 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_19 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_19 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_19 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_19 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_19 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_19 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_19 (id, parent_id) VALUES (10, 10);

CREATE TABLE t_child_20 (
    id INT PRIMARY KEY,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES t_parent(id)
);

INSERT INTO t_child_20 (id, parent_id) VALUES (1, 1);
INSERT INTO t_child_20 (id, parent_id) VALUES (2, 2);
INSERT INTO t_child_20 (id, parent_id) VALUES (3, 3);
INSERT INTO t_child_20 (id, parent_id) VALUES (4, 4);
INSERT INTO t_child_20 (id, parent_id) VALUES (5, 5);
INSERT INTO t_child_20 (id, parent_id) VALUES (6, 6);
INSERT INTO t_child_20 (id, parent_id) VALUES (7, 7);
INSERT INTO t_child_20 (id, parent_id) VALUES (8, 8);
INSERT INTO t_child_20 (id, parent_id) VALUES (9, 9);
INSERT INTO t_child_20 (id, parent_id) VALUES (10, 10);
