/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- total revenue
SELECT SUM(final_price) AS total_revenue FROM fitness_membership_analytics_dataset

-- total customer
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM fitness_membership_analytics_dataset

-- average price 
SELECT AVG(final_price) AS average_price FROM fitness_membership_analytics_dataset

-- average duration in the gym
SELECT 
AVG(duration_in_gym_minutes) AS average_duration_in_gym
FROM fitness_membership_analytics_dataset

-- day_of_week (frequency)
SELECT 
    TRIM(value) AS day_of_week, 
    COUNT(*) AS frequency
FROM 
    fitness_membership_analytics_dataset
CROSS APPLY 
    STRING_SPLIT(days_per_week, ',')
GROUP BY 
    TRIM(value)
ORDER BY 
    frequency DESC;

-- churn rate
SELECT 
    at_risk_count,
    active_count,
    -- Calculate Churn Rate
    (at_risk_count * 100.0 / (at_risk_count + active_count)) AS churn_rate
FROM (
    SELECT 
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_count,
        SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS at_risk_count
    FROM fitness_membership_analytics_dataset
) AS t;

-- Generate a Report that shows all key metrics of the business
SELECT  'total revenue' AS measure_name, SUM(final_price) AS measure_value FROM fitness_membership_analytics_dataset
UNION ALL
SELECT 'total customer', COUNT(DISTINCT customer_id) FROM fitness_membership_analytics_dataset
UNION ALL
SELECT 'average_price', AVG(final_price) FROM fitness_membership_analytics_dataset
UNION ALL
SELECT 'average_duration_in_gym',
AVG(duration_in_gym_minutes) 
FROM fitness_membership_analytics_dataset
UNION ALL
SELECT 
    'churn_rae',
    -- Calculate Churn Rate
    (at_risk_count * 100.0 / (at_risk_count + active_count)) AS churn_rate
FROM (
    SELECT 
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_count,
        SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS at_risk_count
    FROM fitness_membership_analytics_dataset
) AS t
