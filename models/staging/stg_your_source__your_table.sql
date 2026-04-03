{{ config(enabled=false) }}
---------------------------------------------------------
-- Staging Model (Template)
---------------------------------------------------------
-- Materialization: view (default set in dbt_project.yml)
-- Purpose:
-- Clean and standardize raw data with minimal transformation
-- Naming convention:
-- stg_<source>__<entity>.sql
-- Example: stg_shopify__orders.sql
-- Grain:
-- One row per <entity>
-- How to use:
-- 1. Remove the config block above
-- 2. Choose ONE option below (source or ref)
-- 3. Replace table/model names
-- 4. Rename, cast, and select only required columns
-- 5. Add additional columns if required (avoid heavy logic)
-- -------------------------------------------------------

SELECT
    -- Rename only
    raw_id AS id,
    raw_name AS name,

    -- Keep same name + cast
    CAST(raw_value AS NUMERIC) AS raw_value,

    -- Rename + cast
    CAST(raw_timestamp AS TIMESTAMP)  AS created_at

    -- Optional system columns (typically added in marts layer)
    -- CURRENT_TIMESTAMP() AS _loaded_at,
    -- 'your_source'       AS _source_system

-- Option 1: Use source (recommended for raw data)
FROM {{ source('your_source', 'your_table') }}

-- Option 2: Use ref (if seed or upstream model exists)
-- FROM {{ ref('your_model_name') }}