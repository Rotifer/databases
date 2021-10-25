# Notes


Expanded display

test=# \x
Expanded display is on.

```sql
-- What version of PostgreSQL is running
SELECT version();

SELECT * FROM pg_settings WHERE name = 'port';
```



```console
# Connecting to PosstgreSQL
$ psql -p 5435 -h localhost -U postgres
```

The very useful -E option, for example:

```console
$ psql -E -p 5435 -h localhost -U postgres
$ \l meta command t list databases
```

```console
postgres=# CREATE DATABASE hschoenig;
CREATE DATABASE
postgres=# \c hschoenig 
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
You are now connected to database "hschoenig" as user "postgres".
hschoenig=# CREATE TABLE t_location (name text);
CREATE TABLE
hschoenig=# COPY t_location FROM PROGRAM
hschoenig-# 'curl https://www.cybertec-postgresql.com/secret/orte.txt';
COPY 2354
hschoenig=# SELECT * FROM t_location LIMIT 2;
```

I want to find out details about queries running on my PostgreSQL database, what view do I query?
Answer pg_stat_activity

```sql
SELECT * FRPM pg_stat_activity;
```

There are two functions to terminate queries, what are their names and what is the difference between them?

pg_cancel_backend : The pg_cancel_backend function will terminate the
query but will leave the connection in place.
pg_terminate_backend : The pg_terminate_backend function is a bit more
radical and will kill the entire database connection, along with the query.

If you want to disconnect all other users but yourself, here is how you can do this:

```sql
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE pid <> pg_backend_pid()
AND backend_type = 'client backend';
```

What does **pg_stat_database** return?
I returns one line per database inside your PostgreSQL instance.
Its column *numbackends* shows the number of database connections that are currently open.

The tup_ columns will tell you whether there is a lot of reading or a lot of writing going on
in your system.
Then, we have temp_files and temp_bytes . These two columns are of incredible
importance because they will tell you whether your database has to write temporary files to
disk, which will inevitably slow down operations.

If your **work_mem** settings are too low, there is no way to do
anything in RAM, and therefore PostgreSQL will go to disk.

T0 see what's going on in individual tables, use 
- pg_stat_user_tables
- pg_statio_user_tables

Schoenig says **pg_stat_user_tables** is very important for performance monitoring

Why is **HOT UPDATE** important?
HOT UPDATE is pretty good because it allows PostgreSQL to ensure that a row
doesn't have to leave a block.

One way to use pg_stat_user_tables is to detect which tables
may need an index.

```sql
SELECT schemaname, relname, seq_scan, seq_tup_read,
seq_tup_read / seq_scan AS avg, idx_scan
FROM pg_stat_user_tables
WHERE seq_scan > 0
ORDER BY seq_tup_read DESC LIMIT 25;
```

Note that this query is really golden – it will help you spot tables with missing indexes. My
practical experience, which is nearly two decades' worth, has shown again and again that
missing indexes are the single most important cause of bad performance. Therefore, the
query you are looking at is like gold.

If you want t find out about table caching behaviour, which view should you query?
**pg_statio_user_tables**

What does TOAST stand for? The Over-sized Attribute Storage Technique

having hundreds of gigabytes of
pointless indexes can seriously harm your overall performance

What view can be inspected to find pointless indexes?
**pg_stat_user_indexes**


Useful query:

```sql
SELECT schemaname, relname, indexrelname, idx_scan,
pg_size_pretty(pg_relation_size(indexrelid)) AS idx_size,
pg_size_pretty(sum(pg_relation_size(indexrelid))
OVER (ORDER BY idx_scan, indexrelid)) AS total
FROM
pg_stat_user_indexes
ORDER BY 6 ;
```

What view do we use to see how data is written to disk?
**pg_stat_bgwriter**
The first two columns are important

Ehat does *pg_stat_archiver* tell us? Something about about the
archiver process moving the transaction log (WAL) from the main server to a backup
device

But what if you are a developer who wants to inspect
an individual transaction? **pg_stat_xact_user_tables** is here to help.

The ideal way for application developers to use this view is to add a function call in the
application before a commit to track what the transaction has done.

The view **pg_stat_progress_vacuum** was implemented to to tract the vacuum process

To see what CREATE INDEX is doing, use **pg_stat_progress_create_index**

one of the most important views, which can be used to spot performance problems. I am, of
course, speaking about **pg_stat_statements**.

This is not implmented by default.
To do so, need to alter postgresql.conf, re-start the server and CREATE EXTENSION
Do this as an exercise!

pg_stat_statements provides simply fabulous information. For every user
in every database, it provides one line per query. By default, it tracks 5,000 statements (this
can be changed by setting pg_stat_statements.max ).

**pg_stat_statements** is by far the easiest way to track down performance problems

For logging the **postgresql.conf** file contains all the parameters you need so that you're provided
with all the necessary information.

On Unix systems, PostgreSQL will send log information to stderr by default.

As we can see, the **work_mem** variable governs the size of the hash that's used by the GROUP
BY clause.

```console
SHOW work_mem;
```

To speed up the query, a higher value for the work_mem variable can be set on the fly (and,
of course, globally):

```console
test=# SET work_mem TO '1 GB';
```

More memory will lead to faster sorting and will speed up the system.

There are more operations that actually have to do some sorting or memory allocation of
some kind. The administrative ones such as the CREATE INDEX clause don't rely on
the work_mem variable and use the **maintenance_work_mem** variable instead.

In PostgreSQL 11, an additional feature was added to the database engine: PostgreSQL is
now able to build btree indexes in parallel, which can dramatically speed up the indexing
of large tables.

```console
test=# SHOW max_parallel_maintenance_workers;
```

The important thing is this: if a table is small, it will never
use parallelism. The size of a table has to be at least 8 MB, as defined by the following
configuration setting:

```sql
test=# SHOW min_parallel_table_scan_size;
```

```sql
hschoenig=# SHOW max_worker_processes;
 max_worker_processes 
----------------------
 8
(1 row)

hschoenig=# SHOW max_worker_processes;
```

interprocess communication is really expensive

when
JIT compilation is enabled, PostgreSQL will check your query, and if it happens to be time-
consuming enough, highly optimized code for your query will be created on the fly



