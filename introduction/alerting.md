---
description: Introduction into alerting to detect unexpected changes in data before
---

# Alerting

With Datafold's alerts, it's easy to monitor the data flowing through your pipelines.&#x20;

On the alerts page, you will see an overview of the configured alerts that includes information such as when an alert was last triggered and when an alert last ran.

![Alerts overview page](<../.gitbook/assets/alerts_landing.png>)

Alerts are based on SQL queries, allowing for aggregations and groupings to facilitate tracking complex KPIs. In the example below, we track metrics like the daily median trip price for our taxi company.

![Example alert](<../.gitbook/assets/alerts_configuration.png>)

## Writing Queries

Queries should have **one temporal column** (e.g., hour, day, week, etc.), which can be in any order, and **one or more metric columns** (e.g., count of rows or sum of values). 

Queries should:

* Max 300 unique values per each category column.
* Max 1,000 unique combinations of all categorical values.
* Max 2,500 rows per dimension.
* Max 10,000 rows for all dimensions combined.
* Categorical columns must be strings; if they are not strings, convert them to strings using the syntax of your database (e.g. `column::text` or `cast(column as varchar)`).
* Ensure that the most recent time period has complete data; otherwise, it may be necessary to filter it out to avoid false-positive alerts.
* Queries with no temporal column and 1 row per dimension will implicitly use the current date and time in UTC. 


### Single-Dimension Query Example
Our demo beer company might write a single-dimension alert query as follows:

```sql
SELECT order_date,
COUNT(*) as total_orders
FROM integration.beers.orders_generated
GROUP BY order_date
```

### Multi-Dimensional Queries
In some cases, you may want to alert on a metric grouped by both time and categorical columns (e.g. average sale price per day by category). These can be created by including both the temporal and categorical columns in the query's `GROUP BY`. Each dimension is shown as a separate graph and has individual settings for anomalies/thresholds. New dimensions will be automatically created when the new data appear.

For more dimensions in our alert, we may write a multi-demensional query as follows:

```sql
WITH top_selling_breweries as (
    SELECT brewery_id,count(*) as total_orders
    FROM integration.beers.orders_generated
    WHERE bitterness is not null
    GROUP BY brewery_id
    ORDER BY total_orders desc 
    LIMIT 3 --top 3 selling breweries
)

SELECT
order_date
,brewery_name
,bitterness
,COUNT(*) as total_beers_ordered
FROM integration.beers.orders_generated
WHERE
brewery_id in (select brewery_id FROM top_selling_breweries)
and bitterness is not null
and brewery_name in ('Hopworks Urban Brewery','Great River Brewery')
GROUP BY order_date
        ,brewery_name
        ,bitterness
```

## Creating Alerts

Once a query is run, each metric column will be graphed against the specified time series. From this view, you can specify alert thresholds using one or more of the following:

* **Min/Max values.** A simple, yet effective way of detecting that something is wrong. For example, set a min value if you want to be alerted every time your metric goes below that amount.
* **Max increase/decrease.** Applies to a % change in the metric value from the previous period (e.g. day-over-day). For example, if you track a median or average of a value, and you don't expect rapid changes.&#x20;
* **Anomaly detection.** Datafold comes with anomaly detection that takes into account seasonality and trend in your data and will construct a confidence interval (pale blue in the picture). You can even control the sensitivity of the model to generate more or fewer alerts.

![Historical trend of metric](<../.gitbook/assets/alerts_anomaly_detection.png>)

### Subscribing to Alerts

Once triggered, an alert can be sent to a Slack channel or Email (custom integrations e.g. PagerDuty, OpsGenie, arbitrary webhooks/callbacks are available on request). When configuring the integrations, it is always a good idea to test them and ensure that the alerts can be delivered successfully.

![](<../.gitbook/assets/alerts_slack.png>)

[Learn more about configuring Slack for alerts ->](../integrations/alert-integrations/slack-integration/README.md)
