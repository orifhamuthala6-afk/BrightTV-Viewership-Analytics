-- Databricks notebook source
---------------------------------------------------------checking data
SELECT*
FROM brighttv.brighttvcasestudy.viewership
LIMIT 10;

---------------------------------------------------------checking if there is any row where userID IS empty
SELECT*
FROM brighttv.brighttvcasestudy.viewership
WHERE userID0 IS NULL OR  Userid4 IS NULL;
--------------------------------------------------------checking if UserID0 and Userid4  are  they are the same
SELECT  UserID0,
UserID4,
CASE
WHEN UserID0 = UserID4 THEN 'Same'
ELSE 'Different'
END AS Comparison
FROM brighttv.brighttvcasestudy.viewership;
--------------------------------------------------------checking if for duplicate in userids
SELECT *
FROM brighttv.brighttvcasestudy.viewership
WHERE UserID0 <> UserID4;

--------- Applying DATE FUNCTIONS these are used in the date column to extract date
SELECT TO_DATE(RecordDate2) AS watch_date
FROM brighttv.brighttvcasestudy.viewership;

--------- extract the dates using more DATE FUNCTIONS names, year, and day
SELECT
RecordDate2,
TO_DATE(RecordDate2) AS watch_date, --TO_DATE Converts a string into a date YYYT-MM-DD
DAYNAME(TO_DATE(RecordDate2)) AS day_name, -- Extracts the day name
MONTHNAME(TO_DATE(RecordDate2)) AS month_name, -- Extracts the month name
YEAR(TO_DATE(RecordDate2)) AS event_year, -- Extracts the year value
DAY(TO_DATE(RecordDate2)) AS event_dt -- Extracts day value
FROM brighttv.brighttvcasestudy.viewership;

---------Date functions can be incorporated into a CASE statement to apply conditional logic based on date values.

CREATE OR REPLACE TEMPORARY VIEW viewership AS (
SELECT COALESCE(UserID0,userid4) AS userid,
TO_CHAR(RecordDate2, 'yyyyMM') AS month_id,
TO_DATE(RecordDate2) AS watch_date,
--TIME(RecordDate2) AS watch_time,
TO_CHAR(RecordDate2, 'DD') AS day_of_week,
DAYNAME(RecordDate2) AS day_name,
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
);
select*
FROM brighttv.brighttvcasestudy.viewership
