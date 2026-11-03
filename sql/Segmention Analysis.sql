-- ========================================================
-- Project: RFM Customer Segmentation Analysis
-- Database: PostgreSQL
--Source: Original Sales Dataset
-- ========================================================

-- Step 1: Calculate raw RFM metrics (Recency, Frequency, Monetary)
WITH reference_date AS (
    SELECT MAX(orderdate) + INTERVAL '1 day' AS snapshot_date
    FROM public.sales_dataset_rfm_prj_clean
),
rfm AS (
    SELECT
        customername,
        (SELECT snapshot_date FROM reference_date)::DATE
            - MAX(orderdate) AS recency,
        COUNT(DISTINCT ordernumber) AS frequency,
        SUM(sales) AS monetary
    FROM public.sales_dataset_rfm_prj_clean
    GROUP BY customername
),

-- Step 2: Score RFM metrics from 1 to 5 using NTILE
rfm_scores AS (
    SELECT
        customername,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency ASC
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary ASC
        ) AS m_score

    FROM rfm
),

-- Step 3: Concatenate RFM scores into a single cell code (e.g., '555')
rfm_codes AS (
    SELECT
        *,
        CONCAT(r_score, f_score, m_score) AS rfm_code
    FROM rfm_scores
)

-- Step 4: Map RFM cell codes to customer segments and sort
SELECT
    customername,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    rfm_code,

    CASE
        WHEN rfm_code IN (
            '555', '554', '544', '545',
            '454', '455', '445'
        ) THEN 'Champions'

        WHEN rfm_code IN (
            '543', '444', '435', '355',
            '354', '345', '344', '335'
        ) THEN 'Loyal Customers'

        WHEN rfm_code IN (
            '553', '551', '552', '541',
            '542', '533', '532', '531',
            '452', '451', '442', '441',
            '431', '453', '433', '432',
            '423', '353', '352', '351',
            '342', '341', '333', '323'
        ) THEN 'Potential Loyalist'

        WHEN rfm_code IN (
            '512', '511', '422', '421',
            '412', '411', '311'
        ) THEN 'Recent Customers'

        WHEN rfm_code IN (
            '525', '524', '523', '522',
            '521', '515', '514', '513',
            '425', '424', '413', '414',
            '415', '315', '314', '313'
        ) THEN 'Promising'

        WHEN rfm_code IN (
            '535', '534', '443', '434',
            '343', '334', '325', '324'
        ) THEN 'Customers Needing Attention'

        WHEN rfm_code IN (
            '331', '321', '312', '221', '213'
        ) THEN 'About To Sleep'

        ELSE 'Others'
    END AS customer_segment

FROM rfm_codes
ORDER BY
    r_score DESC,
    f_score DESC,
    m_score DESC;
