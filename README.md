# Covid-19-NHSN-Impact Analysis

- [Project Overview](#project-overview)
- [Data Source](#data-source)
- [Tools](#tools)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis and Skills Demonstrated](#data-analysis-and-skills-demonstrated)
- [Findings](#findings)
- [Solutions](#solutions)
- [Recommendations](#recommendations)
### Project Overview
The CDC’s National Healthcare Safety Network is the United States most widely used healthcare-associated infection (HAI) tracking system. NHSN provides facilities, health departments, tracking system, states, regions, and the nation with data needed to identify problem areas, measure progress of prevention efforts, and ultimately eliminate healthcare-associated infections. For this project, we focused our analysis on the impact of covid-19 on nursing home residents, facilities, and to derive insights from the NHSN dataset.

### Data Source
Four datasets where provided which are covid 19 dataset for 2020, for 2021 and for 2022, 2023.

### Tools
- Excel (This is used for data cleaning)
- Microsoft SQL server (This is used for data analysis)
-  Power Bi (is used for Data visualisation)

### Data Cleaning and Preparation
The following steps breaks down the cleaning process taken in ensuring the dataset was clean, valid and ready for analysis.

- Dropped Irrelevant columns
- Converted Facility  to text Datatype
- Removed duplicates
- Filled missing values with 'N/A' for string/text variables

### Exploratory Data Analysis
- For this phase, I created the NHS Database in Microsoft SQL Server, to accomodate the cleaned dataset and imported the 4 tables into the NHS. After importing the tables, I further explored the datasets to find out and answer key questions such as :
- Which healthcare facilities had the highest average number of daily COVID-19 cases in 2021? Display the top 10 facilities.
- Calculate the 7-day moving average of new COVID-19 cases for each healthcare facility. Which facility had the highest peak in the moving average?
- Determine the total number of COVID-19 cases, deaths, and recoveries for each state. Include the state's name and the corresponding counts in the result.
- Find the top 5 states with the highest mortality rate (deaths per COVID-19 case) in 2022.
- Identify the healthcare facilities that experienced a significant increase in COVID-19 cases from 2020 to 2021 (more than 50% increase). Display the facility names and the percentage increase.
- What is the total number of COVID-19 cases, deaths, and recoveries recorded in the dataset?
- Find the healthcare facilities that had a consistent increase in COVID-19 cases for at least 5 consecutive months. Display the facility names and the corresponding months.
- Calculate the mortality rate (deaths per COVID-19 case) for each healthcare facility.
- Are there any significant differences in COVID-19 outcomes based on the type of healthcare facility (e.g., hospital, nursing home)?
- How has the number of COVID-19 cases evolved over time (monthly or quarterly)?
- What is the distribution of healthcare facilities by state?
- Find the healthcare facilities with the highest occupancy rates for COVID-19 patients.

### Data Analysis and Skills Demonstrated
-Data Manipulation
- Functions used to Query (Aggregate functions, UNION Set Operations, Common Table Expressions, Correlations, Joins, Case Statements)
- DAX
- Quick Measures
- Filters use in Power BI
- Slicers in Power Bi

### Findings
1. Between May, 2020 and May 2023, there were 1,632,695 recorded covid cases by the NHSN for nuring home residents.
2. The total number of available facilities to handle these cases amounted to 16,000
3. From the 1.6m covid cases, a total of 166,244 deaths were recorded accounting for a 10% of the total cases. Recovered cases amounted to 1,466,451 accounting for 90% of cases.
4. Miller's Merry Manor, Brighton Rehabilitation and wellness centre, and cedarbrook senior care and rehabilitation centre recorded the top 3 average weekly cases amongnst all facilities, with 6.9, 5.4, and 5.1 average weekly cases respectively.
5. The high average weekly cases recorded by Brighton Rehabilitation and wellness centre, and cedarbrook senior care and rehabilitation centre both are from the state of pensylvania, which is one of the most populous states in the United states. Population density in this state is clearly a factor in the high average weekly cases recorded in these facilities. Miller's Merry Manor on the other hand is a facility in Indiana which is the 17th mots populous state. Other factors like the demography of resients must have contributed to the high average weekly cases.
6. Texas, California, and Newyork recorded the highest cases across all states overtime . This is expected as they are one of the most densely populated states in the US. Dense population within these states is a major factor that contributed to high recorded covid-19 cases. Newyork, and California are also home to major international airports and are popular destinations for both domestic and international travelers.
7. The 5 states that recorded the highest mortality rates were South Dakota with 14%, Minnesota, North Dakota, New Jersey and Indiana with similar rates of 13%. :sad:
8. Overtime, there has been inconsistent levels of cases between mid 2020 and May 2023. There were a few outliers, most prominent being Jan 2022 with a sharp increase. In the first & 2nd week in 2022, more than 49,000 covid cases of nursing home residents were recorded, the highest weekly caseload since the start of the pandemic. Cases increased by over 700% from December 2021.
9. There is a strong positive correlation between Total Cases and Total Recoveries, indicating that an increase in cases, contributed to increased recovery, implying that the nursing homes had resources to handle and curb covid-19 cases through massive efficient vaccinations.
10. January' accounts for the majority of tot_cases for quarter 1 overtime, while May accounts for the majority of tot_cases for quarter 2 overtime.

### Solutions
- - How has the number of COVID-19 cases evolved over time (monthly or quarterly)?
```sql

WITH nhsdata AS (SELECT    
							Num_Weekly_Confirmed_Covid19, 
							Week_Ending
			     FROM covid_2020
				 UNION ALL

				 SELECT    
							Num_Weekly_Confirmed_Covid19,
							Week_Ending
			     FROM covid_2021
				 UNION ALL

				 SELECT   
							Num_Weekly_Confirmed_Covid19, 
							Week_Ending
			     FROM covid_2022
				 UNION ALL

				 SELECT  
							Num_Weekly_Confirmed_Covid19, 
							Week_Ending
			     FROM covid_2023)

SELECT 
			DATEPART(MONTH, Week_Ending) AS Month,
			DATEPART(QUARTER, Week_Ending) Quarterly,
	        SUM(Num_Weekly_Confirmed_Covid19) AS total_Covid_Cases
FROM
nhsdata
WHERE DATEPART(MONTH, Week_Ending) IS NOT NULL
GROUP BY DATEPART(MONTH, Week_Ending), DATEPART(QUARTER, Week_Ending)
ORDER BY 3 DESC;
````
![3c028fdbaf25816d3a42ad7c8752787](https://github.com/CherryChristie/covid-19-impact-analyisis/assets/148567375/e7a86e3e-0bde-404f-97f1-524974bc0cdd)

- What is the distribution of healthcare facilities by state?
````sql
WITH nhsdata AS		(SELECT 
								P_Name AS Healthcare_Facilities,
								P_State AS State	
					FROM
					covid_2020

					UNION ALL
					SELECT 
								P_Name AS Healthcare_Facilities,
								P_State AS State	
					FROM
					covid_2021

					UNION ALL
					SELECT 
								P_Name AS Healthcare_Facilities,
								P_State AS State	
					FROM
					covid_2022

					UNION ALL
					SELECT 
								P_Name AS Healthcare_Facilities,
								 P_State AS State	
					FROM
					covid_2023)
SELECT  
			State,
			COUNT(Healthcare_Facilities) Healthcare_Facilities_Distribution
FROM
nhsdata
WHERE State IS NOT NULL
GROUP BY State
ORDER BY 2 DESC;
````
![b048ef2c097607c5269eb268f364cce](https://github.com/CherryChristie/covid-19-impact-analyisis/assets/148567375/74aea614-8967-43fe-9ee2-496c49e2991b)

- Find the healthcare facilities with the highest occupancy rates for COVID-19 patients.
````sql

WITH nhsdata AS		(SELECT 
								P_Name AS Healthcare_Facilities,
							   Total_Num_Occupied_Beds,
							   Num_All_Beds
					FROM
					covid_2020

					UNION ALL
					SELECT 
								P_Name AS Healthcare_Facilities,
							   Total_Num_Occupied_Beds,
							   Num_All_Beds
					FROM
					covid_2021

					UNION ALL
					SELECT 
								  P_Name AS Healthcare_Facilities,
								  Total_Num_Occupied_Beds,
								   Num_All_Beds
					FROM
					covid_2022

					UNION ALL
					SELECT
								P_Name AS Healthcare_Facilities,
							   Total_Num_Occupied_Beds,
							   Num_All_Beds	
					FROM
					covid_2023)
SELECT  
		Healthcare_Facilities,
		SUM(Total_Num_Occupied_Beds) / NULLIF(SUM( Num_All_Beds),0) AS total_occupancy_rate
FROM
nhsdata
GROUP BY Healthcare_Facilities
ORDER BY 2 DESC;
````
![5bb5020ad7caf155e6a13b7a65d151f](https://github.com/CherryChristie/covid-19-impact-analyisis/assets/148567375/88f2806c-80c2-4c05-bf55-69a9eb253cce)


- Find the healthcare facilities that had a consistent increase in COVID-19 cases for a least 5 consecutive months. Display the facility names and the corresponding months.
````sql
WITH monthly_cases AS (SELECT
								P_Name AS Facility_Name,
								DATEPART(MONTH, Week_Ending) Month,
								SUM(Num_Weekly_Confirmed_Covid19) total_cases,
								ROW_NUMBER() OVER (PARTITION BY P_Name ORDER BY DATEPART(MONTH, Week_Ending)) monthly_rank
								FROM covid_2020
								GROUP BY P_Name,
								DATEPART(MONTH, Week_Ending)
							UNION ALL

							SELECT 
								P_Name AS Facility_Name,
								DATEPART(MONTH, Week_Ending) Month,
								SUM(Num_Weekly_Confirmed_Covid19) total_cases,
								ROW_NUMBER() OVER (PARTITION BY P_Name ORDER BY DATEPART(MONTH, Week_Ending)) monthly_rank
								FROM covid_2021
								GROUP BY P_Name,
								DATEPART(MONTH, Week_Ending)
							UNION ALL
							
							SELECT 
								P_Name AS Facility_Name,
								DATEPART(MONTH, Week_Ending) Month,
								SUM(Num_Weekly_Confirmed_Covid19) total_cases,
								ROW_NUMBER() OVER (PARTITION BY P_Name ORDER BY DATEPART(MONTH, Week_Ending)) monthly_rank
								FROM covid_2022
								GROUP BY P_Name,
								DATEPART(MONTH, Week_Ending)
							UNION ALL
							
							SELECT P_Name AS Facility_Name,
							DATEPART(MONTH, Week_Ending) Month,
							SUM(Num_Weekly_Confirmed_Covid19) total_cases,
							ROW_NUMBER() OVER (PARTITION BY P_Name ORDER BY DATEPART(MONTH, Week_Ending)) monthly_rank
							FROM covid_2023
							GROUP BY P_Name,
							DATEPART(MONTH, Week_Ending))
SELECT DISTINCT  
							a.Facility_Name,
							c.Month
							FROM monthly_cases a
							JOIN
							monthly_cases b 
							ON 
							a.Facility_Name= b.Facility_Name AND a.monthly_rank = b.monthly_rank + 1
							AND a.total_cases > b.total_cases
							JOIN
							monthly_cases c 
							ON  A.Facility_Name= C.Facility_Name
							AND 
							c.monthly_rank BETWEEN a.monthly_rank + 1 AND a.monthly_rank + 4
							AND c.total_cases > a.total_cases
							WHERE c.monthly_rank - a.monthly_rank= 4 -- to ensure the 5 month span
````
![a49df53ca39ffde3d2a0c5c64fa2ee8](https://github.com/CherryChristie/covid-19-impact-analyisis/assets/148567375/b451b4ec-7576-4def-b95a-672ee655c0d0)

## Dashboard
![1706708267051](https://github.com/CherryChristie/Covid-19-Impact-Analyisis/assets/148567375/501657db-3e85-43ee-8398-961f4ba6a266)

1. THE NHSN should focus and prepare for residents and other patients cases when periods are approaching winter, most especially from December to Februrary, with January as a red alert month.
2. The NHSN should treat these states (South Dakota , Minnesota, North Dakota, New Jersey and Indiana ) with high importance as they recorded the highest mortality rates. By providing more education, monitoring & Evaluation excercises to residents and patients from these states, potential case spread can be reduced and prevented.
3. Facilities like Miller's Merry Manor, Brighton Rehabilitation and wellness centre, and cedarbrook senior care & rehabilitation centre needs to be really monitored and evaluated for faster solutions in preventing increase in average weekly cases.
4. There is a need to increase the number of NHSN facilties and equip them with all resources to ensure cases are handled with speed and efficiency.
More NHS nursing staffs are needed to be hired to handle numerous cases.
5. For states like Texas, Newyork and California, there is a need to provide them with more resources compared to other states.
6. There is a need to intensify the introduction of innovation into health care to be able to detect cases faster, and handle these cases with precision and efficiency to reduce mortalite rates to the bearest minimum
