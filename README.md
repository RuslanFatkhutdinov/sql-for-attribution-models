# SQL queries for Google Analytics attribution models
Building attribution marketing models based on raw Google Analytics 4 data or raw Google Analytics Universal data with the Analytics 360 structure on example [OWOX](https://www.owox.com/).

## Idea
The attribution model is an assessment of the contribution of each of the contact points involved in the path to a perfect conversion.

A large number of conversions are not made from the first visit to the site, some users need to make several contacts, through different points and in different ways before performing a conversion action

When deciding on the effectiveness of a point of contact, it is important to correctly assess the contribution of the point in terms of different attribution models. Without such an assessment, there is a risk of abandoning a good tool by misjudging it.

Google Analytics allows you to immediately evaluate the effectiveness of the touch point in the reporting interface. But if you work with raw data (no matter for what reason), you need to calculate the attribution model yourself.

Google Analytics 4 has a free raw data [BigQuery export](https://support.google.com/analytics/answer/9358801) feature that provides the data as is. Different attribution models help to correctly evaluate different channels of attracting users to the site.

## Technologies
The repository contains SQL queries. The correctness of the queries was checked in the Google BigQuery web interface.

## Project stucture
1. Folder `data-preparation` contains SQL queries for basic data preparation from different types of counters:
    - `google-analytics-4-data-preparation.sql` contains query for preparation data from Google Analytics 4
    - `google-universal-analytics-owox-data-preparation.sql` contains query for preparation data from Google Analytics Universal OWOX Exrport
    - `README.md` contains description of queries and steps of data preparations
2. Folder `attribution-models` contains queries for calculation different types of marketing model attribution:
    - `first-click-model-attribution.sql`
    - `last-click-model-attribution.sql`
    - `last-google-ads-click-model-attribution.sql`
    - `last-non-direct-click-model-attribution.sql`
    - `linear-model-attribution.sql`
    - `time-decay-model-attribution.sql`
    - `u-shape-model-attribution.sql`
    - `README.md` contains description of queries and steps of calculations

## Linked articles

## Contacts
- **author**: Fatkhutdinov Ruslan
- **email**: workrf@gmail.com
- **tg**: [@ruslan_fd](t.me/ruslan_fd)
- **linkedin**: [fathutdinov](https://www.linkedin.com/in/fathutdinov/)