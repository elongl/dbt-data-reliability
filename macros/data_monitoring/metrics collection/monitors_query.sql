{% macro monitors_query(thread_number) %}
    -- depends_on: {{ ref('edr_tables_config') }}
    -- depends_on: {{ ref('edr_columns_config') }}

    {%- set monitored_tables = run_query(monitored_tables('1,2,3,4')) %}
    {%- if execute %}
        {%- set table_config_column_names = monitored_tables.column_names %}
    {%- endif %}

    {%- for monitored_table in monitored_tables %}
        {%- set full_table_name = monitored_table[table_config_column_names[1]] %}
        {%- set database_name = monitored_table[table_config_column_names[2]] %}
        {%- set schema_name = monitored_table[table_config_column_names[3]] %}
        {%- set table_name = monitored_table[table_config_column_names[4]] %}
        {%- set timestamp_column = monitored_table[table_config_column_names[5]] %}
        {%- set bucket_duration_hours = monitored_table[table_config_column_names[6]] | int %}
        {%- set table_monitored = monitored_table[table_config_column_names[7]] %}
        {%- set columns_monitored = monitored_table[table_config_column_names[9]] %}
        {%- set table_should_backfill = monitored_table[table_config_column_names[10]] %}

        {%- if table_monitored is sameas true %}
            {%- if monitored_table[table_config_column_names[8]] is not none %}
                {%- set config_column_monitors = fromjson(monitored_table[table_config_column_names[8]]) %}
            {%- endif %}
            {%- set table_monitors = get_table_monitors(config_table_monitors) %}
        {%- endif %}

        {%- if columns_monitored is sameas true %}
            {%- set column_monitors_config = get_columns_monitors_config(full_table_name) %}
        {%- endif %}

        {%- if table_should_backfill %}
            {%- set should_backfill = true %}
        {%- elif column_monitors_config is defined %}
            {%- set should_backfill_columns = [] %}
            {%- for i in column_monitors_config %}
                {{ should_backfill_columns.append(i['should_backfill']) }}
            {%- endfor %}
            {%- set should_backfill = should_backfill_columns[0] %}
        {%- else %}
            {%- set should_backfill = false %}
        {%- endif %}

        {{ table_monitors_query(full_table_name, timestamp_column, var('days_back'), bucket_duration_hours, table_monitors, column_monitors_config, should_backfill) }}
        {%- if not loop.last %} union all {%- endif %}

    {%- endfor %}

{% endmacro %}
