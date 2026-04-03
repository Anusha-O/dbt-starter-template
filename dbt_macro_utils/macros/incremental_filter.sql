{% macro incremental_filter(timestamp_column) %}

{% if is_incremental() %}

where {{ timestamp_column }} > (
    select coalesce(max({{ timestamp_column }}), '1900-01-01')
    from {{ this }}
)
{% endif %}

{% endmacro %}