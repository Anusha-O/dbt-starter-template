-- -------------------------------------------------------
-- SQL-Based Snapshot (Template)
-- -------------------------------------------------------
-- Purpose:
-- Track historical changes to source data (SCD Type 2)
--
-- Use this when:
-- - You need joins, filters, or transformations
-- - YAML-based relation snapshots are not sufficient
--
-- Naming convention: <entity>_snapshot.sql
-- Example: orders_snapshot.sql
--
-- Grain:
-- One row per unique_key per validity period (SCD Type 2)
--
-- Command to run:
-- dbt snapshot
--
-- How to use:
-- 1. Replace snapshot name
-- 2. Replace unique_key and updated_at
-- 3. Select only required columns (avoid SELECT *)
-- 4. Remove enabled=false when ready to use
-- -------------------------------------------------------

{% snapshot snapshot_sql_example %}

{{
    config(
        target_schema='snapshots',
        unique_key='id',
        enabled=false,
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

-- Strategy options:
-- timestamp → detects changes using updated_at column
-- check     → detects changes by comparing column values (requires check_cols)

-- For check strategy use instead:
-- strategy='check',
-- check_cols='all',                  -- track all columns (simpler, slower)
-- check_cols=['status', 'amount'],   -- track selected columns (recommended)

-- Optional: replace NULL in dbt_valid_to for active records
-- dbt_valid_to_current="timestamp('9999-12-31 00:00:00')"

-- Optional: controls behaviour when source rows are deleted
-- hard_deletes='invalidate'

SELECT
    id,
    column_1,
    column_2,
    updated_at
FROM {{ source('raw', 'your_table') }}

-- Optional: filter rows before snapshotting
-- WHERE is_deleted = false

{% endsnapshot %}