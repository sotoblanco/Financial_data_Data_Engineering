with
    data_with_lag as (
        select *, lag(close) over (partition by instrument order by time) as prev_close
        from {{ ref("stg_ohlcv") }}
    ),
    gains_losses as (
        select
            *,
            case when close > prev_close then close - prev_close else 0 end as gain,
            case when close < prev_close then prev_close - close else 0 end as loss
        from data_with_lag
    ),
    avg_gains_losses as (
        select
            *,
            avg(gain) over (
                partition by instrument
                order by time
                rows between 13 preceding and current row
            ) as avg_gain,
            avg(loss) over (
                partition by instrument
                order by time
                rows between 13 preceding and current row
            ) as avg_loss
        from gains_losses
    )
select
    instrument, time, 100 - (100 / (1 + (avg_gain / nullif(avg_loss, 0)))) as rsi_14min
from avg_gains_losses
