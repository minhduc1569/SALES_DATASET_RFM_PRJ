-- Project: Sales Data Cleaning & Quality Validation
-- Database: PostgreSQL
-- Purpose: Check missing values and transform customer/date fields.

-- 1. Check NULL values in key columns.
SELECT 
    SUM(CASE WHEN ordernumber IS NULL OR ordernumber::text = '' THEN 1 ELSE 0 END) AS null_ordernumber,
    SUM(CASE WHEN quantityordered IS NULL OR quantityordered::text = '' THEN 1 ELSE 0 END) AS null_quantityordered,
    SUM(CASE WHEN priceeach IS NULL OR priceeach::text = '' THEN 1 ELSE 0 END) AS null_priceeach,
    SUM(CASE WHEN orderlinenumber IS NULL OR orderlinenumber::text = '' THEN 1 ELSE 0 END) AS null_orderlinenumber,
    SUM(CASE WHEN sales IS NULL OR sales::text = '' THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN orderdate IS NULL OR orderdate::text = '' THEN 1 ELSE 0 END) AS null_orderdate
FROM public.sales_dataset_rfm_prj;

-- 2. Add columns for customer first and last names.
ALTER TABLE public.sales_dataset_rfm_prj 
    ADD COLUMN contactlastname VARCHAR(100),
    ADD COLUMN contactfirstname VARCHAR(100);

-- 3. Split the contact name.
-- Assumption: first token = first name;
-- remaining text = last name.
ALTER TABLE public.sales_dataset_rfm_prj 
    ADD COLUMN contactlastname VARCHAR(100),
    ADD COLUMN contactfirstname VARCHAR(100);

UPDATE public.sales_dataset_rfm_prj
SET 
    contactfirstname = SPLIT_PART(contactfullname, ' ', 1),
    contactlastname = SUBSTRING(contactfullname FROM POSITION(' ' IN contactfullname) + 1);

-- 4. Standardize capitalization.
UPDATE public.sales_dataset_rfm_prj
SET 
    contactfirstname = INITCAP(LOWER(contactfirstname)),
    contactlastname = INITCAP(LOWER(contactlastname));

-- 5. Add quarter, month, and year columns.
ALTER TABLE public.sales_dataset_rfm_prj 
    ADD COLUMN IF NOT EXISTS qtr_id INTEGER,
    ADD COLUMN IF NOT EXISTS month_id INTEGER,
    ADD COLUMN IF NOT EXISTS year_id INTEGER;
UPDATE public.sales_dataset_rfm_prj
SET 
    qtr_id = EXTRACT(QUARTER FROM orderdate),
    month_id = EXTRACT(MONTH FROM orderdate),
    year_id = EXTRACT(YEAR FROM orderdate);
