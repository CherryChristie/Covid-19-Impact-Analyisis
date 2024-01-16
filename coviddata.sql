create database covid_data;
use covid_data

--Which healthcare facilities had the highest average number of daily COVID-19 cases in
--2021? Display the top 10 facilities.

SELECT * FROM covid_2021;
SELECT TOP 10 P_name AS Healthcare_Facility,ROUND(AVG( Num_Weekly_Confirmed_Covid19 /7.0),2) Avg_daily_cases
FROM covid_2021
GROUP BY P_Name
ORDER BY 2 DESC; 

--Calculate the 7-day moving average of new COVID-19 cases for each healthcare facility.
--Which facility had the highest peak in the moving average?

WITH nhs_data AS (SELECT P_Name, Num_Weekly_Confirmed_Covid19, Week_Ending
FROM covid_2020
UNION ALL
SELECT P_Name, Num_Weekly_Confirmed_Covid19, Week_Ending
FROM covid_2021
UNION ALL
SELECT P_Name, Num_Weekly_Confirmed_Covid19, Week_Ending
FROM covid_2022
UNION ALL
SELECT P_Name, Num_Weekly_Confirmed_Covid19, Week_Ending
FROM covid_2023),

moving_avg_cal  AS (SELECT week_ending, P_Name,
							AVG(Num_Weekly_Confirmed_Covid19/7) OVER (PARTITION BY p_Name ORDER BY Week_Ending 
							ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) Moving_Avg
FROM nhs_data)

SELECT TOP 1 P_Name, MAX(Moving_Avg) Highest_Moving_Avg
FROM moving_avg_cal
GROUP BY P_Name
ORDER BY 2 DESC;



--Determine the total number of COVID-19 cases, deaths, and recoveries for each state.
--Include the state's name and the corresponding counts in the result.

SELECT DISTINCT P_State, SUM(Num_Weekly_Confirmed_Covid19) Total_Covid_Cases, 			
                SUM(Num_Weekly_All_Death) Total_Death,
				SUM(Num_Weekly_Confirmed_Covid19) /  NULLIF(SUM(Num_Weekly_All_Death),0) Mortality_Rate,
				SUM(Num_Weekly_Confirmed_Covid19) - SUM(Num_Weekly_All_Death) / NULLIF(SUM(Num_Weekly_Confirmed_Covid19),2)
				Recovery_Rate
FROM
(
SELECT P_State, Num_Weekly_Confirmed_Covid19 , 			
                Num_Weekly_All_Death				
FROM covid_2020 

UNION ALL
SELECT P_State,Num_Weekly_Confirmed_Covid19 , 			
                Num_Weekly_All_Death				
FROM covid_2021

UNION ALL
SELECT P_State, Num_Weekly_Confirmed_Covid19 , 			
                Num_Weekly_All_Death				
FROM covid_2022

UNION ALL
SELECT P_State, Num_Weekly_Confirmed_Covid19 , 			
                Num_Weekly_All_Death
				
FROM covid_2023
) AS State_Cases
GROUP BY P_State
ORDER BY 2 DESC;


--Find the top 5 states with the highest mortality rate (deaths per COVID-19 case) in 2022
select * from covid_2022
SELECT TOP 5 P_state, 
		ROUND(CAST(SUM( Num_Weekly_All_Death ) AS FLOAT) / CAST(SUM(Num_Weekly_Confirmed_Covid19) AS FLOAT),2) AS Mortality_Rate
FROM covid_2022
WHERE DATEPART(YEAR, Week_Ending) ='2022'
GROUP BY P_State
ORDER BY 2 DESC


-- Identify the healthcare facilities that experienced a significant increase in COVID-19
--cases from 2020 to 2021 (more than 50% increase). Display the facility names and the
--percentage increase.
-- people) in 2023.
--  dataset?
-- least 5 consecutive months. Display the facility names and the corresponding months.