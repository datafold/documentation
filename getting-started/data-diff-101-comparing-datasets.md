# Data Diff

Datafold's **Diff** feature allows comparing datasets in a database or across databases. The datasets can be results of SQL queries or materialized tables. It's similar to running `git diff` on tables in your database.

{% embed url="https://youtu.be/gv8FKcVjHKw" %}

The following document describes the input parameters for running diffs as well as the different views for evaluating and investigating the differences.

## Data Diff in Continous Integration environment

Data Diff works best when being part of the CI process. As with automated testing, this makes sure that you're in full control of the changes that you make to your data pipeline and you exactly know what the impact is of the changes that you make.

Let's consider [the following PR](https://github.com/datafold/dbt-beers/pull/11):

![](<../.gitbook/assets/image (191).png>)

Let's say that you want to trim the input values that you're getting from an external source. [When opening the PR](https://github.com/datafold/dbt-beers/pull/11), Datafold will automatically look at the differences between the version that you've created, and the latest production run, and post the differences:

![](<../.gitbook/assets/image (94).png>)

The compiled report gives a high-level overview of what changed in the table, and what changed in the  downstream dependencies:

* **Table rows –** total number of rows in each table
* **Schema diff**
  * **Total columns –** total number of columns in each table
  * **Mismatched columns –**  number of columns that are exclusive to one table, have been reordered or changed their type.
* **Primary keys diff**
  * **Distinct PKs –** number of unique primary keys in each table
  * **Exclusive PKs –** number of primary keys that exist in one table but not in the other.
  * **Null PKs –** number of rows where primary key field is NULL
  * **Duplicate PKs –** number of rows with the same value in the primary key field
* **Values diff**
  * **Differing columns –** number of columns that have differences in values. Only matching columns (same name, same type) are compared.
  * **Total differing rows –** number of rows that have at least one column value different.
  * **Total differing values –** total number of different values across both rows and columns (cells) in the table.

For more details, you can easily jump into Datafold, here you can see a more detailed overview of the changes:

![](<../.gitbook/assets/image (260).png>)

And you can jump into the differences in the distributions of the columns:

![](<../.gitbook/assets/image (180).png>)



In this case, we've added orders that we're marked as pending to the sales table. The reviewer of the PR can easily do the review by checking Datafold, and doesn't need to do compose queries for sanity checking:

![](<../.gitbook/assets/image (8).png>)

At Datafold we believe that this process needs to be automated. If it isn't automated, a team under stress might do some shallow checks, which might cause bugs to sneak into the pipeline.

## Manual Data Diff

Next to running the Data Diff from the CI, it is also possible to run Data Diffs by hand. This is a powerful way to do one-off analysis between two tables, or queries. For example, instead of kicking off the CI process, you can easily change the existing query, and compare it against a table:

![](<../.gitbook/assets/image (75).png>)

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

## Diff results

#### Overview

The Overview tab shows a high-level report on the differences between the tables.

![](../.gitbook/assets/datadiff\_101\_overview.png)

### Schemas

Schemas tab highlights renamed, added, or removed columns:

![](../.gitbook/assets/datadiff\_101\_schemas.png)



### Primary Keys

Primary Keys tab shows samples of the data meeting the following conditions for primary keys:

1. Are there any PKs that exist in Table A but are missing from Table B and vice versa
2. Are there any duplicate PKs in either table?

![](../.gitbook/assets/datadiff\_101\_primary\_keys.png)

### Column Profiles

Datafold profiles every column for both tables and plots value distributions side-by-side. Using the profiles, you can identify the sources of the differences faster:

![](../.gitbook/assets/datadiff\_101\_column\_profiles.png)

### Values

Shows values side-by-side for every primary key. When values diverge, they are highlighted. You can select which columns are shown in what order by clicking on the gear menu on the left:

![](../.gitbook/assets/datadiff\_101\_values.png)

### Timeline

Plots the percentage of rows that are different between the two tables for every column. It can be helpful in identifying cases where the data is broken for particular partitions and for debugging time-based filters:

![](../.gitbook/assets/datadiff\_101\_timeline.png)

### Best practices

#### Working with large tables

Comparing tables is a computationally expensive task. Depending on your data engine, running diff on a large dataset may take a long time (or fail to execute to the insufficient resources).

![](<../.gitbook/assets/image (33).png>)

When working on large (> 100K rows) dataset, we recommend using sampling to get a quick estimate of the diff and gradually increase the sample size up to using the entire dataset as you are getting to the smaller differences. Good numbers to start with is a sampling tolerance of 0.00001 and sampling confidence of 99.9%.

In order to avoid redundant sampling, there are built-in thresholds for minimal table size for which sampling is applicable. The thresholds are different for different databases:&#x20;

* 1M rows for RedShift.
* 300K rows for PostgreSQL.
* 5M rows for any other database.

If a table is smaller than the threshold corresponding to the database, then sampling is disabled even if confidence and tolerance parameters are configured. You can always tell whether sampling was actually used or not by looking through diff reports.

Built-in thresholds can be overwritten or removed via the configuration parameter "Sampling threshold" on the manual diff and CI configuration pages.

![Sampling configuration on the manual diff page](<../.gitbook/assets/image (52).png>)

#### Sharing Diffs

You can easily share diffs with your teammates by copying the link to the diff.

![](../.gitbook/assets/datadiff\_best\_practicesl.png)

#### Diff result materialization

By default, the only way to view full diff results is by looking through UI. However, sometimes it's more convenient to have access to the raw data and explore results manually by writing custom queries against them. You can achieve this by enabling **Materialize diff results** option**.** If the option is enabled, then diff results will be persisted in your Data Warehouse as tables in the Datafold schema. This option can be set both on the manual diff page and the CI settings page.

Currently, the following parts of diff results are materialized:

* _Value diff_: The destination table can be found under the **Values** tab. The table will contain all rows with different values and equal primary keys. PK columns will be the same for table 1 and table 2, while all data columns will be prefixed with either `t1` or `t2`.
* _Duplicate primary keys_ for each table: The destination table can be found under the **Primary keys** tab. The table will contain all rows with duplicate primary keys together with data columns.
* _Exclusive primary keys_ for each table: The destination table can be found under the **Primary keys** tab. The table will contain all rows with exclusive primary keys together with data columns. Each column will be prefixed with either `t1` or `t2`.

By default, sampled diff results are materialized to avoid tables bloating. In order to materialize full diff results, enable **Materialize without sampling** option**.**
