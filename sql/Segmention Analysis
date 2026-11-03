
---- Tính toán ba chỉ số RFM
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
)
SELECT *
FROM rfm
ORDER BY monetary DESC;
---- Chấm điểm RFM từ 1 đến 5
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
rfm_codes AS (
    SELECT
        *,
        CONCAT(r_score, f_score, m_score) AS rfm_code

    FROM rfm_scores
)
---- PHÂN NHÓM KHÁCH HÀNG BẰNG RFM
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
