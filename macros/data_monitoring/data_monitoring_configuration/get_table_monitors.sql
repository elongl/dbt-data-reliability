{% macro get_table_monitors(config_monitors) %}

    {%- set all_table_monitors = var('edr_monitors')['table'] | list %}
    {%- do all_table_monitors.remove('schema_changes') %}

    {%- if config_monitors is defined and config_monitors|length %}
        {%- set monitors_list = elementary.lists_intersection(config_monitors, all_table_monitors) %}
    {%- else %}
        {%- set monitors_list = all_table_monitors %}
    {%- endif %}

    {{ return(monitors_list) }}

{% endmacro %}