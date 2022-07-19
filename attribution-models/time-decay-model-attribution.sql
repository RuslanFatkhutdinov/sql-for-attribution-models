-- CTE with attribution weight calculating
-- for every transaction
WITH time_decay_table AS (
  SELECT
    -- User ID
    user_pseudo_id AS user_pseudo_id,
    -- Source and medium of every session
    session_source_medium AS source_medium,
    -- Users transaction ID for sessions without transaction
    LAST_VALUE(transaction_id) OVER (
      PARTITION BY user_pseudo_id
      ORDER BY
        transaction_timestamp ASC ROWS BETWEEN CURRENT ROW
        AND UNBOUNDED FOLLOWING
    ) AS transaction,
    -- Calculating the weight for each source and channel
    (
      CASE
        -- If the user has only 1 session, the contribution
        -- from the source and channel of this session is 1
        WHEN total_sessions = 1 THEN 1
        -- In other cases , the contribution of sources
        -- and channels is distributed according to the formula
        ELSE SAFE_DIVIDE(
          POWER(2, session_number / total_sessions),
          (
            SUM(POWER(2, session_number / total_sessions)) OVER(PARTITION BY user_pseudo_id)
          )
        )
      END
    ) AS attribution_weight
  FROM
    combined_table
)

-- Final aggregation of all weights
SELECT
  source_medium AS source_medium,
  CAST(ROUND(SUM(attribution_weight), 0) AS INTEGER) AS time_decay_click
FROM
  time_decay_table
GROUP BY
  source_medium;