/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique locations
SELECT DISTINCT
        home_gym_location,
        COUNT(*) AS customer_number
FROM fitness_membership_analytics_dataset
GROUP BY home_gym_location

-- Retrieve a list of discount types
SELECT DISTINCT
    discount_type,
    COUNT(*) AS customer_number
FROM fitness_membership_analytics_dataset
GROUP BY discount_type

-- Retrieve a list of subscription models
SELECT DISTINCT
    subscription_model,
    COUNT(*) AS customer_number
FROM fitness_membership_analytics_dataset
GROUP BY subscription_model

-- Retrieve a list of membership types
SELECT DISTINCT
    membership_type,
    COUNT(*) AS customer_number
FROM fitness_membership_analytics_dataset
GROUP BY membership_type

-- Retrieve a list of membership types, discount types, and subscription models
SELECT 
    membership_type,
    discount_type,
    subscription_model,
    COUNT(*) AS customer_number
FROM fitness_membership_analytics_dataset
GROUP BY 
    membership_type,
    discount_type,
    subscription_model
ORDER BY 
    membership_type,
    discount_type,
    subscription_model
