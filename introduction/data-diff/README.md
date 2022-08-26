---
description: Learn more about Data Diff
---

# Data Diff

Datafold's **Diff** feature allows comparing datasets in a database or across databases. The datasets can be results of SQL queries or materialized tables. It's similar to running `git diff` on tables in your database.

{% embed url="https://youtu.be/gv8FKcVjHKw" %}

The following document describes the input parameters for running diffs as well as the different views for evaluating and investigating the differences.

### Best practices

#### Working with large tables

Comparing tables is a computationally expensive task. Depending on your data engine, running diff on a large dataset may take a long time (or fail to execute to the insufficient resources).

![](<../../.gitbook/assets/image (133).png>)

When working on large (> 100K rows) dataset, we recommend using sampling to get a quick estimate of the diff and gradually increase the sample size up to using the entire dataset as you are getting to the smaller differences. Good numbers to start with is a sampling tolerance of 0.00001 and sampling confidence of 99.9%.

In order to avoid redundant sampling, there are built-in thresholds for minimal table size for which sampling is applicable. The thresholds are different for different databases:&#x20;

* 1M rows for RedShift.
* 300K rows for PostgreSQL.
* 5M rows for any other database.

If a table is smaller than the threshold corresponding to the database, then sampling is disabled even if confidence and tolerance parameters are configured. You can always tell whether sampling was actually used or not by looking through diff reports.

Built-in thresholds can be overwritten or removed via the configuration parameter "Sampling threshold" on the manual diff and CI configuration pages.

![Sampling configuration on the manual diff page](<../../.gitbook/assets/image (97).png>)

{% hint style="success" %}
[Get started with Data Diff ->](broken-reference)
{% endhint %}

### Diff result materialization

By default, the only way to view full diff results is by looking through UI. However, sometimes it's more convenient to have access to the raw data and explore results manually by writing custom queries against them. You can achieve this by enabling **Materialize diff results** option**.** If the option is enabled, then diff results will be persisted in your Data Warehouse as tables in the Datafold schema. This option can be set both on the manual diff page and the CI settings page.

Currently, the following parts of diff results are materialized:

* _Value diff_: The destination table can be found under the **Values** tab. The table will contain all rows with different values and equal primary keys. PK columns will be the same for table 1 and table 2, while all data columns will be prefixed with either `t1` or `t2`.
* _Duplicate primary keys_ for each table: The destination table can be found under the **Primary keys** tab. The table will contain all rows with duplicate primary keys together with data columns.
* _Exclusive primary keys_ for each table: The destination table can be found under the **Primary keys** tab. The table will contain all rows with exclusive primary keys together with data columns. Each column will be prefixed with either `t1` or `t2`.

By default, sampled diff results are materialized to avoid tables bloating. In order to materialize full diff results, enable **Materialize without sampling** option**.**
