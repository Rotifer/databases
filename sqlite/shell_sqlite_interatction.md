# Shell - SQLite interaction

An SQLite database can be manamged and manipulated by shell scripts. Arguments can be passed to the scripts in the normal manner
and sets of SQLite commands can be embedded in [heredocs](https://en.wikipedia.org/wiki/Here_document#Unix_shells).
This is achieved using the [_sqlite3_ tool](https://zetcode.com/db/sqlite/tool/) which is the client for the SQLite library.
To check that _sqlite3_ is available and it , type:

```{console}
which sqlite3
```

To get the version, type:

```{console}
 sqlite3 -version
```

n my Mac, I get the following output:

```{console}
3.32.3 2020-06-18
```

SQLite comes pre-installed on the Mac and is used by many of its programs. It is therefore advisable to leave it alone and install a newer version if needed.
At the time of writing, the current version is 3.36. There are some features of the later version that I would like to demonstrate.
One of these is the _markdown_ format generated by the _.output_ sqlite3 meta command. In order to allow this, I used _brew install sqlite3_ to
install the latest version. This gives me the latest version but does not interfere with the system version. To show this, if I type _brew info sqlite3_,
I get output informing me it is "__keg-only__" and that my newly installed version is independent of the system version. From this output, I also get the path to
the _brew_ version; on my system that is _/usr/local/opt/sqlite/sqlite3_. Therefore, if I want the more up-to-date version, I can use this path to invoke it but, if
the system version is suffiecient, I can simply invoke it with _sqlite3_


### A note on sqlite commands

There are two types of commands that we can use to interact with SQLite:

1. Meta commands - these begin with a dot and for that reason, are sometimes called _dot_ commands, and are __not__ terminated with a semi-colon
2. The second type of command is an SQL statement of some sort, SELECT for examples, these are terminated with a semi-colon.

## Using a _heredoc_ to send a series of commands to an SQLite database

Here is a shell script that takes three arguments that are interpolated within the heredoc and then executed by _sqlite3_.

__Loading a TSV file into an SQLite database__

```{console}
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
#
```

This script performs the following:

1. It is invoked with three command line arguments: The SQLite database name, a file name, and a table name
2. It checks that it has received three arguments
3. The first argument is inerpolated before the heredoc and passes the SQLite database name to the _sqlite3_ command
4. The second and third arguments are interpolated within heredoc

The end result is that a new table is created within the SQLite database and the contents of the fata file are used to populate this table.
The column names are taken from the first row of the file and the meta command _.mode_ instructs the script to treat the file as tab-separated values (TSV)


## Generating reports in specific formats from an SQLite database

Assuming the earlier script has been run and a database table called __hugo_genes__ is populated with values, we can use SQLite as a report generator
by setting its _.mode_ meta command value. 

__Generating formatted output__

```{sh}
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
```

We use the same command line arguments checking as before but this time the third argument is an SQL statement that is executed to generate output.
Note, in this example I have used the _brew_ version of _sqlite3_ in place of the system version. This is because the system version does not support
the _markdown_ format. This simple shell script can be used to generate data in a variety of useful formats. The _markdown_ version is especially useful
and has only recently been implemented by SQLite. 
