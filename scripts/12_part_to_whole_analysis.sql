/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which membership_type contribute the most to overall sales?

WITH sales_by_membership AS (
    SELECT 
        membership_type,
        SUM(final_price) AS sales
    FROM fitness_membership_analytics_dataset
    GROUP BY membership_type
)

SELECT 
   membership_type,
   sales,
   SUM(sales) OVER() AS total_sales,
   ROUND((CAST(sales AS FLOAT) / SUM(sales) OVER())*100,2) AS percentage_sales
FROM sales_by_membership
ORDER BY sales DESC


