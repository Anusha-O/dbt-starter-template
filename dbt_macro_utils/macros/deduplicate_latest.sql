{% macro deduplicate_latest(relation, partition_by, order_by) %}

select *
from (
    select
        *,
        row_number() over (
            partition by {{ partition_by }}
            order by {{ order_by }} desc
        ) as rn
    from {{ relation }}
)
where rn = 1

{% endmacro %}