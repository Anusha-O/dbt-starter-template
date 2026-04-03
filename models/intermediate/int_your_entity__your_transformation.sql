{{ config(enabled=false) }}
----------------------------------------------------------
-- Intermediate Model (Template)
----------------------------------------------------------

-- Materialization: view (default set in dbt_project.yml)
-- Override: {{ config(materialized='table') }} -if model is reused heavily or logic is complex
-- Override: {{ config(materialized='ephemeral') }} - if logic is simple and used only once

-- Purpose:
-- Perform joins, aggregations, and business logic
-- that would otherwise make mart models too complex
--
-- Naming convention: int_<entity>__<transformation>.sql
-- Example:int_orders__enriched.sql
--
-- Grain:
-- One row per <entity>
--
-- How to use:
-- 1. Remove config block above
-- 2. Replace ref() model names with actual staging models
-- 3. Select only required columns in each CTE (final SELECT * is safe)
-- 4. Add joins and transformations using CTEs
-- -------------------------------------------------------
WITH source_model_1 AS (

    -- Pull only required columns from staging model
    SELECT
        id,
        column_1,
        amount
    FROM {{ ref('stg_your_source__your_table_1') }}

),

source_model_2 AS (

    -- Pull only required columns from staging model
    SELECT
        id,
        column_2,
        amount
    FROM {{ ref('stg_your_source__your_table_2') }}

),

joined AS (

    SELECT
        -- Keys
        s1.id,

        -- Columns from model 1
        s1.column_1,

        -- Columns from model 2
        s2.column_2,

        -- Derived column (business logic)
        s1.amount + s2.amount AS total_amount

    FROM source_model_1 AS s1
    LEFT JOIN source_model_2 AS s2
        ON s1.id = s2.id
        -- Join condition must align with business key (not always id)
        -- LEFT JOIN  → keep all records from model 1
        -- INNER JOIN → keep only matched records
        -- FULL JOIN  → keep all records from both models

)

-- Safe to use SELECT * here because 'joined' CTE defines all columns explicitly
SELECT *
FROM joined