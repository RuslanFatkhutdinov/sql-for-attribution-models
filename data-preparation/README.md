# Data preparation

## Table with transactions
Must contain:
- ID of the completed transaction
- Date and time of the transaction
- ID of the user who made the transaction
- ID of the session during which the transaction was made

It is necessary to determine the time for which transactions are collected.

## Table with sessions
Must contain:
- Session ID
- Session start date and time
- User ID
- The source and channel from which the user session started

It is necessary to determine the size of the attribution window, since when collecting this table, it is important that sessions be taken for a period equal to the sum of the transaction collection period and the attribution window. That is, if we consider the attribution model for transactions for the last 30 days, and have defined an attribution window of 90 days, then sessions should be taken for 120 days. This is done to properly account for all touch points made during the attribution window.

## Join tables
1. Attribution calculation involves parallel interaction with session and transaction data, so tables with transactions and sessions can be combined into one.
2. In order not to waste resources on processing unnecessary data, it is better to leave sessions in the final table only from those users who eventually made the transaction. And also leave only the sessions preceding the transaction or during which the transaction was made
3. Some attribution models require information about how many sessions the user made before the transaction, and which session was with the transaction, so we will add the corresponding columns to the final table.