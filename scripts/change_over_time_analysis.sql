/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
-- Analyse sales performance over time
-- Quick Date Functions
SELECT 
    YEAR(join_date) AS year_,
    MONTH(join_date) AS month_,
    SUM(final_price) AS total_revenue,
    COUNT(*) AS total_customer,
    SUM(CASE WHEN personal_training = 1 THEN 1 ELSE 0 END) AS total_have_PT,
    SUM(CASE WHEN membership_type = 'basic' THEN 1 ELSE 0 END) AS basic_membership,
    SUM(CASE WHEN membership_type = 'standard' THEN 1 ELSE 0 END) AS standard_membership,
    SUM(CASE WHEN membership_type = 'premium' THEN 1 ELSE 0 END) AS premium_membership,
    SUM(CASE WHEN membership_type = 'elite' THEN 1 ELSE 0 END) AS elite_membership
FROM fitness_membership_analytics_dataset
GROUP BY YEAR(join_date), MONTH(join_date)
ORDER BY YEAR(join_date), MONTH(join_date)

-- DATETRUNC()
SELECT 
    DATETRUNC(MONTH,join_date) AS year_month,
    SUM(final_price) AS total_revenue,
    COUNT(*) AS total_customer,
    SUM(CASE WHEN personal_training = 1 THEN 1 ELSE 0 END) AS total_have_PT,
    SUM(CASE WHEN membership_type = 'basic' THEN 1 ELSE 0 END) AS basic_membership,
    SUM(CASE WHEN membership_type = 'standard' THEN 1 ELSE 0 END) AS standard_membership,
    SUM(CASE WHEN membership_type = 'premium' THEN 1 ELSE 0 END) AS premium_membership,
    SUM(CASE WHEN membership_type = 'elite' THEN 1 ELSE 0 END) AS elite_membership
FROM fitness_membership_analytics_dataset
GROUP BY DATETRUNC(MONTH,join_date)
ORDER BY DATETRUNC(MONTH,join_date)

-- FORMAT
SELECT 
    FORMAT(join_date,'yyyy-MMM') AS year_month,
    SUM(final_price) AS total_revenue,
    COUNT(*) AS total_customer,
    SUM(CASE WHEN personal_training = 1 THEN 1 ELSE 0 END) AS total_have_PT,
    SUM(CASE WHEN membership_type = 'basic' THEN 1 ELSE 0 END) AS basic_membership,
    SUM(CASE WHEN membership_type = 'standard' THEN 1 ELSE 0 END) AS standard_membership,
    SUM(CASE WHEN membership_type = 'premium' THEN 1 ELSE 0 END) AS premium_membership,
    SUM(CASE WHEN membership_type = 'elite' THEN 1 ELSE 0 END) AS elite_membership
FROM fitness_membership_analytics_dataset
GROUP BY FORMAT(join_date,'yyyy-MMM') 
ORDER BY FORMAT(join_date,'yyyy-MMM') 
