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
--percentage increase.WITH year2020 AS (SELECT P_Name, SUM(Num_Weekly_Confirmed_Covid19) AS Total_Cases_2020								FROM covid_2020								WHERE Week_Ending 								BETWEEN '2020-01-01' AND '2020-12-31'								GROUP BY P_Name),year2021 AS (SELECT P_Name, SUM(Num_Weekly_Confirmed_Covid19) AS Total_Cases_2021								FROM covid_2021								WHERE Week_Ending 								BETWEEN '2021-01-01' AND '2021-12-31'								GROUP BY P_Name)SELECT case2020.P_Name, (( Total_Cases_2021 - Total_Cases_2020)  / (Total_Cases_2020) * 100) Percentage_IncreaseFROM year2020 case2020JOIN year2021 case2021 ON case2020.P_Name= case2021.P_Name WHERE Total_Cases_2020 <> 0 AND Total_Cases_2021 <>0 AND (( Total_Cases_2021 - Total_Cases_2020) /Total_Cases_2020 * 100) > 50.0ORDER BY 2 DESC -- . Calculate the average length of hospital stay for COVID-19 patientsselect * FROM covid_2020-- Subtract a fixed number of days to estimate the admission date -- Calculate the difference in days to estimate the length of stay SELECT '2020'  Year , SUM(Num_Weekly_Admit_Covid19) - SUM(Num_Weekly_Covid19_Deaths) AVG_StayFROM  covid_2020WHERE  Num_Weekly_Admit_Covid19 > 0UNION ALLSELECT '2021' Year,SUM(Num_Weekly_Admit_Covid19) - SUM(Num_Weekly_Covid19_Deaths) AVG_StayFROM  covid_2021WHERE  Num_Weekly_Admit_Covid19 > 0UNION ALLSELECT '2022' Year,SUM(Num_Weekly_Admit_Covid19) - SUM(Num_Weekly_Covid19_Deaths) AVG_StayFROM  covid_2022WHERE  Num_Weekly_Admit_Covid19 > 0UNION ALLSELECT '2023' Year, SUM(Num_Weekly_Admit_Covid19) - SUM(Num_Weekly_Covid19_Deaths) AVG_StayFROM  covid_2023WHERE  Num_Weekly_Admit_Covid19 > 0-- Identify the top 3 states with the highest overall COVID-19 testing rates (tests per 1000
-- people) in 2023.SELECT DISTINCT  P_Name, (CAST(Num_Weekly_Admit_Covid19 AS FLOAT) / NULLIF(Total_Num_Occupied_Beds ,0) *1000) Overall_Covid19_testingFROM covid_2023ORDER BY 2 DESCSELECT DISTINCT P_Name,Weekly_Covid_Conf_Cases_Per_1000FROM covid_2023WHERE DATEPART(YEAR,Week_Ending)='2023'ORDER BY 2 DESC--What is the total number of COVID-19 cases, deaths, and recoveries recorded in the
--  dataset?WITH nhsdata AS ( SELECT Num_Weekly_Confirmed_Covid19, Num_Weekly_All_Death				 FROM covid_2020				 UNION ALL				 SELECT Num_Weekly_Confirmed_Covid19, Num_Weekly_All_Death				 FROM covid_2021				 UNION ALL				 SELECT Num_Weekly_Confirmed_Covid19, Num_Weekly_All_Death				 FROM covid_2022				 UNION ALL				 SELECT Num_Weekly_Confirmed_Covid19, Num_Weekly_All_Death				 FROM covid_2023)SELECT SUM(Num_Weekly_Confirmed_Covid19) total_covid_cases, SUM(Num_Weekly_All_Death) total_covid_death,	  SUM(Num_Weekly_Confirmed_Covid19) -SUM(Num_Weekly_All_Death) total_recoveryFROM nhsdata--Find the healthcare facilities that had a consistent increase in COVID-19 cases for at
-- least 5 consecutive months. Display the facility names and the corresponding months.				 