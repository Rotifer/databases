# Difference between tow tables

Also demos a function that uses dynamic SQL

```{sql}
DROP TABLE IF EXISTS prog_langs;
CREATE TABLE prog_langs(
    prog_lang_id SERIAL PRIMARY KEY,
    prog_lang_name TEXT NOT NULL,
    initial_release DATE,
    original_author TEXT,
    website TEXT
);

INSERT INTO prog_langs(prog_lang_name, initial_release, original_author, website) VALUES
  ('Java', to_date('1996-01-23', 'YYYY-MM-DD'), 'James Gosling', 'https://java.com/en/'),
  ('Python', to_date('1991-02-20', 'YYYY-MM-DD'), 'Guido van Rossum', 'https://www.python.org/'),
  ('JavaScript', to_date('1995-12-04', 'YYYY-MM-DD'), 'Brendan Eich', 'https://www.ecma-international.org/publications-and-standards/standards/ecma-262/'),
  ('Perl', to_date('1988-02-01', 'YYYY-MM-DD'), 'Larry Wall', 'https://www.perl.org/'),
  ('PHP', to_date('1996-06-08', 'YYYY-MM-DD'), 'Rasmus Lerdorf', 'https://www.php.net/'),
  ('C++', NULL, 'Bjarne Stroustrup', 'https://isocpp.org/');
  
-- Make a copy of the table
CREATE TABLE prog_langs_copy AS
SELECT * FROM prog_langs;

-- Check that the two tables identical

(   SELECT * FROM prog_langs
    EXCEPT
    SELECT * FROM prog_langs_copy)  
UNION ALL
(   SELECT * FROM prog_langs_copy
    EXCEPT
    SELECT * FROM prog_langs) ;
    
-- No rows returned

-- Let's mutate some rows
-- Firstly, is PG case-sensitive by default?
UPDATE prog_langs_copy
SET prog_lang_name = 'JAVA'
WHERE prog_lang_name = 'Java';

-- Rerun the difference query
-- Yes, it is case-sensitive by default.

-- This is a useful peice of functionality so let's turn it into a function
DROP FUNCTION IF EXISTS table_difference(TEXT, TEXT);
CREATE OR REPLACE FUNCTION table_difference(p_table_a TEXT, p_table_b TEXT)
RETURNS INTEGER
LANGUAGE 'plpgsql'
AS
$BODY$
DECLARE
  l_sql TEXT := format('
SELECT COUNT(*)
FROM (
(    SELECT * FROM %I 
    EXCEPT
    SELECT * FROM %I)  
UNION ALL
(   SELECT * FROM %I
    EXCEPT
    SELECT * FROM %I)) sq', p_table_a, p_table_b, p_table_b, p_table_a);
  l_row_count_difference INTEGER := 0;
BEGIN
  EXECUTE l_sql INTO l_row_count_difference;
  RETURN l_row_count_difference;
END
$BODY$;
-- Call the function
-- This actually works

SELECT * FROM table_difference('prog_langs', 'prog_langs_copy');
```

