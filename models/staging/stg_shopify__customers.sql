-- -------------------------------------------------------
-- Staging Model (Example)
-- -------------------------------------------------------
-- Purpose:
-- Clean and standardize raw customer data from source
--
-- Naming convention: stg_<source>__<table>.sql
-- Example:          stg_shopify__customers.sql
-- Grain:
-- One row per customer
---------------------------------------------------------
{{ config(enabled=false) }}
SELECT
   
    customer_id,
    -- Rename only
    customer_name  AS name,
    -- Keep same name + cast
    CAST(customer_created_at AS TIMESTAMP) AS customer_created_at,
    -- Rename + cast
    CAST(customer_updated_at AS TIMESTAMP) AS updated_at,
    -- Keep same name (no change)
    email,
    CURRENT_TIMESTAMP()  AS _loaded_at,      -- when data is written
FROM {{ source('shopify', 'customers') }}