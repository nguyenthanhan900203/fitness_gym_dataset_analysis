# 🏋️‍♂️ Fitness Gym Data Analytics Project
 
This project demonstrates an end-to-end data analytics workflow, from database initialization and data cleansing to exploratory data analysis (EDA) and advanced customer segmentation. Designed as a portfolio project, it highlights industry best practices in extracting actionable business insights from raw operational data using advanced SQL techniques.

---

## 🏗️ Analytical Workflow (The Data Journey)

1. **Stage 1: Preparation & Cleansing**: Creating the relational database schema, handling missing values, and standardizing data formats (`00_create` to `01_data_prep`).
2. **Stage 2: Exploratory Data Analysis (EDA)**: Profiling the data across multiple dimensions (demographics, memberships, locations) and measuring magnitudes to understand distributions (`02_EDA` to `07_EDA`).
3. **Stage 3: Advanced Business Logic**: Applying time-series tracking (YoY, MoM), cumulative calculations, and part-to-whole market share analysis (`08_change_over_time` to `12_part_to_whole`).
4. **Stage 4: Actionable Reporting**: Segmenting customers based on Lifetime Value (LTV) and visit frequency to drive retention strategies (`13_customer_report`).

---

## 📖 Project Overview

This project showcases the following core Data Analytics competencies:
* **Complex SQL Querying:** Mastery of Window Functions (`SUM() OVER`, `LAG()`, `RANK()`), CTEs, and string manipulation (`STRING_SPLIT`).
* **Customer Segmentation:** Building custom logic to categorize users into VIP, At-Risk, and New tiers based on LTV and engagement metrics.
* **Performance Tracking:** Evaluating revenue streams and subscription models to identify high-churn risk areas.

---

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
