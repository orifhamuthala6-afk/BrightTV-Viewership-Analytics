-- Databricks notebook source
------checking the data
SELECT*
FROM brighttv.brighttvcasestudy.userprofiles
LIMIT 10;
-- checking for duplicates in my data
SELECT UserID,
COUNT(*) AS duplicate_count
FROM brighttv.brighttvcasestudy.userprofiles
GROUP BY UserID
HAVING COUNT(*) > 1;

-- I am checking the size pf the data
SELECT COUNT(*) AS number_of_rows,
COUNT(DISTINCT UserID) AS number_subs
FROM brighttv.brighttvcasestudy.userprofiles;

-- Are the any rows where useRID is NULL
SELECT COUNT(*) AS cnt
FROM brighttv.brighttvcasestudy.userprofiles
WHERE UserID IS NULL;

------checkin the unique user
SELECT DISTINCT UserID
FROM brighttv.brighttvcasestudy.userprofiles;

--Gender Checks
SELECT DISTINCT gender
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT COUNT(*)
FROM brighttv.brighttvcasestudy.userprofiles
WHERE gender=' ';

SELECT
COUNT(DISTINCT userid) AS subs,
CASE
WHEN gender =' ' THEN 'None'
ELSE gender
END AS Gender
FROM brighttv.brighttvcasestudy.userprofiles
GROUP BY Gender;

--Race Checks
SELECT DISTINCT Race
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT DISTINCT
CASE
WHEN Race='other' THEN 'None'
WHEN Race=' ' THEN 'None'
ELSE Race
END AS Race
FROM brighttv.brighttvcasestudy.userprofiles;

--Province Checks
SELECT DISTINCT Province
FROM  brighttv.brighttvcasestudy.userprofiles;

SELECT DISTINCT
CASE
WHEN Province=' ' THEN 'Uncategorized'
WHEN Province='None' THEN 'Uncategorized'
ELSE Province
END AS Region
FROM  brighttv.brighttvcasestudy.userprofiles;

-- -------checking for Age
SELECT MIN(Age) AS min_age,
MAX(Age) AS max_age 
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT COUNT(*) AS cnt
FROM brighttv.brighttvcasestudy.userprofiles
WHERE age IS NULL;

WITH user_profiles AS (
SELECT UserID,
CASE
WHEN Province=' ' THEN 'Uncategorized'
WHEN Province='None' THEN 'Uncategorized'
ELSE Province
END AS Region,
age,
CASE
WHEN age = 0 THEN 'Infants'
WHEN age BETWEEN 1 AND 12 THEN 'Kids'
WHEN age BETWEEN 13 AND 19 THEN 'Teenager'
WHEN age BETWEEN 20 AND 35 THEN 'Youth'
WHEN age BETWEEN 36 AND 50 THEN 'Adult'
WHEN age BETWEEN 51 AND 65 THEN 'Elder'
WHEN age >65 THEN 'Pensioner'
END AS age_groups,
CASE
WHEN (email IS NOT NULL )OR (email=' ') OR (email NOT IN ('None'))THEN 1
ELSE 0
END AS email_flag,
CASE
WHEN `Social Media Handle` IS NOT NULL OR `Social Media Handle`=' ' OR `Social Media Handle` NOT IN ('None')THEN 1
ELSE 0
END AS sm_flag,
CASE
WHEN Race='other' THEN 'None'
WHEN Race=' ' THEN 'None'
ELSE Race
END AS Race,
CASE
WHEN gender =' ' THEN 'None'
ELSE gender
END AS Gender
FROM brighttv.brighttvcasestudy.userprofiles
)
SELECT *
FROM user_profiles;

