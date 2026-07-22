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
--------------------------------------------------------Converting duration to date function
SELECT UserID0,
TO_Date(RecordDate2)AS watch_Date,
DAYNAME(TO_DATE(RecordDate2))AS Day_Name,
MONTHNAME(TO_DATE(RecordDate2))AS Month_Name,
YEAR(TO_DATE(RecordDate2))AS Event_year,
DAY(TO_DATE(RecordDate2))AS WATCH_DAY,
CASE        
WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN 'weekend'         
ELSE 'weekday'     END AS day_classification
FROM brighttv.brighttvcasestudy.viewership;
--------------------------------------------------------case statement for 
SELECT Channel2,
CASE     
WHEN Channel2 IN ('SawSee','Sawsee') THEN 'SawSee'         
WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'Supersport Live Events', 'DStv Events 1') THEN 'Live Events'     
ELSE Channel2     
END AS Tv_channel
FROM brighttv.brighttvcasestudy.viewership;
--------------------------------------------------------date_format(RecordDate2, 'HH:mm:ss') AS watch_time
SELECT RecordDate2,
date_format(RecordDate2, 'HH:mm:ss') AS watch_time,
CASE         
WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight'        
WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'         
WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon'        
WHEN date_format(RecordDate2, 'HH:mm:ss') BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening'    
END AS time_of_day 
FROM brighttv.brighttvcasestudy.viewership;
--------------------------------------------------------DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration
SELECT RecordDate2,
date_format(RecordDate2, 'HH:mm:ss') AS watch_time,
date_format(`Duration 2`, 'HH:mm:ss') AS duration,
CASE         
WHEN date_format(`Duration 2`, 'HH:mm:ss') BETWEEN '00:05:00' AND '00:30:00' THEN '01. Low Usage: <30 min'         
WHEN date_format(`Duration 2`, 'HH:mm:ss') BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage: <60 min'         
WHEN date_format(`Duration 2`, 'HH:mm:ss') > '00:59:59' THEN '03. High Usage: >60 min'         
ELSE '04. No Usage'     
END AS screen_time_bucket
FROM brighttv.brighttvcasestudy.viewership

