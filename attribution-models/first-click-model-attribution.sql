-- CTE with attribution weight calculating
-- for every transaction
WITH first_click_table AS (
  SELECT
    -- User ID
    user_pseudo_id AS user_pseudo_id,
    -- Transaction ID
    transaction_id AS transaction_id,
    -- Source and medium of first users session
    FIRST_VALUE(session_source_medium) OVER (
      PARTITION BY user_pseudo_id
      ORDER BY
        session_start_timestamp
    ) AS source_medium,
    -- Attribution weight
    1 AS attribution_weight
  FROM
    combined_table
  WHERE
    transaction_id IS NOT NULL
)

-- Final aggregation of all weights
SELECT
  source_medium AS source_medium,
  SUM(attribution_weight) AS first_click
FROM
  first_click_table
GROUP BY
  source_medium;