-- CTE with attribution weight calculating
-- for every transaction
WITH u_shape_table AS (
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
    -- Share equally the contribution between
    -- sources and channels of previous user sessions
    (
      CASE
        -- If the user has only 1 session, the contribution
        -- from the source and channel of this session is 1
        WHEN total_sessions = 1 THEN 1
         -- If the user has 2 sessions, then the contribution
         -- at the source and the channel of each session is 0.5
        WHEN total_sessions = 2 THEN 0.5
         -- If the user has more than 2 sessions, the source and
         -- channel of the first and last sessions receive 0.4 points,
         -- and 0.2 points are distributed between the sources and
         -- channels of the remaining sessions
        WHEN total_sessions > 2 THEN (
          CASE
            WHEN session_number = 1 THEN 0.4
            WHEN session_number = total_sessions THEN 0.4
            ELSE 0.2 / (total_sessions - 2)
          END
        )
      END
    ) AS attribution_weight
  FROM
    combined_table AS ct
)

-- Final aggregation of all weights
SELECT
  source_medium AS source_medium,
  CAST(ROUND(SUM(attribution_weight), 0) AS INTEGER) AS u_shape_click
FROM
  u_shape_table
GROUP BY
  source_medium;