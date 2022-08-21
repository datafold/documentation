---
description: Learn more about using Diff in your CI process
---

# Continuous Integration

Data Diff works best when being part of the [CI process](../../integrations/ci/). As with automated testing, this makes sure that you're in full control of the changes that you make to your data pipeline and you exactly know what the impact is of the changes that you make.

Let's consider [the following PR](https://github.com/datafold/dbt-beers/pull/11):

![](<../../.gitbook/assets/image (221).png>)

Let's say that you want to trim the input values that you're getting from an external source. [When opening the PR](https://github.com/datafold/dbt-beers/pull/11), Datafold will automatically look at the differences between the version that you've created, and the latest production run, and post the differences:

![](<../../.gitbook/assets/image (47).png>)

The compiled report gives a high-level overview of what changed in the table, and what changed in the  downstream dependencies:

* **Table rows –** total number of rows in each table
* Table columns - total number of columns in each table
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

![](<../../.gitbook/assets/image (226).png>)

And you can jump into the differences in the distributions of the columns:

![](<../../.gitbook/assets/image (181).png>)



In this case, we've added orders that we're marked as pending to the sales table. The reviewer of the PR can easily do the review by [checking Datafold](diff-results.md), and doesn't need to do compose queries for sanity checking:

![](<../../.gitbook/assets/image (155).png>)

At Datafold we believe that this process needs to be automated. If it isn't automated, a team under stress might do some shallow checks, which might cause bugs to sneak into the pipeline.
