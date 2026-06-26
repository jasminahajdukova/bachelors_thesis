#!/bin/bash
python3 main.py -d mysql --host 127.0.0.1 --user root --db testdb
for i in $(seq 2 18); do
    echo "Running testdb$i"
    python3 main.py -d mysql --host 127.0.0.1 --user root --db testdb$i
done