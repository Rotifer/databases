#!/bin/bash

# Invoke as:
# ./generate_table_output_format.sh genes.db markdown "SELECT name, symbol, location FROM hugo_genes LIMIT 10"

if [ "$#" -ne 3 ]; then
    echo "Error! Expected three arguments got $# Exiting!"
    exit 1

fi

SQLITE_DB_NAME=$1
MODE=$2
SELECT_SQL=$3

/usr/local/opt/sqlite/bin/sqlite3 $SQLITE_DB_NAME <<EOF
.headers on
.mode $MODE
${SELECT_SQL};
EOF

