/*
===============================================================================
Data Cleaning & Schema Standardization
===============================================================================
Script Purpose:
    This script performs data type conversion and column standardization for the 
    'fitness_membership_analytics_dataset' table to ensure data integrity 
    before analytical processing.
===============================================================================
*/

-- Change column data type
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

/*
===============================================================================
Data Cleaning: Remove Duplicate Records
===============================================================================
Script Purpose:
    This script identifies and removes duplicate rows from the 
    'fitness_membership_analytics_dataset' table. 
    
Methodology:
    - Uses a CTE and ROW_NUMBER() to partition data by all columns.
    - Records with a RowNumber > 1 are identified as duplicates.
    - This ensures data integrity before assigning Primary Keys.
===============================================================================
*/
-- 1. Identify and delete duplicates
WITH Duplicate_CTE AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY 
            age, membership_type, join_date, last_visit_date, 
            subscription_price, final_price, home_gym_location 
        ORDER BY (SELECT NULL)) AS row_number
    FROM fitness_membership_analytics_dataset
)

DELETE FROM Duplicate_CTE
WHERE row_number > 1;

/*
===============================================================================
Data Cleaning: Logical Validation & String Standardization
===============================================================================
Script Purpose:
    - Removes trailing spaces and ensures casing consistency for categories.
    - Handles NULL values.
    - Validates logical consistency for pricing and age.
===============================================================================
*/


-- 1. Chech null values
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
    SUM(CASE WHEN has_drink_subscription IS NULL THEN 1 ELSE 0 END) AS drink_sub_null,
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
FROM gym_fitness_dataset.dbo.fitness_membership_analytics_dataset;

-- 2. Standardize Text Columns
UPDATE fitness_membership_analytics_dataset
SET membership_type = LOWER(TRIM(membership_type)),
    days_per_week = LOWER(TRIM(days_per_week)),
    subscription_model = LOWER(TRIM(subscription_model)),
    home_gym_location = TRIM(home_gym_location),
    discount_type = LOWER(TRIM(discount_type)),
    self_identified_gender = LOWER(TRIM(self_identified_gender))

 -- 3. Consistency Check
UPDATE fitness_membership_analytics_dataset
SET home_gym_location = home_gym_location + ',CA'
WHERE home_gym_location NOT LIKE '%,CA';

-- Duration check
SELECT *
FROM fitness_membership_analytics_dataset
WHERE duration_in_gym_minutes < 0;

-- Time Logic
SELECT *
FROM fitness_membership_analytics_dataset
WHERE avg_time_check_out < avg_time_check_in;

-- Price check
SELECT * 
FROM fitness_membership_analytics_dataset
WHERE subscription_price < final_price  

-- Age check
SELECT * 
FROM fitness_membership_analytics_dataset
WHERE age <10 OR age > 100

SELECT * FROM fitness_membership_analytics_dataset
/*
===============================================================================
Adding customer_id using IDENTITY
===============================================================================
*/

ALTER TABLE fitness_membership_analytics_dataset
ADD customer_id INT IDENTITY(1,1) PRIMARY KEY;


/*
===============================================================================
Adding tenure_days, is_active, 
===============================================================================
*/

-- tenure 
ALTER TABLE gym_fitness_dataset.dbo.fitness_membership_analytics_dataset
ADD tenure_days INT;

UPDATE fitness_membership_analytics_dataset
SET tenure_days = DATEDIFF(DAY, join_date, t.max_date)
FROM fitness_membership_analytics_dataset a
CROSS JOIN (
    SELECT MAX(last_visit_date) AS max_date
    FROM fitness_membership_analytics_dataset
) t;

SELECT * FROM fitness_membership_analytics_dataset

-- active_user

ALTER TABLE gym_fitness_dataset.dbo.fitness_membership_analytics_dataset
ADD is_active BIT;

UPDATE gym_fitness_dataset.dbo.fitness_membership_analytics_dataset
SET is_active =
    CASE 
        WHEN DATEDIFF(DAY, last_visit_date, t.max_date) <= 30 THEN 1
        ELSE 0
    END
FROM gym_fitness_dataset.dbo.fitness_membership_analytics_dataset a
CROSS JOIN (
    SELECT MAX(last_visit_date) AS max_date
    FROM gym_fitness_dataset.dbo.fitness_membership_analytics_dataset
) t;


