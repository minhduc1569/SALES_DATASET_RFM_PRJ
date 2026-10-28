-- Step 6: Identify any outliers in the QUANTITYORDERED column and determine how to handle those records.
WITH quartile AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) AS q3
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
SELECT t.*
FROM public.sales_dataset_rfm_prj t, iqr_bounds b
WHERE t.quantityordered < b.lower_bound 
   OR t.quantityordered > b.upper_bound;
WITH quartile AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) AS q3
    FROM public.sales_dataset_rfm_prj
),
iqr_bounds AS (
    SELECT 
        q1 - 1.5 * (q3 - q1) AS lower_bound,
        q3 + 1.5 * (q3 - q1) AS upper_bound
    FROM quartile
)
DELETE FROM public.sales_dataset_rfm_prj t
USING iqr_bounds b
WHERE t.quantityordered < b.lower_bound 
   OR t.quantityordered > b.upper_bound;
-- Step 7: After cleaning the data, save it into a new table named SALES_DATASET_RFM_PRJ_CLEAN
CREATE TABLE public.SALES_DATASET_RFM_PRJ_CLEAN AS 
SELECT * 
FROM public.sales_dataset_rfm_prj;
SELECT * FROM public.SALES_DATASET_RFM_PRJ_CLEAN
