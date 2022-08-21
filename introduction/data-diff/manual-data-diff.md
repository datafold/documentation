---
description: Learn more about using Diff in the Datafold UI
---

# Manual Data Diff

Next to running the Data Diff from the CI, it is also possible to run Data Diffs manually. This is a powerful way to do one-off analysis between two tables, or queries. For example, instead of kicking off the CI process, you can easily change the existing query, and compare it against a table:

![](<../../.gitbook/assets/image (139).png>)

In order to diff (compare) tables or queries, you need to specify a few parameters:

**Connection**

The name of the database connection that contains tables of interest

**Dataset A & Dataset B**

The datasets can be results of SQL queries or materialized tables.

* **Table:** the names of a table. It's best to use a full path including database/project and schema/dataset.
* **Query:** SQL query that produces the output to be compared.

Note that all columns in the SQL query should be named:

* ✅  `SELECT taxi_id`
* ✅  `SELECT taxi_id + 1 AS taxi_id`
* ❌  `SELECT taxi_id + 1`&#x20;

We support time-travel to run the diffs against specific versions of the table. This can be helpful when a table is constantly changing, or not up to date. There is support for:

* [Snowflake:](https://docs.snowflake.com/en/sql-reference/constructs/at-before.html#syntax)
  * Relative using a negative integer (ex. -220) for an offset in seconds.
  * At a certain point in time using a timestamp (ex. 2021-08-13T00:00:00)
  * At a certain statement using the query id.
* [BigQuery:](https://cloud.google.com/bigquery/docs/time-travel)
  * At a certain point in time using a timestamp (ex. 2021-08-13T00:00:00)

**Primary Keys**

A column that uniquely identifies the rows in the tables. If the primary key is composite (more than one column), provide a comma-delimited list of column names.

**Optional: Time Dimension**

If a table has a time column, you can provide it here so that the diff will be plotted along the time axis. This is helpful for debugging differences that are correlated with time.

#### **Optional: Filters**

In case you only need to consider a subset of data from either table, you can provide a SQL filter expression (that would normally go after `WHERE` keyword) to filter out unwanted rows. For example:

```
city = 'New York' AND logged_at < '2020-01-05'
```

#### Optional: Sampling

Sampling can dramatically speed up the diffing process and reduce the computational cost by only comparing a random sample of rows.

**Optional: Randomization method**

Data is sampled based on the primary key specified by the user. Datafold creates a representative sample of primary keys that exist in both tables to correctly assess the difference in values.

**Optional: Sample Size**

There are two parameters that determine the sample size (calculated based on the Poisson distribution):

* **Diff Tolerance** The fraction of the rows in the target dataset that you are OK with being different. We recommend starting with a higher tolerance and then decreasing it once you are getting to smaller difference.
*   **Confidence** The desired confidence level in the diff estimate. Intuitively, if we make an estimate at 99% confidence level, we should be correct in 99 out of 100 diff runs.

    Say, you pick diff tolerance of 0.1% and confidence of 99% and Datafold determines that datasets are identical (0 different rows).

    In the context of sampling, it means that we are 99% confident that tables A & B have no more than 0.1% different rows. Or, in other words, there is less than 1% chance that more than 0.1% of rows are different between the datasets.
