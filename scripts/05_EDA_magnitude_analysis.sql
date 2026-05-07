/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- total revenue by location
SELECT
    DISTINCT home_gym_location,
    SUM(final_price) AS total_revenue
FROM fitness_membership_analytics_dataset
GROUP BY home_gym_location
ORDER BY SUM(final_price) DESC

-- total revenue by membership type
SELECT
    DISTINCT membership_type,
    SUM(final_price) AS total_revenue
FROM fitness_membership_analytics_dataset
GROUP BY membership_type
ORDER BY SUM(final_price) DESC

-- total customers by location
SELECT
    DISTINCT home_gym_location,
    COUNT(*) customer_number
FROM fitness_membership_analytics_dataset
GROUP BY home_gym_location
ORDER BY COUNT(*) DESC

-- total customers by membership type
SELECT
    DISTINCT membership_type,
    COUNT(*) customer_number
FROM fitness_membership_analytics_dataset
GROUP BY membership_type
ORDER BY COUNT(*) DESC

-- total customers by subscription model
SELECT
    DISTINCT subscription_model,
    COUNT(*) customer_number
FROM fitness_membership_analytics_dataset
GROUP BY subscription_model
ORDER BY COUNT(*) DESC

-- total customers using the PT service
SELECT 
    CASE    
        WHEN personal_training = 1 THEN 'Have PT'
        ELSE 'No PT'
    END AS personal_training,
    COUNT(*) customer_number
FROM fitness_membership_analytics_dataset
GROUP BY
CASE    
        WHEN personal_training = 1 THEN 'Have PT'
        ELSE 'No PT'
    END 


-- average price by membership type
SELECT
membership_type,
AVG(final_price) AS average_price 
FROM fitness_membership_analytics_dataset
GROUP BY membership_type

-- average price between those with PT and no PT 
SELECT 
    CASE    
        WHEN personal_training = 1 THEN 'Have PT'
        ELSE 'No PT'
    END AS personal_training,
    AVG(final_price) AS average_price 
FROM fitness_membership_analytics_dataset
GROUP BY
CASE    
        WHEN personal_training = 1 THEN 'Have PT'
        ELSE 'No PT'
    END 

-- average price by subscription model
SELECT
subscription_model,
AVG(final_price) AS average_price 
FROM fitness_membership_analytics_dataset
GROUP BY subscription_model

-- average duration in the gym
SELECT 
AVG(duration_in_gym_minutes) AS average_duration_in_gym
FROM fitness_membership_analytics_dataset

-- average duration if using sauna
SELECT 
    CASE    
        WHEN uses_sauna = 1 THEN 'use sauna'
        ELSE 'not use'
    END AS uses_sauna,
    AVG(duration_in_gym_minutes) AS average_duration_in_gym
FROM fitness_membership_analytics_dataset
GROUP BY
    CASE    
        WHEN uses_sauna = 1 THEN 'use sauna'
        ELSE 'not use'
    END

-- average duration of having a drink
SELECT 
    CASE    
        WHEN has_drink_subscription = 1 THEN 'have drink'
        ELSE 'not use'
    END AS uses_sauna,
    AVG(duration_in_gym_minutes) AS average_duration_in_gym
FROM fitness_membership_analytics_dataset
GROUP BY
    CASE    
        WHEN has_drink_subscription = 1 THEN 'have drink'
        ELSE 'not use'
    END

-- average visit_per_week
SELECT AVG(visit_per_week) AS average_day_customer_vist_per_week FROM fitness_membership_analytics_dataset

-- day_of_week
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
    -- Tính phần trăm Churn Rate
    (at_risk_count * 100.0 / (at_risk_count + active_count)) AS churn_rate
FROM (
    SELECT 
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_count,
        SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS at_risk_count
    FROM fitness_membership_analytics_dataset
) AS summary_table;

-- average churn rate by membership type
WITH membership_stat AS(
    SELECT 
            membership_type,
            SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_count,
            SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS at_risk_count,
            COUNT(*) AS total_members
    FROM fitness_membership_analytics_dataset
    GROUP BY membership_type)

SELECT 
    membership_type,
    active_count,
    at_risk_count,
    ROUND(at_risk_count * 100.0 / total_members, 2) AS churn_rate
FROM membership_stat
ORDER BY churn_rate DESC

-- average churn rate by subscription model
WITH subscription_stat AS(
    SELECT 
            subscription_model,
            SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_count,
            SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS at_risk_count,
            COUNT(*) AS total_members
    FROM fitness_membership_analytics_dataset
    GROUP BY subscription_model)

SELECT 
    subscription_model,
    active_count,
    at_risk_count,
    ROUND(at_risk_count * 100.0 / total_members, 2) AS churn_rate
FROM subscription_stat
ORDER BY churn_rate DESC

-- average churn rate by discount_type
WITH discount_stat AS(
    SELECT 
            discount_type,
            SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_count,
            SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS at_risk_count,
            COUNT(*) AS total_members
    FROM fitness_membership_analytics_dataset
    GROUP BY discount_type)

SELECT 
    discount_type,
    active_count,
    at_risk_count,
    ROUND(at_risk_count * 100.0 / total_members, 2) AS churn_rate
FROM discount_stat
ORDER BY churn_rate DESC
