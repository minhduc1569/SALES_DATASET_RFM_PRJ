# Sales Data Processing, Quality Validation & Customer Analysis

## 1. Project Overview

This personal end-to-end data analysis project focuses on data processing, data quality validation, and customer behavior analysis using PostgreSQL and Microsoft Excel.

The project demonstrates practical data analysis skills through a structured workflow, from raw data preparation and quality validation to business analysis, customer segmentation, and retention analysis.

The analysis covers sales performance, customer purchasing behavior, RFM-based customer segmentation, and monthly customer retention patterns.

## 2. Project Objectives

- Convert raw data columns into appropriate data types.
- Identify missing values, blank fields, and potential data quality issues.
- Standardize customer contact names.
- Extract time-based features from order dates.
- Detect potential outliers using the Interquartile Range (IQR) method.
- Create and validate a separate cleaned dataset while preserving the original source table.
- Analyze sales performance across product lines, years, deal sizes, and markets.
- Identify the best-performing customers using RFM analysis.
- Segment customers based on Recency, Frequency, and Monetary scores.
- Analyze customer retention patterns using monthly Cohort Analysis.

## 3. Tools & Technologies

- **Database:** PostgreSQL
- **Query Language:** SQL
- **Data Analysis & Visualization:** Microsoft Excel
- **Version Control:** Git and GitHub

## 4. Dataset

The project uses a sales dataset containing order information, product details, sales values, customer information, and transaction dates.

The dataset is used for personal learning and portfolio development.

## 5. Project Workflow

### Phase 1: Data Processing & Quality Validation (PostgreSQL)

1. **Data Type Conversion:** Convert columns to appropriate data types.
2. **Data Quality Checks:** Identify missing values and blank fields.
3. **Customer Name Transformation:** Split contact names into first and last names and standardize capitalization.
4. **Date Feature Extraction:** Extract quarter, month, and year from order dates.
5. **Outlier Detection:** Apply the IQR method to identify potential outliers in `quantityordered`.
6. **Cleaned Dataset Creation:** Create a separate cleaned dataset excluding identified outliers.
7. **Data Validation:** Compare source and cleaned record counts to verify the cleaning results.

### Phase 2: Business & Customer Analysis (PostgreSQL)

1. **Sales Performance Analysis:** Analyze revenue by product line, year, and deal size.
2. **Monthly Revenue Analysis:** Identify the highest-revenue month for each year.
3. **Product Line Analysis:** Identify the best-performing product lines in November.
4. **Market Analysis:** Evaluate product line performance in the UK market.
5. **RFM Customer Segmentation:** Calculate Recency, Frequency, and Monetary metrics, assign scores, combine them into RFM codes, and classify customers into segments.
6. **Best Customer Identification:** Identify the best customer based on RFM segmentation and purchasing performance.

### Phase 3: Customer Retention Analysis (Microsoft Excel)

1. **Cohort Definition:** Group customers based on their first purchase month.
2. **Cohort Index Calculation:** Track customer activity across the initial purchase month and the following three months (Cohort Index 1–4).
3. **Retention Rate Calculation:** Calculate the percentage of customers returning to make purchases in subsequent months.
4. **Retention Heatmap:** Use Excel PivotTables, formulas, and conditional formatting to visualize customer retention patterns.
5. **Retention Analysis:** Compare retention rates across monthly cohorts and identify customer repurchase trends.

## 6. Repository Structure

```text
SALES_DATASET_RFM_PRJ/
├──sql/
  ├── 01_data_type_conversion.sql
  ├── 02_data_cleaning.sql
  ├── 03_outlier_analysis.sql
  ├── Retention_Cohort_Analysis.sql
  ├── Segmentation Analysis.sql
  └── Task Request.sql
├── .gitignore
└── README.md
```

## 7. Key SQL Techniques

- `ALTER TABLE` and `UPDATE`
- `CASE WHEN` conditional logic
- `EXTRACT` and `DATE_TRUNC` for date feature engineering
- Common Table Expressions (CTEs)
- Window Functions: `RANK()`, `ROW_NUMBER()`, and `NTILE()`
- `PERCENTILE_CONT` for quartile calculation
- IQR-based outlier detection
- `CREATE TABLE AS SELECT`
- Aggregate functions: `SUM()`, `COUNT()`, `MAX()`
- `COUNT(DISTINCT)` for unique customer and order analysis
- Data quality validation through record count comparison
- RFM scoring and customer segmentation

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

## 9. Analysis Methodology

### 9.1. Business Analysis

Used SQL aggregation and window functions to analyze sales performance across different dimensions, including product lines, time periods, deal sizes, and markets.

### 9.2. RFM Customer Segmentation

Applied the RFM framework to evaluate customer purchasing behavior using three metrics:

- **Recency (R):** Number of days since the customer's most recent purchase.
- **Frequency (F):** Number of distinct orders placed by the customer.
- **Monetary (M):** Total sales value generated by the customer.

Customers were scored from 1 to 5 for each metric. The three scores were concatenated into RFM codes and mapped to predefined customer segments, such as:

- Champions
- Loyal Customers
- Potential Loyalist
- Recent Customers
- Promising
- Customers Needing Attention
- About To Sleep
- Others

The RFM results were also used to identify the best customer based on customer segment and purchasing performance.

### 9.3. Retention Cohort Analysis

Performed monthly Cohort Analysis to understand customer repurchase behavior.

- **Cohort Definition:** Customers were grouped according to their first purchase month.
- **Cohort Index:** Each cohort was tracked over four monthly periods, from Index 1 to Index 4.
- **Retention Rate:** Calculated the percentage of customers who made subsequent purchases relative to the initial cohort size.
- **Visualization:** Built a retention heatmap in Microsoft Excel using PivotTables, supporting calculation tables, and conditional formatting.

## 10. Key Findings

### Data Processing & Quality

- Processed an initial dataset of 2,823 records.
- Identified 8 potential outlier records using the IQR method.
- Created a separate cleaned dataset containing 2,815 records while preserving the original data.

### Customer Analysis

- Analyzed 92 unique customers across 21 monthly cohorts.
- Identified customer purchasing patterns using RFM metrics.
- Classified customers into behavioral segments based on concatenated RFM scores.
- Identified the best customer based on RFM segmentation and purchasing performance.

### Customer Retention

- Identified a 26% three-month repeat purchase rate.
- Observed a median of 7 months until the second purchase.
- Visualized customer retention trends through monthly cohort heatmaps.
- Limited each cohort's observation period to four months (Index 1–4).

## 11. Notes & Limitations

This is a personal project developed for learning and portfolio purposes.

The IQR method identifies statistically unusual values; however, an outlier does not necessarily indicate a data error. Outlier records should be reviewed in their business context before being excluded from analysis.

The original dataset is preserved to maintain data traceability. The cleaned dataset is used for subsequent data preparation and analysis, while the original dataset is retained for analyses that require the full transaction history.

Cohort retention results depend on the available observation period. Cohorts without sufficient follow-up months should not be interpreted as having zero retention.

RFM scores and customer segments depend on the scoring methodology and predefined segmentation criteria used in this project.
