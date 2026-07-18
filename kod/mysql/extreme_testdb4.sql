CREATE DATABASE IF NOT EXISTS extreme_testdb4;
USE extreme_testdb4;

DROP TABLE IF EXISTS t_wide;

CREATE TABLE t_wide (
    id INT PRIMARY KEY,
    col_1 VARCHAR(50),
    col_2 DECIMAL(10,2),
    col_3 DATE,
    col_4 INT,
    col_5 VARCHAR(50),
    col_6 DECIMAL(10,2),
    col_7 DATE,
    col_8 INT,
    col_9 VARCHAR(50),
    col_10 DECIMAL(10,2),
    col_11 DATE,
    col_12 INT,
    col_13 VARCHAR(50),
    col_14 DECIMAL(10,2),
    col_15 DATE,
    col_16 INT,
    col_17 VARCHAR(50),
    col_18 DECIMAL(10,2),
    col_19 DATE,
    col_20 INT,
    col_21 VARCHAR(50),
    col_22 DECIMAL(10,2),
    col_23 DATE,
    col_24 INT,
    col_25 VARCHAR(50),
    col_26 DECIMAL(10,2),
    col_27 DATE,
    col_28 INT,
    col_29 VARCHAR(50),
    col_30 DECIMAL(10,2),
    col_31 DATE,
    col_32 INT,
    col_33 VARCHAR(50),
    col_34 DECIMAL(10,2),
    col_35 DATE,
    col_36 INT,
    col_37 VARCHAR(50),
    col_38 DECIMAL(10,2),
    col_39 DATE,
    col_40 INT,
    col_41 VARCHAR(50),
    col_42 DECIMAL(10,2),
    col_43 DATE,
    col_44 INT,
    col_45 VARCHAR(50),
    col_46 DECIMAL(10,2),
    col_47 DATE,
    col_48 INT,
    col_49 VARCHAR(50)
);

INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (1, 'val_1_0', 2.00, '2026-01-01', 100, 'val_5_0', 6.00, '2026-01-01', 100, 'val_9_0', 10.00, '2026-01-01', 100, 'val_13_0', 14.00, '2026-01-01', 100, 'val_17_0', 18.00, '2026-01-01', 100, 'val_21_0', 22.00, '2026-01-01', 100, 'val_25_0', 26.00, '2026-01-01', 100, 'val_29_0', 30.00, '2026-01-01', 100, 'val_33_0', 34.00, '2026-01-01', 100, 'val_37_0', 38.00, '2026-01-01', 100, 'val_41_0', 42.00, '2026-01-01', 100, 'val_45_0', 46.00, '2026-01-01', 100, 'val_49_0');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (2, 'val_1_1', 2.01, '2026-01-02', 101, 'val_5_1', 6.01, '2026-01-02', 101, 'val_9_1', 10.01, '2026-01-02', 101, 'val_13_1', 14.01, '2026-01-02', 101, 'val_17_1', 18.01, '2026-01-02', 101, 'val_21_1', 22.01, '2026-01-02', 101, 'val_25_1', 26.01, '2026-01-02', 101, 'val_29_1', 30.01, '2026-01-02', 101, 'val_33_1', 34.01, '2026-01-02', 101, 'val_37_1', 38.01, '2026-01-02', 101, 'val_41_1', 42.01, '2026-01-02', 101, 'val_45_1', 46.01, '2026-01-02', 101, 'val_49_1');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (3, 'val_1_2', 2.02, '2026-01-03', 102, 'val_5_2', 6.02, '2026-01-03', 102, 'val_9_2', 10.02, '2026-01-03', 102, 'val_13_2', 14.02, '2026-01-03', 102, 'val_17_2', 18.02, '2026-01-03', 102, 'val_21_2', 22.02, '2026-01-03', 102, 'val_25_2', 26.02, '2026-01-03', 102, 'val_29_2', 30.02, '2026-01-03', 102, 'val_33_2', 34.02, '2026-01-03', 102, 'val_37_2', 38.02, '2026-01-03', 102, 'val_41_2', 42.02, '2026-01-03', 102, 'val_45_2', 46.02, '2026-01-03', 102, 'val_49_2');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (4, 'val_1_3', 2.03, '2026-01-04', 103, 'val_5_3', 6.03, '2026-01-04', 103, 'val_9_3', 10.03, '2026-01-04', 103, 'val_13_3', 14.03, '2026-01-04', 103, 'val_17_3', 18.03, '2026-01-04', 103, 'val_21_3', 22.03, '2026-01-04', 103, 'val_25_3', 26.03, '2026-01-04', 103, 'val_29_3', 30.03, '2026-01-04', 103, 'val_33_3', 34.03, '2026-01-04', 103, 'val_37_3', 38.03, '2026-01-04', 103, 'val_41_3', 42.03, '2026-01-04', 103, 'val_45_3', 46.03, '2026-01-04', 103, 'val_49_3');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (5, 'val_1_4', 2.04, '2026-01-05', 104, 'val_5_4', 6.04, '2026-01-05', 104, 'val_9_4', 10.04, '2026-01-05', 104, 'val_13_4', 14.04, '2026-01-05', 104, 'val_17_4', 18.04, '2026-01-05', 104, 'val_21_4', 22.04, '2026-01-05', 104, 'val_25_4', 26.04, '2026-01-05', 104, 'val_29_4', 30.04, '2026-01-05', 104, 'val_33_4', 34.04, '2026-01-05', 104, 'val_37_4', 38.04, '2026-01-05', 104, 'val_41_4', 42.04, '2026-01-05', 104, 'val_45_4', 46.04, '2026-01-05', 104, 'val_49_4');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (6, 'val_1_5', 2.05, '2026-01-06', 105, 'val_5_5', 6.05, '2026-01-06', 105, 'val_9_5', 10.05, '2026-01-06', 105, 'val_13_5', 14.05, '2026-01-06', 105, 'val_17_5', 18.05, '2026-01-06', 105, 'val_21_5', 22.05, '2026-01-06', 105, 'val_25_5', 26.05, '2026-01-06', 105, 'val_29_5', 30.05, '2026-01-06', 105, 'val_33_5', 34.05, '2026-01-06', 105, 'val_37_5', 38.05, '2026-01-06', 105, 'val_41_5', 42.05, '2026-01-06', 105, 'val_45_5', 46.05, '2026-01-06', 105, 'val_49_5');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (7, 'val_1_6', 2.06, '2026-01-07', 106, 'val_5_6', 6.06, '2026-01-07', 106, 'val_9_6', 10.06, '2026-01-07', 106, 'val_13_6', 14.06, '2026-01-07', 106, 'val_17_6', 18.06, '2026-01-07', 106, 'val_21_6', 22.06, '2026-01-07', 106, 'val_25_6', 26.06, '2026-01-07', 106, 'val_29_6', 30.06, '2026-01-07', 106, 'val_33_6', 34.06, '2026-01-07', 106, 'val_37_6', 38.06, '2026-01-07', 106, 'val_41_6', 42.06, '2026-01-07', 106, 'val_45_6', 46.06, '2026-01-07', 106, 'val_49_6');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (8, 'val_1_7', 2.07, '2026-01-08', 107, 'val_5_7', 6.07, '2026-01-08', 107, 'val_9_7', 10.07, '2026-01-08', 107, 'val_13_7', 14.07, '2026-01-08', 107, 'val_17_7', 18.07, '2026-01-08', 107, 'val_21_7', 22.07, '2026-01-08', 107, 'val_25_7', 26.07, '2026-01-08', 107, 'val_29_7', 30.07, '2026-01-08', 107, 'val_33_7', 34.07, '2026-01-08', 107, 'val_37_7', 38.07, '2026-01-08', 107, 'val_41_7', 42.07, '2026-01-08', 107, 'val_45_7', 46.07, '2026-01-08', 107, 'val_49_7');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (9, 'val_1_8', 2.08, '2026-01-09', 108, 'val_5_8', 6.08, '2026-01-09', 108, 'val_9_8', 10.08, '2026-01-09', 108, 'val_13_8', 14.08, '2026-01-09', 108, 'val_17_8', 18.08, '2026-01-09', 108, 'val_21_8', 22.08, '2026-01-09', 108, 'val_25_8', 26.08, '2026-01-09', 108, 'val_29_8', 30.08, '2026-01-09', 108, 'val_33_8', 34.08, '2026-01-09', 108, 'val_37_8', 38.08, '2026-01-09', 108, 'val_41_8', 42.08, '2026-01-09', 108, 'val_45_8', 46.08, '2026-01-09', 108, 'val_49_8');
INSERT INTO t_wide (id, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19, col_20, col_21, col_22, col_23, col_24, col_25, col_26, col_27, col_28, col_29, col_30, col_31, col_32, col_33, col_34, col_35, col_36, col_37, col_38, col_39, col_40, col_41, col_42, col_43, col_44, col_45, col_46, col_47, col_48, col_49) VALUES (10, 'val_1_9', 2.09, '2026-01-10', 109, 'val_5_9', 6.09, '2026-01-10', 109, 'val_9_9', 10.09, '2026-01-10', 109, 'val_13_9', 14.09, '2026-01-10', 109, 'val_17_9', 18.09, '2026-01-10', 109, 'val_21_9', 22.09, '2026-01-10', 109, 'val_25_9', 26.09, '2026-01-10', 109, 'val_29_9', 30.09, '2026-01-10', 109, 'val_33_9', 34.09, '2026-01-10', 109, 'val_37_9', 38.09, '2026-01-10', 109, 'val_41_9', 42.09, '2026-01-10', 109, 'val_45_9', 46.09, '2026-01-10', 109, 'val_49_9');