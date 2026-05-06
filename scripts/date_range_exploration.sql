/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the last date in the dataset
SELECT
    MAX(join_date) AS last_join_date,
    MAX(last_visit_date) AS last_visit_date
FROM fitness_membership_analytics_dataset

-- Determine the first and last join date and the total duration in months
SELECT 
   MIN(join_date) AS first_join_date,
   MAX(join_date) AS last_join_date,
   DATEDIFF(MONTH, MIN(join_date), MAX(join_date)) AS range_month
FROM fitness_membership_analytics_dataset

-- Find the youngest and oldest customers based on age
SELECT
    MIN(age) AS youngest_age,
    MAX(age) AS oldest_age
FROM fitness_membership_analytics_dataset
