/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH CTE AS(
    SELECT 
        YEAR(join_date) AS year_,
        membership_type,
        SUM(final_price) AS current_sales
    FROM fitness_membership_analytics_dataset
    GROUP BY YEAR(join_date), membership_type
    )
SELECT 
    year_,
    membership_type,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY membership_type) AS avg_sales,
    current_sales -  AVG(current_sales) OVER(PARTITION BY membership_type) AS sales_diff,
    CASE 
        WHEN  current_sales -  AVG(current_sales) OVER(PARTITION BY membership_type) > 0 THEN 'Above Avg'
        WHEN  current_sales -  AVG(current_sales) OVER(PARTITION BY membership_type) < 0 THEN 'Below Avg'
        ELSE '=Avg'
    END AS avg_change,
      -- Year-over-Year Analysis
    LAG(current_sales) OVER (PARTITION BY membership_type ORDER BY year_) AS previous_year_sales,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY membership_type ORDER BY year_) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY membership_type ORDER BY year_) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS sales_change

FROM CTE
ORDER BY membership_type, year_
