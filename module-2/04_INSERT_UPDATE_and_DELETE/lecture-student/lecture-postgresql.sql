-- INSERT

-- 1. Add Klingon as a spoken language in the USA
INSERT INTO countrylanguage(countrycode, language, isofficial, percentage)
VALUES ('USA', 'Klingon', false, 5);

SELECT *
FROM countrylanguage
WHERE countrycode = 'USA';

-- 2. Add Klingon as a spoken language in Great Britain (GBR)
INSERT INTO countrylanguage(countrycode, language, isofficial, percentage)
VALUES ('GBR', 'Klingon', false, 5);

SELECT *
FROM countrylanguage
WHERE countrycode = 'GBR';

-- UPDATE
-- UPDATE table_name
-- SET column=value
-- WHERE column = value

-- 1. Update the capital of the USA to Houston
SELECT id
FROM city
WHERE name = 'Houston';

UPDATE country
SET capital = 3796
SELECT * FROM country
WHERE code = 'USA';

SELECT country.code, city.name
FROM country
INNER JOIN city ON country.capital = city.id
WHERE code = 'USA';

-- ALSO use subqueries

UPDATE country
SET capital = (SELECT id FROM city WHERE name = 'Houston')
--SELECT * FROM country
WHERE code = 'USA';

-- 2. Update the capital of the USA to Washington DC and the head of state
UPDATE country
SET capital = (SELECT id FROM city WHERE name = 'Washington'), 
        headofstate = 'Elon Musk'
--SELECT * FROM country
WHERE code = 'USA';

-- DELETE
--DELETE FROM table_name
--WHERE column = value

-- 1. Delete English as a spoken language in the USA
DELETE 
--SELECT *
FROM countrylanguage
WHERE language = 'English' AND countrycode = 'USA';

-- 2. Delete all occurrences of the Klingon language 
DELETE
--SELECT *
FROM countrylanguage
WHERE language = 'Klingon';


-- REFERENTIAL INTEGRITY

-- 1. Try just adding Elvish to the country language table.
INSERT INTO countrylanguage(language)
VALUES ('Elvish');

-- 2. Try inserting English as a spoken language in the country ZZZ. What happens?
INSERT INTO countrylanaguage(countrycode, language, isofficial, percentage)
VALUES ('ZZZ', 'English', false, 5);

-- 3. Try deleting the country USA. What happens?
DELETE FROM country
WHERE code = 'USA';


-- CONSTRAINTS

-- 1. Try inserting English as a spoken language in the USA
INSERT INTO countrylanguage(language, isofficial, percentage, countrycode)
VALUES('English', false, 90, 'USA');

-- 2. Try again. What happens?
INSERT INTO countrylanguage(language, isofficial, percentage, countrycode)
VALUES('English', false, 90, 'USA');

-- 3. Let's relocate the USA to the continent - 'Outer Space'
UPDATE country
SET continent = 'Outer Space'
WHERE code = 'USA';

-- How to view all of the constraints

SELECT pg_constraint.*
FROM pg_catalog.pg_constraint
INNER JOIN pg_catalog.pg_class ON pg_class.oid = pg_constraint.conrelid
INNER JOIN pg_catalog.pg_namespace ON pg_namespace.oid = connamespace;


-- TRANSACTIONS

-- 1. Try deleting all of the rows from the country language table and roll it back.
START TRANSACTION;

SELECT *
FROM countrylanguage;

DELETE
FROM countrylanguage;

SELECT *
FROM countrylanguage;

--COMMIT
ROLLBACK;

-- 2. Try updating all of the cities to be in the USA and roll it back

START TRANSACTION;

UPDATE city
SET countrycode = 'USA';

SELECT *
FROM city;

ROLLBACK;

-- 3. Demonstrate two different SQL connections trying to access the same table where one happens to be inside of a transaction but hasn't committed yet.
START TRANSACTION;
UPDATE countrylanguage
SET percentage = 60
WHERE language = 'English' AND countrycode = 'USA';

ROLLBACK;