
/*
===============================================================================
Project: Sales Data Cleaning & Quality Validation
Database: PostgreSQL

Purpose:
- Identify outliers in QUANTITYORDERED using the IQR method.
- Review and summarize potential outlier records.
- Create a separate cleaned dataset for further analysis.

Data Policy:
- Preserve the original source table.
- Exclude outliers only from the cleaned dataset.
===============================================================================
*/


-- Step 6: Identify any outliers in the QUANTITYORDERED column
-- and determine how to handle those records.

WITH quartile AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY quantityordered) AS q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY quantityordered) AS q3
    FROM public.sales_dataset_rfm_prj
),

iqr_bounds AS (
    SELECT
        q1,
        q3,
        (q3 - q1) AS iqr,
        q1 - 1.5 * (q3 - q1) AS lower_bound,
        q3 + 1.5 * (q3 - q1) AS upper_bound
    FROM quartile
)

SELECT
    t.*
FROM public.sales_dataset_rfm_prj AS t
CROSS JOIN iqr_bounds AS b
WHERE t.quantityordered < b.lower_bound
   OR t.quantityordered > b.upper_bound
ORDER BY t.quantityordered DESC;


-- Step 7: After cleaning the data, save it into a new table
-- named SALES_DATASET_RFM_PRJ_CLEAN.

-- Recreate the cleaned table to ensure the script can be rerun safely.

DROP TABLE IF EXISTS public.sales_dataset_rfm_prj_clean;

CREATE TABLE public.sales_dataset_rfm_prj_clean AS
WITH quartile AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY quantityordered) AS q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY quantityordered) AS q3
    FROM public.sales_dataset_rfm_prj
),

iqr_bounds AS (
    SELECT
        q1 - 1.5 * (q3 - q1) AS lower_bound,
        q3 + 1.5 * (q3 - q1) AS upper_bound
    FROM quartile
)

SELECT
    t.*
FROM public.sales_dataset_rfm_prj AS t
CROSS JOIN iqr_bounds AS b
WHERE t.quantityordered IS NULL
   OR t.quantityordered BETWEEN b.lower_bound AND b.upper_bound;


-- Verify the number of records in the source and cleaned datasets.

SELECT
    'Source Dataset' AS dataset_name,
    COUNT(*) AS total_records
FROM public.sales_dataset_rfm_prj

UNION ALL

SELECT
    'Cleaned Dataset' AS dataset_name,
    COUNT(*) AS total_records
FROM public.sales_dataset_rfm_prj_clean;


-- Preview the cleaned dataset.

SELECT *
FROM public.sales_dataset_rfm_prj_clean;
