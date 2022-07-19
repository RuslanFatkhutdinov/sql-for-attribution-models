-- CTE with attribution weight calculating
-- for every transaction
WITH linear_table AS (
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
    1 / (
      SELECT
        MAX(session_number)
      FROM
        combined_table
      WHERE
        transaction_id IS NOT NULL
        AND ct.user_pseudo_id = user_pseudo_id
    ) AS attribution_weight
  FROM
    combined_table AS ct
)

 -- Final aggregation of all weights
SELECT
  source_medium AS source_medium,
  CAST(ROUND(SUM(attribution_weight), 0) AS INTEGER) AS linear_model
FROM
  linear_table
GROUP BY
  source_medium;