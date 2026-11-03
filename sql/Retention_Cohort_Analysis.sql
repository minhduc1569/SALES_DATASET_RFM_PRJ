
-- Project: Customer Retention Cohort Analysis
-- Database: PostgreSQL
-- Source: Original Sales Dataset

WITH first_purchase AS (
    -- Step 1: Identify each customer's first purchase month
    SELECT
        customername,
        DATE_TRUNC('month', MIN(orderdate)) AS cohort_month
    FROM public.sales_dataset_rfm_prj
    GROUP BY customername
),

customer_activity AS (
    -- Step 2: Identify customer activity by month
    SELECT DISTINCT
        customername,
        DATE_TRUNC('month', orderdate) AS order_month
    FROM public.sales_dataset_rfm_prj
),

cohort_index AS (
    -- Step 3: Calculate Cohort Index
    SELECT
        fp.customername,
        fp.cohort_month,
        ca.order_month,

        (
            (EXTRACT(YEAR FROM ca.order_month)
             - EXTRACT(YEAR FROM fp.cohort_month)) * 12
            +
            (EXTRACT(MONTH FROM ca.order_month)
             - EXTRACT(MONTH FROM fp.cohort_month))
            + 1
        )::INTEGER AS cohort_index

    FROM first_purchase fp
    JOIN customer_activity ca
        ON fp.customername = ca.customername
),

cohort_data AS (
    -- Step 4: Keep only the first 4 months
    SELECT
        cohort_month,
        cohort_index,
        COUNT(DISTINCT customername) AS retained_customers
    FROM cohort_index
    WHERE cohort_index BETWEEN 1 AND 4
    GROUP BY
        cohort_month,
        cohort_index
),

cohort_size AS (
    -- Step 5: Calculate the initial cohort size
    SELECT
        cohort_month,
        COUNT(DISTINCT customername) AS cohort_size
    FROM first_purchase
    GROUP BY cohort_month
),

cohort_matrix AS (
    -- Step 6: Generate Cohort Index 1 to 4
    SELECT
        cs.cohort_month,
        cs.cohort_size,
        gs.cohort_index,
        cd.retained_customers,

        DATE_TRUNC(
            'month',
            (SELECT MAX(orderdate)
             FROM public.sales_dataset_rfm_prj)
        ) AS last_data_month

    FROM cohort_size cs
    CROSS JOIN GENERATE_SERIES(1, 4) AS gs(cohort_index)

    LEFT JOIN cohort_data cd
        ON cs.cohort_month = cd.cohort_month
        AND gs.cohort_index = cd.cohort_index
)

-- Step 7: Calculate Retention Rate
SELECT
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort_month,
    cohort_size,

    -- Cohort Index 1
    MAX(
        CASE WHEN cohort_index = 1
        THEN retained_customers END
    ) AS month_1,

    ROUND(
        MAX(
            CASE WHEN cohort_index = 1
            THEN retained_customers * 100.0 / cohort_size END
        ), 2
    ) AS month_1_retention,

    -- Cohort Index 2
    MAX(
        CASE WHEN cohort_index = 2
        AND cohort_month + INTERVAL '1 month' <= last_data_month
        THEN COALESCE(retained_customers, 0) END
    ) AS month_2,

    ROUND(
        MAX(
            CASE WHEN cohort_index = 2
            AND cohort_month + INTERVAL '1 month' <= last_data_month
            THEN COALESCE(retained_customers, 0) * 100.0
                 / cohort_size END
        ), 2
    ) AS month_2_retention,

    -- Cohort Index 3
    MAX(
        CASE WHEN cohort_index = 3
        AND cohort_month + INTERVAL '2 months' <= last_data_month
        THEN COALESCE(retained_customers, 0) END
    ) AS month_3,

    ROUND(
        MAX(
            CASE WHEN cohort_index = 3
            AND cohort_month + INTERVAL '2 months' <= last_data_month
            THEN COALESCE(retained_customers, 0) * 100.0
                 / cohort_size END
        ), 2
    ) AS month_3_retention,

    -- Cohort Index 4
    MAX(
        CASE WHEN cohort_index = 4
        AND cohort_month + INTERVAL '3 months' <= last_data_month
        THEN COALESCE(retained_customers, 0) END
    ) AS month_4,

    ROUND(
        MAX(
            CASE WHEN cohort_index = 4
            AND cohort_month + INTERVAL '3 months' <= last_data_month
            THEN COALESCE(retained_customers, 0) * 100.0
                 / cohort_size END
        ), 2
    ) AS month_4_retention

FROM cohort_matrix
GROUP BY
    cohort_month,
    cohort_size
ORDER BY cohort_month;
