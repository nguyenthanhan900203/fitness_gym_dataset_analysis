/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Retrieves essential customer and membership information:
       - age
       - membership type
       - subscription model
       - discount type
       - gym location
       - join and last visit dates
       - sauna and drink subscription usage
	  2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - visit frequency
       - average gym duration
     4. Calculates business KPIs:
       - revenue
       - tenure
       - ltv (life time value)
       - churn risk indicators
===============================================================================
*/

-- =============================================================================
-- Create Report: gym.report_customers
-- =============================================================================
IF OBJECT_ID('report_customers', 'V') IS NOT NULL
    DROP VIEW report_customers;
GO

CREATE VIEW report_customers AS

WITH customer_aggregation AS(
    SELECT
        *,
        final_price * tenure_months AS ltv
    FROM fitness_membership_analytics_dataset )
SELECT 
    customer_id,
    age,
    CASE 
	     WHEN age < 20 THEN 'Under 20'
	     WHEN age between 20 and 29 THEN '20-29'
	     WHEN age between 30 and 39 THEN '30-39'
	     WHEN age between 40 and 49 THEN '40-49'
	     ELSE '50 and above'
    END AS age_group,
    CASE 
        WHEN self_identified_gender = 'male' THEN 'M'
        WHEN self_identified_gender = 'female' THEN 'F'
        WHEN self_identified_gender = 'other (self-described)' THEN 'other'
        ELSE NULL
    END AS gender,
    membership_type,
    subscription_model,
    discount_type,
    home_gym_location AS gym_location,
    join_date,
    last_visit_date,
    tenure_months AS tenure,
    CASE 
        WHEN is_active = 1 THEN 'active'
        ELSE 'alert'
    END AS is_active,
    final_price AS sales,
    ltv,
    CASE 
	    WHEN ltv > 1400 AND visit_per_week >=3 THEN 'VIP'
	    WHEN tenure_months < 3 THEN 'New'
	    WHEN is_active = 0 THEN 'At Risk'
	    ELSE 'Regular'
    END AS customer_segment,
    visit_per_week,
    days_per_week,
    duration_in_gym_minutes AS duration_in_gym,
    
    CASE
        WHEN personal_training = 1 THEN 'have PT'
        ELSE 'no have PT'
    END AS personal_training_option,
    CASE 
        WHEN uses_sauna = 1 THEN 'use sauna' 
        ELSE 'no use sauna' 
    END AS sauna_option,
    CASE 
        WHEN has_drink_subscription = 1 THEN 'have drink'
        ELSE 'no drink'
    END AS drink_option  
FROM customer_aggregation
