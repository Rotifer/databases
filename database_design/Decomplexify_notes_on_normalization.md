# Normal Forms

Taken from the [Youtube video](Learn Database Normalization - 1NF, 2NF, 3NF, 4NF, 5NF)

## First Normal Form (1NF)

- Using row order to convey information is not permitted.
- Mixing data types within the same column is not permitted.
- Having a table without a primary key is not permitted.
- Repeating groups are not permitted.

## Second Normal Form (2NF)

- Each non-key attribute in the table must be dependent on the entire primary key.

## Third Normal Form (3NF)

- Each non-key attribute in the table must depend on the key. the whole key, and nothing but the key.

## Boyce-Codd Normal Form (BCNF)

- Each attribute in the table must depend on the key. the whole key, and nothing but the key.

## Fourth Normal Form

- The only kinds of multivalues dependency allowed in a table are multivalued dependencies on the key.

## Fifth Normal Form (5NF)

- It must not be possible to describe the tables as being the logical result of joining some other tables together.

