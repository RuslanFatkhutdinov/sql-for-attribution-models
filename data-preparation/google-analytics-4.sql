-- Declaring a variable with the number of days
-- for which transactions are collected
DECLARE transactions_period INT64 DEFAULT 30;

-- Declaring a variable with the number of days of the attribution window
DECLARE attribution_window INT64 DEFAULT 30;

-- Table with transactions
WITH transactions AS (
  SELECT
    -- Transaction ID
    ecommerce.transaction_id AS transaction_id,
    -- Transaction timestamp
    MAX(event_timestamp) AS transaction_timestamp,
    -- User ID
    user_pseudo_id AS user_pseudo_id,
    -- Session ID
    event_params.value.int_value AS session_id
  FROM
    `vipavenue-6f9d1.analytics_267479041.events_*`
    CROSS JOIN UNNEST(event_params) AS event_params
  WHERE
    _TABLE_SUFFIX BETWEEN FORMAT_DATE(
      "%Y%m%d",
      DATE_SUB(CURRENT_DATE(), INTERVAL transactions_period DAY)
    )
    AND FORMAT_DATE(
      "%Y%m%d",
      DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
    )
    AND event_name = 'purchase'
    AND ecommerce.transaction_id IS NOT NULL
    AND event_params.key = 'ga_session_id'
  GROUP BY
    transaction_id,
    user_pseudo_id,
    session_id
),

-- Table with sessions
sessions AS (
  SELECT
    -- Session ID
    event_params.value.int_value AS session_id,
    -- Start session timestamp
    MAX(event_timestamp) AS session_start_timestamp,
    -- User ID
    user_pseudo_id AS user_pseudo_id,
    -- Session source and channel
    CONCAT(
      traffic_source.source,
      ' / ',
      traffic_source.medium
    ) AS session_source_medium
  FROM
    `vipavenue-6f9d1.analytics_267479041.events_*`
    CROSS JOIN UNNEST(event_params) AS event_params
  WHERE
    -- Make selection of sessions taking into account
    -- the transaction collection period plus the attribution window
    _TABLE_SUFFIX BETWEEN FORMAT_DATE(
      "%Y%m%d",
      DATE_SUB(
        CURRENT_DATE(),
        INTERVAL attribution_window + transactions_period DAY
      )
    )
    AND FORMAT_DATE(
      "%Y%m%d",
      DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
    )
    AND event_name = 'session_start'
    AND event_params.key = 'ga_session_id'
    -- Make selection of sessions from users who have made a transaction
    AND user_pseudo_id IN (
      SELECT
        DISTINCT user_pseudo_id
      FROM
        transactions
    )
  GROUP BY
    user_pseudo_id,
    session_source_medium,
    session_id
),

-- Joined table with sessions and transactions
sessions_with_transactions AS (
  SELECT
    st.*,
    tt.*
  EXCEPT
(session_id, user_pseudo_id),
  FROM
    sessions AS st
    LEFT JOIN transactions AS tt ON st.user_pseudo_id = tt.user_pseudo_id
    AND st.session_id = tt.session_id
),

-- Final table with additional data and filetring
combined_table AS (
  SELECT
    *,
    -- Count of sessions by users
    COUNT(1) OVER(PARTITION BY user_pseudo_id) AS total_sessions,
    -- Serial number of session
    RANK() OVER (
      PARTITION BY user_pseudo_id
      ORDER BY
        TIMESTAMP_MILLIS(session_start_timestamp) ASC
    ) AS session_number
  FROM
    sessions_with_transactions AS swt
  WHERE
    -- Removing the sessions that occurred after the transaction
    session_start_timestamp <= (
      SELECT
        MAX(transaction_timestamp)
      FROM
        sessions_with_transactions
      WHERE
        swt.user_pseudo_id = user_pseudo_id
    )
    -- Making a selection of sessions that fall into the attribution window
    AND TIMESTAMP_MICROS(session_start_timestamp) >= TIMESTAMP_ADD(
      TIMESTAMP_MICROS(
        (
          SELECT
            MAX(transaction_timestamp)
          FROM
            sessions_with_transactions
          WHERE
            swt.user_pseudo_id = user_pseudo_id
        )
      ),
      INTERVAL - attribution_window DAY
    )
  ORDER BY
    user_pseudo_id,
    session_id
)

-- Result
SELECT
  *
FROM
  combined_table