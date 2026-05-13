# 🏋️‍♂️ Fitness Gym Data Analytics Project
 
This project demonstrates an end-to-end data analytics workflow, from database initialization and data cleansing to exploratory data analysis (EDA) and advanced customer segmentation. Designed as a portfolio project, it highlights industry best practices in extracting actionable business insights from raw operational data using advanced SQL techniques.

---

## Analytical Workflow (The Data Journey)

1. **Stage 1: Preparation & Cleansing**: Creating the relational database schema, handling missing values, and standardizing data formats (`00_create` to `01_data_prep`).
2. **Stage 2: Exploratory Data Analysis (EDA)**: Profiling the data across multiple dimensions (demographics, memberships, locations) and measuring magnitudes to understand distributions (`02_EDA` to `07_EDA`).
3. **Stage 3: Advanced Business Logic**: Applying time-series tracking (YoY, MoM), cumulative calculations, and part-to-whole market share analysis (`08_change_over_time` to `12_part_to_whole`).
4. **Stage 4: Actionable Reporting**: Segmenting customers based on Lifetime Value (LTV) and visit frequency to drive retention strategies (`13_customer_report`).

---

## Project Overview

This project showcases the following core Data Analytics competencies:
* **Complex SQL Querying:** Mastery of Window Functions (`SUM() OVER`, `LAG()`, `RANK()`), CTEs, and string manipulation (`STRING_SPLIT`).
* **Customer Segmentation:** Building custom logic to categorize users into VIP, At-Risk, and New tiers based on LTV and engagement metrics.
* **Performance Tracking:** Evaluating revenue streams and subscription models to identify high-churn risk areas.

---

## 💡 Key Business Insights & Analytical Approaches

Through the execution of the SQL scripts, several critical business insights were uncovered, driving actionable recommendations for gym management:

* **Customer Segmentation & LTV (Lifetime Value):** By defining custom logic (using `CTEs` and `CASE` statements), the customer base was segmented into highly actionable groups: **VIP** (LTV > $1400 and high visit frequency), **New** (tenure < 3 months), and **At Risk** (inactive). This allows for highly targeted retention campaigns and personalized marketing. *(Ref: 10_data_segmentation.sql & 13_customer_report.sql)*

* **Churn Rate Drivers:** Magnitude analysis revealed specific churn behaviors across different dimensions. By comparing active vs. at-risk members, the analysis pinpointed exactly which `membership_type`, `subscription_model`, and `discount_type` experienced the highest attrition rates, providing direct signals for product restructuring. *(Ref: 05_EDA_magnitude_analysis.sql)*

* **Revenue Contribution (Part-to-Whole):** Utilizing Advanced Window Functions (`SUM() OVER()`), the analysis successfully quantified the exact percentage contribution of each membership tier to the total revenue stream, identifying the core products driving the gym's financial health. *(Ref: 12_part_to_whole_analysis.sql)*

* **Peak Gym Engagement:** By transforming delimited string data (`STRING_SPLIT` on `days_per_week`), the exact frequency of visits per day of the week was extracted. This insight is crucial for optimizing staff scheduling, personal trainer availability, and timing for promotional classes. *(Ref: 04_EDA_measure_exploration.sql)*

* **Performance Tracking (YoY & MoM):** Time-series analysis using `LAG()` functions and `DATETRUNC` effectively tracked revenue growth and membership acquisition velocity, comparing current performance against historical averages to gauge business momentum. *(Ref: 08_change_over_time_analysis.sql & 11_performance_analysis.sql)*

## 🗂️ Repository Structure

```text
📁 fitness_gym_dataset_analysis
├── 📁 dataset
│   └── (Raw and processed fitness dataset CSV files)
├── 📁 docs
│   └── (Project documentation and data dictionaries)
├── 📁 python_scripts
│   └── (Python ETL and data manipulation scripts)
└── 📁 scripts
    ├── 00_create_database.sql
    ├── 01_data_preparation_and_cleaning.sql
    ├── 02_EDA_database_exploration.sql
    ├── ... (EDA dimension, measure, magnitude, ranking scripts)
    ├── 08_change_over_time_analysis.sql
    ├── 09_cumulative_analysis.sql
    ├── 10_data_segmentation.sql
    ├── 11_performance_analysis.sql
    ├── 12_part_to_whole_analysis.sql
    └── 13_customer_report.sql
