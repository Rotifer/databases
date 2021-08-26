#!/bin/bash

# Invoke as:
# ./heredoc_sqlite_cmds.sh genes.db gene_with_protein_product_head100.txt hugo_genes


if [ "$#" -ne 3 ]; then
    echo "Error! Expected three arguments got $# Exiting!"
    exit 1

fi
SQLITE_DB_NAME=$1
TSV_FILE_NAME=$2
SQLITE_TABLE_NAME=$3


sqlite3 $SQLITE_DB_NAME <<EOF
.mode tabs
DROP TABLE IF EXISTS $SQLITE_TABLE_NAME;
.import $TSV_FILE_NAME $SQLITE_TABLE_NAME
EOF

echo "$SQLITE_TABLE_NAME table loaded";

