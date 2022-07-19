# Marketing Attribution models

## Last Interaction attribution
The model of the last interaction is a single—channel attribution model that assigns 100% of the contribution to the point from which the session began, during which the conversion was made.

It is used to evaluate conversion sources for products with a short sales cycle.

Does not take into account the history of user interaction with the business, which can lead to the formation of erroneous conclusions.

To calculate, it is enough to output the source and channel from which the session started, during which the transaction was made.

## First Interaction attribution
The first interaction model is a single—channel attribution model that assigns 100% of the contribution to the point from which the user's first session began in the designated attribution window.

It is used to evaluate the sources that introduced the user to the company. It can be used to evaluate the effectiveness of display advertising.

Does not take into account the subsequent history of the client's interaction with the company.

To calculate the model, it is necessary to output the source and channel of the first session of the user who made the transaction.

## Last Non-Direct Click attribution
The last significant transition model is a single—channel attribution model that assigns 100% of the contribution to the last point, provided that it was a significant source. If the conversion was made when entering from an insignificant source, 100% of the contribution will be assigned to the previous source in the specified attribution window. If there is no other source, the contribution is given to an insignificant source.

Like the “Last Click” model, it is used to evaluate conversion sources for products with a short sales cycle. But it is considered more accurate, since it takes into account only significant sources

To calculate the model, you need to check:
-  If the source and channel from which the session started during which the transaction was made is not insignificant’, leave the source and channel from which this session started as is.
- If the session during which the transaction was made is not the user's first, while the source and channel are insignificant, check the source and channel of the previous session and substitute it if it is not insignificant.
- In all other cases, substitute the source and channel '(none) / (direct)'.

## Last Google Ads click attribution
The model of the last transition from a certain channel is a single—channel model, which assigns 100% of the value to the last transition from a certain source and channel.

This model is used to evaluate the effectiveness of certain sources, without taking into account the influence of other sources.

To calculate the model:
- Check that the source and channel from which the session started, during which the transaction was made, is the target source and channel. If so, frame him.
- Check that the user who made the transaction, the source and channel of the previous session is the target and substitute it.
- In other cases, leave the source and channel as is.

## Limear attribution
The linear model is a multi—channel attribution model that distributes the contribution in equal shares between all points of interaction in the attribution window until the conversion is completed.

It is used to evaluate the effectiveness of each interaction point.

To calculate the model, it is necessary to determine the number and list of sources and channels through which the user started sessions on the site, including the session during which the transaction was made, and divide the contribution in equal shares between all sources and channels.

## Time Decay attribution
The interaction prescription model is a multi—channel attribution model that distributes value between all sources and channels of interaction in the attribution window until the conversion is completed, taking into account the prescription. The closer to the conversion, the more value the source and channel get.

It is used to evaluate each point of contact as it approaches the conversion.

The conditions are used to calculate the model:
- If there was 1 session, 100% of the value is given to the source and channel from which this session started.
- If there is more than one session, the time decay formula is used: 2 ^ (Session number / Number of sessions). The results obtained are reduced to 100%.

## Position Based (U-shape) attribution
The U-model is a multi—channel attribution model that assigns 40% of the contribution to the source and channel of the first and last session, and distributes the remaining 20% of the contribution evenly between the sources and channels that were in the middle.

It is used to evaluate dating points and make conversions.

To calculate the model:
- If there was 1 session, 100% of the value is given to the source and channel from which this session started.
- If there were 2 sessions, each of the sources and channels of the sessions is assigned 50% of the contribution.
- If there are more than 2 sessions, 40% of the contribution is assigned to the sources and channels of the first and last session, and the remaining 20% of the contribution is distributed between the sources and channels between the first and last sessions.