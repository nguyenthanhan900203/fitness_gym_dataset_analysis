## 💡 Key Business Insights & Analytical Approaches

Through the execution of the SQL scripts, several critical business insights were uncovered, driving actionable recommendations for gym management:

* **Customer Segmentation & LTV (Lifetime Value):** By defining custom logic (using `CTEs` and `CASE` statements), the customer base was segmented into highly actionable groups: **VIP** (LTV > $1400 and high visit frequency), **New** (tenure < 3 months), and **At Risk** (inactive). This allows for highly targeted retention campaigns and personalized marketing. *(Ref: 10_data_segmentation.sql & 13_customer_report.sql)*

* **Churn Rate Drivers:** Magnitude analysis revealed specific churn behaviors across different dimensions. By comparing active vs. at-risk members, the analysis pinpointed exactly which `membership_type`, `subscription_model`, and `discount_type` experienced the highest attrition rates, providing direct signals for product restructuring. *(Ref: 05_EDA_magnitude_analysis.sql)*

* **Revenue Contribution (Part-to-Whole):** Utilizing Advanced Window Functions (`SUM() OVER()`), the analysis successfully quantified the exact percentage contribution of each membership tier to the total revenue stream, identifying the core products driving the gym's financial health. *(Ref: 12_part_to_whole_analysis.sql)*

* **Peak Gym Engagement:** By transforming delimited string data (`STRING_SPLIT` on `days_per_week`), the exact frequency of visits per day of the week was extracted. This insight is crucial for optimizing staff scheduling, personal trainer availability, and timing for promotional classes. *(Ref: 04_EDA_measure_exploration.sql)*

* **Performance Tracking (YoY & MoM):** Time-series analysis using `LAG()` functions and `DATETRUNC` effectively tracked revenue growth and membership acquisition velocity, comparing current performance against historical averages to gauge business momentum. *(Ref: 08_change_over_time_analysis.sql & 11_performance_analysis.sql)*
