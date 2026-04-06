-- -------------------------------------------------------
-- Singular Test (Template)
-- -------------------------------------------------------
-- Purpose:
-- Custom business rule validation
-- Test fails if any rows are returned
--
-- Naming convention: assert_<what_you_are_testing>.sql
-- Example: assert_orders_total_positive.sql
--
-- Command to run:
-- dbt test
--
-- How to use:
-- 1. Replace model name
-- 2. Write SQL that returns violating rows
-- 3. Remove placeholder WHERE condition
--
-- Note:
-- - Test passes if zero rows returned
-- - Test fails if one or more rows returned
-- -------------------------------------------------------

SELECT
    primary_key_column,   -- e.g., order_id
    column_to_validate    -- e.g., amount

FROM {{ ref('your_model') }}

-- Example: test for NULL values
WHERE column_to_validate IS NULL

-- Other examples:
-- WHERE column_to_validate < 0
-- WHERE status NOT IN ('active','inactive')