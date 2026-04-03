-- -------------------------------------------------------
-- Dimension Model (Example)
-- -------------------------------------------------------
-- Purpose:
-- Final dimension table for customer attributes
-- used in reporting and BI consumption
--
-- Naming convention: dim_<entity>.sql
-- Example:          dim_customers.sql
--
-- Grain:
-- One row per customer
-- -------------------------------------------------------

WITH base AS (

    -- Select required columns (directly from staging — no intermediate needed for simple dimensions)
    SELECT
        customer_id,
        name,
        email,
        customer_created_at,
        updated_at
    FROM {{ ref('stg_shopify__customers') }}

)

SELECT
    base.*
    -- Audit columns (generated via macro — do NOT hardcode)
    , {{ audit_columns('shopify') }}

FROM base