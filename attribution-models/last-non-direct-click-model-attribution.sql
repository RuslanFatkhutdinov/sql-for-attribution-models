-- CTE with attribution weight calculating
-- for every transaction
WITH last_non_direct_click_table AS (
  SELECT
    -- User ID
    user_pseudo_id AS user_pseudo_id,
    -- Transaction ID
    transaction_id AS transaction_id,
    CASE
      -- If the source and channel of the session
      -- do not match '(none) / (direct)', leave it as it is
      WHEN session_source_medium != '(none) / (direct)' THEN session_source_medium
      -- If the user has more than one session,
      -- and the source and channel of the session with
      -- the transaction corresponds to '(none) / (direct)',
      -- check the source and channel of the previous sessions
      WHEN session_number > 1
      AND session_source_medium = '(none) / (direct)' THEN LAG (session_source_medium) OVER (
        ORDER BY
          user_pseudo_id
      )
      -- In other cases, put the source and channel '(none) / (direct)'
      ELSE '(none) / (direct)'
    END AS source_medium,
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
  SUM(attribution_weight) AS last_non_direct_clickclick
FROM
  last_non_direct_click_table
GROUP BY
  source_medium;