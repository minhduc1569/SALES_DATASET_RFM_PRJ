-- ==========================================
-- TASK 1: Revenue by ProductLine, Year, and DealSize
-- ==========================================
SELECT
    productline,
    EXTRACT(YEAR FROM orderdate)::INTEGER AS year_id,
    dealsize,
    SUM(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean
GROUP BY
    productline,
    EXTRACT(YEAR FROM orderdate),
    dealsize
ORDER BY revenue DESC;
-- => Classic Cars shows the most outstanding revenue, especially within the Medium deal size category in 2003 and 2004.


-- ==========================================
-- TASK 2: Best-Selling Month of Each Year
-- ==========================================
WITH monthly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM orderdate)::INTEGER AS year_id,
        EXTRACT(MONTH FROM orderdate)::INTEGER AS month_id,
        SUM(sales) AS revenue,
        COUNT(DISTINCT ordernumber) AS order_number
    FROM public.sales_dataset_rfm_prj_clean
    GROUP BY
        EXTRACT(YEAR FROM orderdate),
        EXTRACT(MONTH FROM orderdate)
),
ranked_months AS (
    SELECT
        year_id,
        month_id,
        revenue,
        order_number,
        RANK() OVER (
            PARTITION BY year_id
            ORDER BY revenue DESC
        ) AS ranking
    FROM monthly_revenue
)
SELECT
    year_id,
    month_id,
    revenue,
    order_number
FROM ranked_months
WHERE ranking = 1
ORDER BY year_id;
-- => Insights: November generated the highest revenue in both 2003 and 2004. In 2005, May ranked highest within the available data range.


-- ==========================================
-- TASK 3: Top Performing Product Line in November
-- ==========================================
SELECT
    productline,
    EXTRACT(MONTH FROM orderdate)::INTEGER AS month_id,
    SUM(sales) AS revenue,
    COUNT(DISTINCT ordernumber) AS order_number
FROM public.sales_dataset_rfm_prj_clean
WHERE EXTRACT(MONTH FROM orderdate) = 11
GROUP BY
    productline,
    EXTRACT(MONTH FROM orderdate)
ORDER BY revenue DESC;
-- => Classic Cars is the top-performing product line in November, reaching 825,156.26 in revenue across 46 orders.


-- ==========================================
-- TASK 4: Best-Selling Product Line in the UK Each Year
-- ==========================================
WITH uk_revenue AS (
    SELECT
        EXTRACT(YEAR FROM orderdate)::INTEGER AS year_id,
        productline,
        SUM(sales) AS revenue
    FROM public.sales_dataset_rfm_prj_clean
    WHERE country = 'UK'
    GROUP BY
        EXTRACT(YEAR FROM orderdate),
        productline
),
ranked_revenue AS (
    SELECT
        year_id,
        productline,
        revenue,
        RANK() OVER (
            PARTITION BY year_id
            ORDER BY revenue DESC
        ) AS ranking
    FROM uk_revenue
)
SELECT
    year_id,
    productline,
    revenue,
    ranking
FROM ranked_revenue
ORDER BY year_id, ranking;
-- => Insights:
-- + Classic Cars led the revenue in the UK for 2003 and 2004.
-- + Motorcycles took the top spot in 2005.
-- + Note: The 2005 dataset is incomplete for the full year, which should be considered when making comparisons.
