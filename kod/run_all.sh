#!/bin/bash
IFS= read -rs -p "Enter password: " DB_PASS
echo
echo "Running testdb"
python3 main.py -d mysql --host 127.0.0.1 --user root --db testdb --password "$DB_PASS" 2>&1 | tee results/logs/log-testdb.txt
for i in $(seq 2 18); do
    echo "Running testdb$i"
    python3 main.py -d mysql --host 127.0.0.1 --user root --db testdb$i --password "$DB_PASS" 2>&1 | tee results/logs/log-testdb$i.txt
done