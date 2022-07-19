-- Declaring variable with target source and medium
DECLARE attribution_source_medium STRING DEFAULT 'google / cpc';

-- CTE with attribution weight calculating
-- for every transaction
WITH last_google_ads_table AS (
  SELECT
    -- User ID
    user_pseudo_id AS user_pseudo_id,
    -- Transaction ID
    transaction_id AS transaction_id,
    CASE
      -- If the source and channel of the transaction
      -- session correspond to the target source and channel,
      -- leave it as it is
      WHEN session_source_medium = attribution_source_medium THEN session_source_medium
      -- If the user has more than one session,
      -- and the source and channel of the session with
      -- the transaction do not corresponds to target source and medium,
      -- check the source and channel of the previous sessions
      WHEN session_number > 1
      AND session_source_medium != attribution_source_medium
      AND attribution_source_medium IN (
        SELECT
          DISTINCT session_source_medium
        FROM
          combined_table
        WHERE
          ct.user_pseudo_id = user_pseudo_id
      ) THEN attribution_source_medium
      -- In other cases, leave the source and channel as is
      ELSE session_source_medium
    END AS source_medium,
    -- Attribution weight
    1 AS attribution_weight
  FROM
    combined_table AS ct
  WHERE
    transaction_id IS NOT NULL
)

-- Final aggregation of all weights
SELECT
  source_medium AS source_medium,
  SUM(attribution_weight) AS last_google_ads_click
FROM
  last_google_ads_table
GROUP BY
  source_medium;