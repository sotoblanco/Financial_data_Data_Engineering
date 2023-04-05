with
    data_with_sequence as (
        select *, row_number() over (partition by instrument order by time) as row_num
        from {{ ref("stg_ohlcv") }}
    )
select
    instrument,
    time,
    avg(close) over (
        partition by instrument
        order by row_num
        rows between 4 preceding and current row
    ) as sma_5min
from data_with_sequence
