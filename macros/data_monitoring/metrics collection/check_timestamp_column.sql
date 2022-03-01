{% macro check_timestamp_column(full_table_name, timestamp_column) %}

    {%- set query %}
        select {{ dbt_utils.safe_cast(timestamp_column, dbt_utils.type_timestamp()) }} as timestamp_column
        from {{ full_table_name }}
        where {{ timestamp_column }} is not null
        limit 1
    {%- endset %}

    {%- set result = elementary.result_value(query) %}
    {%- if result %}
        {%- set to_timestamp = true %}
    {%- else %}
        {%- set to_timestamp = false %}
    {%- endif %}

    {{ return(to_timestamp) }}

{% endmacro %}