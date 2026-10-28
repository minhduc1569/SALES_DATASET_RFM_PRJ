# Sales Data Cleaning & Quality Validation

## 1. Project Overview

This personal SQL project focuses on data cleaning, data quality validation, and data preparation using PostgreSQL. The project uses a sales dataset to demonstrate practical SQL skills and a structured approach to handling data quality issues.

## 2. Objectives

- Convert columns to appropriate data types.
- Identify missing and blank values in key fields.
- Split and standardize customer contact names.
- Extract quarter, month, and year from order dates.
- Detect outliers in the quantity ordered column using the Interquartile Range (IQR) method.
- Create a cleaned dataset for further analysis.

## 3. Tools & Technologies

- PostgreSQL
- SQL
- GitHub

## 4. Dataset

The project uses a sales dataset containing order information, product details, sales values, and customer contact information.

The dataset is intended for personal learning and portfolio development.

## 5. Project Workflow

1. Data type conversion
2. Data quality checks
3. Customer name transformation
4. Date feature extraction
5. Outlier detection using the IQR method
6. Cleaned dataset creation and validation

## 6. Repository Structure

- `sql/01_data_type_conversion.sql`: Converts columns to appropriate data types.
- `sql/02_data_cleaning.sql`: Checks missing values and transforms customer contact names and date fields.
- `sql/03_outlier_analysis.sql`: Identifies outliers using the IQR method and creates a cleaned dataset.
- `README.md`: Documents the project objectives, workflow, and SQL techniques.
- `.gitignore`: Specifies files and directories to exclude from version control.

## 7. Key SQL Techniques

- `ALTER TABLE`
- `UPDATE`
- `CASE WHEN`
- `EXTRACT`
- Common Table Expressions (CTEs)
- `PERCENTILE_CONT`
- IQR-based outlier detection
- `CREATE TABLE AS SELECT`

## 8. Notes

This is an ongoing personal project developed for learning and portfolio purposes. The SQL scripts may be refined as the project develops.

The scripts should be reviewed and executed in the appropriate order. Outlier records should be reviewed before removal, and data-cleaning decisions should be documented to maintain data quality and reproducibility.
