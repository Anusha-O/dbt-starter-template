{{ config(enabled=false) }}

-- -------------------------------------------------------
-- Dimension Model (Template)
-- -------------------------------------------------------
-- Purpose:
-- Final dimension model for descriptive attributes
-- used in reporting and BI consumption
--
-- Naming convention:
-- dim_<entity>.sql
-- Example: dim_customers.sql, dim_products.sql
--
-- Materialization: table (default set in dbt_project.yml)
--   Override: {{ config(materialized='incremental') }} → if needed
--
-- Grain:
-- One row per <entity>   ← replace before use
--
-- How to use:
-- 1. Remove the config block above
-- 2. Replace ref() with intermediate models
-- 3. Select only required columns (NO SELECT *)
-- 4. Use audit_columns macro (do NOT hardcode audit fields)
-- -------------------------------------------------------

WITH base AS (

    -- Select only required columns from intermediate model
    SELECT
        primary_key_column,

        -- Descriptive attributes
        attribute_column_1,
        attribute_column_2,
        attribute_column_3

    FROM {{ ref('int_your_entity__transformation') }}

)

SELECT
    base.*

    -- Audit columns (generated via macro — do NOT hardcode)
    , {{ audit_columns('your_source') }}

FROM base

-- Optional: filter invalid records
