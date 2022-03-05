{%- macro cast_column_to_timestamp(timestamp_field) -%}
    cast({{ timestamp_field }} as {{ dbt_utils.type_timestamp() }})
{%- endmacro -%}

{%- macro null_to_string() -%}
    cast(null as {{ dbt_utils.type_string() }})
{%- endmacro -%}