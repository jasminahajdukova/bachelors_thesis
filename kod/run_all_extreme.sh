#!/bin/bash
IFS= read -rs -p "Enter password: " DB_PASS
echo

for j in $(seq 1 1); do
    echo "$j. round"
    echo "Running testdb"
    python3 main.py --host 127.0.0.1 --user root --db extreme_testdb --password "$DB_PASS" 2>&1 | tee results/logs/EXTREME-"$j"log-extreme_testdb.txt
    for i in $(seq 2 4); do
        echo "Running testdb$i"
        python3 main.py --host 127.0.0.1 --user root --db extreme_testdb"$i" --password "$DB_PASS" 2>&1 | tee results/logs/EXTREME-"$j"log-extreme_testdb"$i".txt
    done
done
