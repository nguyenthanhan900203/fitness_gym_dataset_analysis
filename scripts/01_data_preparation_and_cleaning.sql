/*
===============================================================================
FITNESS MEMBERSHIP DATA CLEANING & PREPARATION
===============================================================================

Script Purpose:
    This script prepares the 'fitness_membership_analytics_dataset' table
    for analytical processing by performing:

    1. Data Standardization
        - Convert columns into appropriate data types
        - Standardize categorical text formatting

    2. Data Validation (Testing)
        - Identify NULL values
        - Detect invalid or inconsistent records
        - Validate pricing, duration, and time logic

    3. Data Cleaning
        - Remove duplicate records
        - Correct formatting inconsistencies

    4. Adding Derived Columns
        - Create additional calculated columns
        - Improve analytical usability of the dataset

===============================================================================
*/


/*===============================================================================
1. DATA STANDARDIZATION
===============================================================================*/

-- Convert column data types

ALTER TABLE fitness_membership_analytics_dataset
ALTER COLUMN age INT;

ALTER TABLE fitness_membership_analytics_dataset
ALTER COLUMN visit_per_week INT;

ALTER TABLE fitness_membership_analytics_dataset
ALTER COLUMN duration_in_gym_minutes INT;

ALTER TABLE fitness_membership_analytics_dataset
ALTER COLUMN personal_training_hours INT;

ALTER TABLE fitness_membership_analytics_dataset
ALTER COLUMN avg_time_check_in TIME(0);

ALTER TABLE fitness_membership_analytics_dataset
ALTER COLUMN avg_time_check_out TIME(0);

ALTER TABLE fitness_membership_analytics_dataset
ALTER COLUMN subscription_price FLOAT;


-- Standardize text formatting

UPDATE fitness_membership_analytics_dataset
SET 
    membership_type = LOWER(TRIM(membership_type)),
    days_per_week = LOWER(TRIM(days_per_week)),
    subscription_model = LOWER(TRIM(subscription_model)),
    home_gym_location = TRIM(home_gym_location),
    discount_type = LOWER(TRIM(discount_type)),
    self_identified_gender = LOWER(TRIM(self_identified_gender));



/*===============================================================================
2. DATA VALIDATION (TESTING)
===============================================================================*/

-- Check NULL values

SELECT 
    COUNT(*) AS total_rows,

    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_null,
    SUM(CASE WHEN membership_type IS NULL THEN 1 ELSE 0 END) AS membership_type_null,
    SUM(CASE WHEN visit_per_week IS NULL THEN 1 ELSE 0 END) AS visit_per_week_null,
    SUM(CASE WHEN days_per_week IS NULL THEN 1 ELSE 0 END) AS days_per_week_null,
    SUM(CASE WHEN attend_group_lesson IS NULL THEN 1 ELSE 0 END) AS attend_group_lesson_null,
    SUM(CASE WHEN avg_time_check_in IS NULL THEN 1 ELSE 0 END) AS avg_time_check_in_null,
    SUM(CASE WHEN avg_time_check_out IS NULL THEN 1 ELSE 0 END) AS avg_time_check_out_null,
    SUM(CASE WHEN duration_in_gym_minutes IS NULL THEN 1 ELSE 0 END) AS duration_null,
    SUM(CASE WHEN has_drink_subscription IS NULL THEN 1 ELSE 0 END) AS drink_subscription_null,
    SUM(CASE WHEN personal_training IS NULL THEN 1 ELSE 0 END) AS personal_training_null,
    SUM(CASE WHEN uses_sauna IS NULL THEN 1 ELSE 0 END) AS sauna_null,
    SUM(CASE WHEN self_identified_gender IS NULL THEN 1 ELSE 0 END) AS gender_null,
    SUM(CASE WHEN subscription_price IS NULL THEN 1 ELSE 0 END) AS subscription_price_null,
    SUM(CASE WHEN subscription_model IS NULL THEN 1 ELSE 0 END) AS subscription_model_null,
    SUM(CASE WHEN adjusted_price IS NULL THEN 1 ELSE 0 END) AS adjusted_price_null,
    SUM(CASE WHEN discount_type IS NULL THEN 1 ELSE 0 END) AS discount_type_null,
    SUM(CASE WHEN discount_rate IS NULL THEN 1 ELSE 0 END) AS discount_rate_null,
    SUM(CASE WHEN final_price IS NULL THEN 1 ELSE 0 END) AS final_price_null,
    SUM(CASE WHEN access_hours IS NULL THEN 1 ELSE 0 END) AS access_hours_null,
    SUM(CASE WHEN home_gym_location IS NULL THEN 1 ELSE 0 END) AS location_null,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS latitude_null,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS longitude_null,
    SUM(CASE WHEN join_date IS NULL THEN 1 ELSE 0 END) AS join_date_null,
    SUM(CASE WHEN personal_training_hours IS NULL THEN 1 ELSE 0 END) AS pt_hours_null,
    SUM(CASE WHEN multi_location_access IS NULL THEN 1 ELSE 0 END) AS multi_location_null,
    SUM(CASE WHEN last_visit_date IS NULL THEN 1 ELSE 0 END) AS last_visit_null
FROM fitness_membership_analytics_dataset;


-- Negative duration check

SELECT *
FROM fitness_membership_analytics_dataset
WHERE duration_in_gym_minutes < 0;


-- Invalid time sequence check

SELECT *
FROM fitness_membership_analytics_dataset
WHERE avg_time_check_out < avg_time_check_in;


-- Price consistency check

SELECT *
FROM fitness_membership_analytics_dataset
WHERE final_price > subscription_price;


-- Invalid age range check

SELECT *
FROM fitness_membership_analytics_dataset
WHERE age < 10
   OR age > 100;



/*===============================================================================
3. DATA CLEANING
===============================================================================*/

-- Remove duplicate records

WITH Duplicate_CTE AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                age,
                membership_type,
                join_date,
                last_visit_date,
                subscription_price,
                final_price,
                home_gym_location
            ORDER BY join_date
        ) AS duplicate_rank
    FROM fitness_membership_analytics_dataset
)

DELETE FROM Duplicate_CTE
WHERE duplicate_rank > 1;


-- Standardize location formatting

UPDATE fitness_membership_analytics_dataset
SET home_gym_location = home_gym_location + ', CA'
WHERE home_gym_location NOT LIKE '%, CA';



/*===============================================================================
4. ADDING DERIVED COLUMNS
===============================================================================*/

-- Example: Add membership tenure column

ALTER TABLE fitness_membership_analytics_dataset
ADD membership_tenure_months INT;


UPDATE fitness_membership_analytics_dataset
SET membership_tenure_months =
    DATEDIFF(MONTH, join_date, last_visit_date);
