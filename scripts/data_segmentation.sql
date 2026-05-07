/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

WITH customer_ltv AS(
	SELECT 
		customer_id,
		membership_type,
		subscription_model,
		visit_per_week,
		final_price,
		tenure_months,
		final_price * tenure_months AS ltv,
		is_active
	FROM fitness_membership_analytics_dataset )

SELECT
	customer_segment,
	COUNT(*) AS total_customer
FROM (
	SELECT 
		*,
		CASE 
			WHEN ltv > 1400 AND visit_per_week >=3 THEN 'VIP'
			WHEN tenure_months < 3 THEN 'New'
			WHEN is_active = 0 THEN 'At Risk'
			ELSE 'regular'
		END AS customer_segment	
	FROM customer_ltv) t
GROUP BY customer_segment
ORDER BY total_customer DESC
