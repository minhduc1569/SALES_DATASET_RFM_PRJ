TASK 1: Doanh thu theo từng ProductLine, Year và DealSize
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
=> Classic Cars có doanh thu nổi bật nhất, đặc biệt ở nhóm đơn hàng Medium trong năm 2003 và 2004.
----------------------------------
TASK 2: Đâu là tháng có bán tốt nhất mỗi năm
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
=> Nhận xét: Tháng 11 là tháng có doanh thu cao nhất trong cả năm 2003 và 2004. Năm 2005 có tháng 5 đứng đầu trong phạm vi dữ liệu hiện có.
----------------------------------
TASK 3: Product line nào được bán nhiều ở tháng 11

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
=> Classic Cars là ProductLine có doanh thu cao nhất trong tháng 11, đạt 825,156.26 với 46 đơn hàng.
----------------------------------
TASK 4: Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm
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
=>
+ Classic Cars dẫn đầu doanh thu tại UK trong năm 2003 và 2004.
+ Motorcycles đứng đầu năm 2005.
+ Năm 2005 có dữ liệu chưa đầy đủ cả năm nên cần lưu ý khi so sánh.
