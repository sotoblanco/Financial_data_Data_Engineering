{{ config(materialized='view') }}

select 
-- identifiers
    cast(time as timestamp) as time,
    instrument,
-- price
    cast(open as numeric) as open,
    cast(high as numeric) as high,
    cast(low as numeric) as low,
    cast(close as numeric) as close,
-- volume
    cast(volume as numeric) as volume

from {{ source('staging', 'ohlcv')}}

{% if var('is_test_run', default=true) %}
    limit 100

{% endif %}