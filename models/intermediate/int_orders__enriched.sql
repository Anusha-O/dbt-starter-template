-- -------------------------------------------------------
-- Intermediate Model (Example)
-- -------------------------------------------------------
-- Purpose:
-- Enrich orders with customer information and apply
-- business logic calculations
--
-- Naming convention: int_<entity>__<transformation>.sql
-- Example:          int_orders__enriched.sql
--
-- Grain:
-- One row per order
-- -------------------------------------------------------
{{ config(enabled=false) }}
WITH orders AS (

    SELECT
        order_id,
        customer_id,
        order_amount,
        created_at
    FROM {{ ref('stg_shopify__orders') }}

),

customers AS (

    SELECT
        customer_id,
        customer_name,
        customer_email
    FROM {{ ref('stg_shopify__customers') }}

),

joined AS (

    SELECT
        -- Keys
        o.order_id,
        o.customer_id,

        -- Customer details
        c.customer_name,
        c.customer_email,

        -- Original fields
        o.order_amount,
        o.created_at,

        -- Business logic
        o.order_amount * 0.1                        AS tax_amount,

        -- Derived metric
        o.order_amount + (o.order_amount * 0.1)     AS total_amount

    FROM orders AS o
    LEFT JOIN customers AS c
        ON o.customer_id = c.customer_id

)

-- Safe to use SELECT * because 'joined' defines all columns explicitly
SELECT *
FROM joined