{% macro audit_columns(source_name) %}

    -- Standard audit columns (mandatory for all mart models)

    CURRENT_TIMESTAMP() AS _loaded_at,      -- when data is written
    '{{ source_name }}' AS _source_system,  -- source system (e.g., shopify)
    '{{ this }}' AS _dbt_model              -- model name (for lineage)

{% endmacro %}
