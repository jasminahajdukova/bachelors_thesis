#!/bin/bash
IFS= read -rs -p "Enter password: " DB_PASS
echo

for j in $(seq 1 3); do
    echo "$j. round"
    echo "Running testdb"
    python3 main.py  --host 127.0.0.1 --user root --db testdb --password "$DB_PASS" 2>&1 | tee results/logs/"$j"log-testdb.txt
    for i in $(seq 2 18); do
        echo "Running testdb$i"
        python3 main.py --host 127.0.0.1 --user root --db testdb$i --password "$DB_PASS" 2>&1 | tee results/logs/"$j"log-testdb"$i".txt
    done
done


# for i in $(seq 1 5); do
#     echo "$i. round"
#     python3 main.py --host 127.0.0.1 --user root --db testdb14 --password "$DB_PASS"
# done