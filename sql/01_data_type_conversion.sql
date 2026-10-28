-- Project: Sales Data Cleaning & Quality Validation
-- Database: PostgreSQL
-- Purpose: Convert columns to appropriate data types.
-- Note: Verify source values before running type conversions.

-- 1. Convert order identifiers and quantity to INTEGER.
ALTER TABLE public.sales_dataset_rfm_prj 
    ALTER COLUMN ordernumber TYPE INTEGER USING ordernumber::integer,
    ALTER COLUMN quantityordered TYPE INTEGER USING quantityordered::integer,
    ALTER COLUMN orderlinenumber TYPE INTEGER USING orderlinenumber::integer;

-- 2. Convert monetary and price columns to NUMERIC.
ALTER TABLE public.sales_dataset_rfm_prj 
    ALTER COLUMN priceeach TYPE NUMERIC(10, 2) USING priceeach::numeric,
    ALTER COLUMN sales TYPE NUMERIC(10, 2) USING sales::numeric,
    ALTER COLUMN msrp TYPE NUMERIC(10, 2) USING msrp::numeric;

--- 3. Convert orderdate to DATE.
ALTER TABLE public.sales_dataset_rfm_prj 
    ALTER COLUMN orderdate TYPE DATE USING orderdate::date;
