WITH sma_data AS (
    SELECT instrument,
           time,
           sma_5min
    FROM {{ ref('sma_5min') }}
),
rsi_data AS (
    SELECT instrument,
           time,
           rsi_14min
    FROM {{ ref('rsi_14min') }}
)
SELECT s.instrument,
       s.time,
       s.open,
       s.high,
       s.low,
       s.close,
       s.volume,
       sma.sma_5min,
       rsi.rsi_14min
FROM {{ ref('stg_ohlcv') }} AS s
LEFT JOIN sma_data AS sma
  ON s.instrument = sma.instrument AND s.time = sma.time
LEFT JOIN rsi_data AS rsi
  ON s.instrument = rsi.instrument AND s.time = rsi.time
