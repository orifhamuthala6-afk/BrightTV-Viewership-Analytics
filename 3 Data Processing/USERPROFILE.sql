-- Databricks notebook source
SELECT *
FROM brighttv.brighttvcasestudy.userprofiles
LIMIT 10;

SELECT UserID, COUNT(*) AS duplicate_count
FROM brighttv.brighttvcasestudy.userprofiles
GROUP BY UserID
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS number_of_rows,
COUNT(DISTINCT UserID) AS number_subs
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT COUNT(*) AS number_of_rows,
COUNT(DISTINCT UserID) AS number_subs
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT COUNT(*) AS cnt
FROM brighttv.brighttvcasestudy.userprofiles
WHERE UserID IS NULL;

SELECT DISTINCT UserID
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT DISTINCT gender
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT COUNT(*)
FROM  brighttv.brighttvcasestudy.userprofiles
WHERE gender=' ';

SELECT
COUNT(DISTINCT userid) AS subs,
CASE
WHEN gender =' ' THEN 'None' 
ELSE gender
END AS Gender
FROM brighttv.brighttvcasestudy.userprofiles
GROUP BY Gender;

SELECT COUNT(*) AS num_rows
FROM brighttv.brighttvcasestudy.userprofiles
WHERE Race IS NULL;

SELECT DISTINCT Race
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT DISTINCT
CASE
WHEN Race='other' THEN 'None'
WHEN Race=' ' THEN 'None'
ELSE Race
END AS Race
FROM brighttv.brighttvcasestudy.userprofiles;
 
SELECT DISTINCT Province
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT DISTINCT
CASE
WHEN Province=' ' THEN 'Uncategorized'
WHEN Province='None' THEN 'Uncategorized'
ELSE Province
END AS Region
FROM brighttv.brighttvcasestudy.userprofiles;

SELECT DISTINCT
MIN(Age) AS Youngest_Age,
MAX(Age) AS Oldest_Age,
AVG(Age) AS Average_Age
FROM `brighttv`.`brighttvcasestudy`.`userprofiles`;

SELECT COUNT(*) AS cnt
FROM `brighttv`.`brighttvcasestudy`.`userprofiles`
WHERE age IS NULL;

WITH user_profiles AS (
SELECT UserID,
CASE
WHEN Province=' ' THEN 'Uncategorized'
WHEN Province='None' THEN 'Uncategorized'
ELSE Province
END AS Region,

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
),
viewership AS (
SELECT
COALESCE(UserID0,userid4) AS userid,
TO_CHAR(RecordDate2, 'yyyyMM') AS month_id,
TO_DATE(RecordDate2) AS watch_date,
--TIME(RecordDate2) AS watch_time,
TO_CHAR(RecordDate2, 'DD') AS WATCH_DAY,
DAYNAME(RecordDate2) AS  day_name,
CASE
WHEN day_name IN ('Sat', 'Sun') THEN 'weekend'
ELSE 'weekday'
END AS day_classification,
MONTHNAME(RecordDate2) AS month_name,
CASE
WHEN Channel2 IN ('SawSee','Sawsee') THEN 'SawSee'
WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'Supersport Live Events',
'DStv Events 1') THEN 'Live Events'
ELSE Channel2
END AS Tv_channel,

date_format(RecordDate2, 'HH:mm:ss') AS watch_time,
CASE
WHEN watch_time BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight'
WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon'
WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening'
END AS time_of_day,

DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration,
CASE
WHEN duration BETWEEN '00:05:00' AND '00:30:00' THEN '01. Low Usage: <30 min'
WHEN duration BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage: <60 min'
WHEN duration > '00:59:59' THEN '03. High Usage: >60 min'
ELSE '04. No Usage'
END AS screen_time_bucket,
HOUR(RecordDate2) AS hour_of_day
FROM brighttv.brighttvcasestudy.viewership
)
SELECT COALESCE(A.userid, B.UserID) AS sub_id,
month_id,
watch_date,
WATCH_DAY,
day_name,
day_classification,
month_name,
Tv_channel,
time_of_day,
hour_of_day,
screen_time_bucket,
--user_flag,
duration,
Region,
age_groups,
email_flag,
sm_flag,
Race,
Gender
FROM viewership AS A
LEFT JOIN user_profiles AS B
ON A.userid = B.UserID;


