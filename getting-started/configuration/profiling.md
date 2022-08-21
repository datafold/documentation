---
description: Best practices when it comes to profiling
---

# Profiling

Profiling is the process of gathering statistics on the columns. This can be challenging when working with big datasets. This page will go through the options to optimize this process.

This guide will give you full control over when profiles are being computed:

* **On-demand** this is by default, introducing some latency when seeing the profiles, but you know that they are up to date.
* **Scheduled** this will make sure that the profiles are computed at a convenient time (for example, off-business hours), but it can be that the profile is slightly outdated.

Below we can see that the profile has been updated since `2021-06-19 08:46:15 UTC`. By default, the profile is being computed when you visit the table:

![Example profiling](<../../.gitbook/assets/image (114).png>)

It is highly recommended to set the computation of statistics on a schedule. This will make sure that the profiles are computed outside of business hours, and that the statistics are cached in Datafold, resulting in a snappy experience by having the statistics without any delay. We can configure this on a fine-grained level in the data source configuration page:

![Configuration](<../../.gitbook/assets/image (288).png>)

* **Indexing** is the process of looking up the metadata. This doesn't run queries against the cluster, but only looks up the table names and their corresponding columns.
* **Profiling** is the actual heavy lifting. This kicks off several jobs to compute statistics on table and column level. Depending on the type it will compute the sparsity and histograms per column.

We recommend setting a crontab schedule outside of business hours, preferably on the weekend, to avoid interference with queries that are running during business hours.

After checking the **Discourage manual profile refresh** in the data source configuration. There will be a pop up when manually refreshing the profile:

![](<../../.gitbook/assets/image (243).png>)

Hope this helps when fine-tuning the profiles in Datafold. If there are any questions, please don't hesitate to reach out.
