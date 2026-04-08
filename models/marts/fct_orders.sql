-- -------------------------------------------------------
-- Fact Model (Example)
-- -------------------------------------------------------
-- Purpose:
-- Final fact table for order metrics
-- used in reporting and BI consumption
--
-- Naming convention: fct_<entity>.sql
-- Example:          fct_orders.sql
--
-- Grain:
-- One row per order
-- -------------------------------------------------------
{{ config(enabled=false) }}

WITH base AS (

    -- Select only required columns from intermediate model
    SELECT
        order_id,
        customer_id,
        order_amount,
        tax_amount,
        total_amount,
        created_at
    FROM {{ ref('int_orders__enriched') }}

)

SELECT
    order_id,
    customer_id,
    order_amount,
    tax_amount,
    total_amount,
    created_at

    -- Audit columns (generated via macro — do NOT hardcode)
    , {{ audit_columns('shopify') }}

FROM base