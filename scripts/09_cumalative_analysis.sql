
/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
-- running total revenue
SELECT 
    year_month,
    total_revenue,
    SUM(total_revenue) OVER (ORDER BY year_month) AS running_total_revenue
FROM(
    SELECT 
        DATETRUNC(MONTH,join_date) AS year_month,
        SUM(final_price) AS total_revenue
    FROM fitness_membership_analytics_dataset
    GROUP BY DATETRUNC(MONTH,join_date)
   )t

-- running total customer

SELECT 
    year_month,
    total_customer,
    SUM(total_customer) OVER (ORDER BY year_month) AS running_total_customer,
    SUM(basic_membership) OVER (ORDER BY year_month) AS running_basic_membership,
    SUM(standard_membership) OVER (ORDER BY year_month) AS running_standard_membership,
    SUM(premium_membership) OVER (ORDER BY year_month) AS running_total_premium_membership,
    SUM(elite_membership) OVER (ORDER BY year_month) AS elite_membership
FROM(
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
   )t
