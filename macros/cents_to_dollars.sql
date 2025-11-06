{% macro cents_to_dollars(column_name, scale=2) %}
    ({{ column_name }} / 100)::decimal(16, {{ scale }})
{% endmacro %}

