/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Top 3 locations having the highest revenue

SELECT TOP 3
    home_gym_location,
    SUM(final_price) AS total_revenue
FROM fitness_membership_analytics_dataset
GROUP BY home_gym_location
ORDER BY total_revenue DESC

-- Complex but Flexible Ranking Using Window Functions
SELECT 
* 
FROM(
    SELECT 
        home_gym_location,
        SUM(final_price) AS total_revenue,
        RANK() OVER (ORDER BY SUM(final_price) DESC) AS rank_number
    FROM fitness_membership_analytics_dataset
    GROUP BY home_gym_location
)AS t
WHERE rank_number <= 3

-- Membership type that has the highest churn_rate

SELECT 
    membership_type,
    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) * 1.0
        / COUNT(*) AS churn_rate
FROM fitness_membership_analytics_dataset
GROUP BY membership_type
ORDER BY churn_rate DESC


-- TOP 10 membershiptype(with subscription model and discount type) that we have to pay attention to

SELECT TOP 10
    membership_type,
    discount_type,
    subscription_model,
    SUM(final_price) AS total_revenue,
    COUNT(*) AS total_customer,
    AVG(age) AS avg_age,
    AVG(visit_per_week) AS avg_visit_per_week
FROM fitness_membership_analytics_dataset
WHERE is_active = 1
GROUP BY 
    membership_type,
    discount_type,
    subscription_model
ORDER BY 
    total_revenue DESC,
    total_customer DESC


-- membershiptype(with subscription model and discount type) thta have worst performing

SELECT TOP 5
    membership_type,
    discount_type,
    subscription_model,
    SUM(final_price) AS total_revenue,
    COUNT(*) AS total_customer,
    AVG(age) AS avg_age,
    AVG(visit_per_week) AS avg_visit_per_week
FROM fitness_membership_analytics_dataset
WHERE is_active = 1
GROUP BY 
    membership_type,
    discount_type,
    subscription_model
ORDER BY 
    total_revenue,
    total_customer

-- combo service that has the longest duration in the gym
SELECT 
    CASE 
        WHEN uses_sauna = 1 THEN 'use sauna'
        ELSE 'not use sauna'
    END AS uses_sauna,
    CASE    
        WHEN has_drink_subscription = 1 THEN 'have drink'
        ELSE 'not have drink'
    END AS has_drink_subscription,
    CASE 
        WHEN personal_training = 1 THEN 'Have PT'
        ELSE'Not Have PT'
    END AS personal_training,
    AVG(duration_in_gym_minutes) AS avg_duration_in_gym,
    AVG(visit_per_week) AS avg_visit_per_week
FROM fitness_membership_analytics_dataset
WHERE is_active = 1
GROUP BY 
    CASE 
        WHEN uses_sauna = 1 THEN 'use sauna'
        ELSE 'not use sauna'
    END,
    CASE    
        WHEN has_drink_subscription = 1 THEN 'have drink'
        ELSE 'not have drink'
    END,
    CASE 
        WHEN personal_training = 1 THEN 'Have PT'
        ELSE'Not Have PT'
    END 
ORDER BY 
    avg_duration_in_gym DESC,
    avg_visit_per_week DESC
