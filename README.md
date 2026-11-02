
# Sales Data Cleaning & Quality Validation

## 1. Project Overview

This personal SQL project focuses on data cleaning, data quality validation, and data preparation using PostgreSQL.

The project demonstrates practical SQL skills through a structured workflow, including data type conversion, missing value checks, customer name standardization, date feature extraction, and outlier detection.

## 2. Objectives

- Convert columns to appropriate data types.
- Identify missing and blank values in key fields.
- Split and standardize customer contact names.
- Extract quarter, month, and year from order dates.
- Detect potential outliers in the `quantityordered` column using the Interquartile Range (IQR) method.
- Create and validate a separate cleaned dataset while preserving the original source table.

## 3. Tools & Technologies

- **Database:** PostgreSQL
- **Language:** SQL
- **Version Control:** Git and GitHub

## 4. Dataset

The project uses a sales dataset containing order information, product details, sales values, and customer contact information.

The dataset is used for personal learning and portfolio development.

## 5. Project Workflow

1. **Data Type Conversion:** Convert columns to appropriate data types.
2. **Data Quality Checks:** Identify missing values and blank fields.
3. **Customer Name Transformation:** Split contact names into first and last names and standardize capitalization.
4. **Date Feature Extraction:** Extract quarter, month, and year from order dates.
5. **Outlier Detection:** Apply the IQR method to identify potential outliers in `quantityordered`.
6. **Cleaned Dataset Creation:** Create a separate dataset excluding identified outliers.
7. **Data Validation:** Compare source and cleaned record counts to verify the cleaning results.
After completing data preparation and quality validation in PostgreSQL, the processed sales dataset was used for further analysis in Microsoft Excel.
The analysis focused on customer purchasing behavior and retention patterns.
**Key Activities:**
- Organized customer transactions into monthly cohorts based on their first purchase date.
- Calculated customer retention rates across different cohort periods.
- Developed a retention heatmap to visualize customer repurchase behavior.
- Analyzed purchasing patterns and generated business insights.
  
## 6. Repository Structure

```text
SALES_DATASET_RFM_PRJ/
├── sql/
│   ├── 01_data_type_conversion.sql
│   ├── 02_data_cleaning.sql
│   └── 03_outlier_analysis.sql
├── .gitignore
└── README.md
```

## 7. Key SQL Techniques

- `ALTER TABLE` and `UPDATE`
- `CASE WHEN` conditional logic
- `EXTRACT` for date feature engineering
- Common Table Expressions (CTEs)
- `PERCENTILE_CONT` for quartile calculation
- IQR-based outlier detection
- `CREATE TABLE AS SELECT`
- Aggregate functions and conditional counting
- Data quality validation through record count comparison

## 8. Data Quality Results

The initial dataset contains **2,823 records**.

The IQR method identified **8 potential outlier records** in the `quantityordered` column. These records were excluded from the separate cleaned dataset, while the original source table was preserved.

| Metric | Result |
|---|---:|
| Original dataset records | 2,823 |
| Potential outlier records | 8 |
| Cleaned dataset records | 2,815 |

### Data Handling Approach

- Preserve the original source dataset for traceability.
- Create a separate cleaned table for subsequent analysis.
- Exclude records outside the IQR bounds from the cleaned dataset.
- Retain records with missing `quantityordered` values for further review.
- Validate record counts after creating the cleaned dataset.

### 9. Analysis Methodology

- Cohort Definition: Customers were grouped based on
  their first purchase month.
- Retention Calculation: Measured the percentage of
  customers returning to make subsequent purchases.
- Visualization: Used Excel formulas, supporting
  calculation tables and conditional formatting
  to build a retention heatmap.
  
  ### 10. Key Findings

- Analyzed 92 unique customers across 21 monthly cohorts.
- Identified a 26% three-month repeat purchase rate.
- Observed a median of 7 months until the second purchase.
- Visualized customer retention trends through
  cohort-based heatmaps.
  
## 11. Notes & Limitations

This is an ongoing personal project developed for learning and portfolio purposes.

The IQR method identifies statistically unusual values; however, an outlier does not necessarily indicate an error. Outlier records should be reviewed in their business context before being excluded from analysis.

The SQL scripts should be executed in the appropriate order. The cleaning process can be refined as additional data quality requirements are identified.
