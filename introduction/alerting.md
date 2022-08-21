---
description: Introduction into alerting to detect unexpected changes in data before
---

# Alerting

With Datafold's alerts, it's easy to monitor the data flowing through your pipelines.&#x20;

On the alerts page, you will see an overview of the configured alerts that includes information such as when an alert was last triggered and when an alert last ran.

![Alerts overview page](<../.gitbook/assets/image (59).png>)

Alerts are based on SQL queries, allowing for aggregations and groupings to facilitate tracking complex KPIs. In the example below, we track metrics like average basket size and average price per day for our [dbt-beers project](https://github.com/datafold/dbt-beers).

![Example alert](<../.gitbook/assets/image (249).png>)

#### Writing Queries

Queries should have **one temporal column** (e.g., hour, day, week, etc.), which can be in any order, and **one or more metric columns** (e.g., count of rows or sum of values). As a best practice:

* Limit the query results to 300 data points (for best performance).
* Make sure your query doesn't contain NULLs.
* Ensure that the most recent time period has complete data; otherwise, it may be necessary to filter it out to avoid false-positive alerts.
* `GROUP BY` your temporal column.

Queries with no temporal column and 1 row per dimension will implicitly use the current date and time in UTC. Using two or more rows in any dimension will cause an error. Datafold will build the history inside of Datafold (see screenshot).

![Example: Alert for non time series data.](<../.gitbook/assets/image (3).png>)

#### Creating Alerts

Once a query is run, each metric column will be graphed against the specified time series. From this view, you can specify alert thresholds using one or more of the following:

* **Min/Max values.** A simple, yet effective way of detecting that something is wrong. For example, set a min value if you want to be alerted every time your metric goes below that amount.
* **Max increase/decrease.** Applies to a % change in the metric value from the previous period (e.g. day-over-day). For example, if you track a median or average of a value, and you don't expect rapid changes.&#x20;
* **Anomaly detection.** Datafold comes with anomaly detection that takes into account seasonality and trend in your data and will construct a confidence interval (pale blue in the picture). You can even control the sensitivity of the model to generate more or fewer alerts.

![Historical trend of metric](<../.gitbook/assets/image (6).png>)

#### Multi-dimensional Alerts

In some cases, you may want to alert on a metric grouped by both time and categorical columns (e.g. average sale price per day by category). These can be created by including both the temporal and categorical columns in the query's `GROUP BY`. Each dimension is shown as a separate graph and has individual settings for anomalies/thresholds. New dimensions will be automatically created when the new data appear.

Some limitations apply:

* Max 300 unique values per each category column.
* Max 1,000 unique combinations of all categorical values.
* Max 2,500 rows per dimension.
* Max 10,000 rows for all dimensions combined.
* Either several metrics or several dimensions can be used, not both (if you need multiple metrics in multiple dimensions, please contact us).
* Categorical columns must be strings; if they are not strings, convert them to strings using the syntax of your database (e.g. `column::text` or `cast(column as varchar)`).

#### Subscribing to Alerts

Once triggered, an alert can be sent to a Slack channel or Email (custom integrations e.g. PagerDuty, OpsGenie, arbitrary webhooks/callbacks are available on request). When configuring the integrations, it is always a good idea to test them and ensure that the alerts can be delivered successfully.

![](<../.gitbook/assets/image (153).png>)
