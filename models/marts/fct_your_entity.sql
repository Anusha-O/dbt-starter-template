{{ config(enabled=false) }}
-- -------------------------------------------------------
-- Mart Model (Template)
-- -------------------------------------------------------
-- Purpose:
-- Final model for reporting and BI consumption
--
-- Naming convention:
-- fct_<entity>.sql  → fact tables
-- Example: fct_orders.sql
--
-- Materialization: table (default set in dbt_project.yml)
--   Override: {{ config(materialized='incremental') }} → for large datasets
--   Note: Use incremental only when append/update logic is defined
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
        referencing_column,
        column_1,
        column_2,
        metric_column
    FROM {{ ref('int_your_entity__transformation') }}

)

SELECT
    base.*

    -- Audit columns (generated via macro — do NOT hardcode)
    , {{ audit_columns('your_source') }}

FROM base

-- Optional: filter invalid records