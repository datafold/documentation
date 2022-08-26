---
description: Get familiar with how Data Diff results appear in the Datafold UI
---

# Diff Results

The Datafold UI allows for manual checks on the differences between two tables. We'll review what information is available in the Datafold platform and how you can use this to better inform your data changes.&#x20;

### Overview

The Overview tab shows a high-level report on the differences between the tables.

![](../../.gitbook/assets/datadiff\_101\_overview.png)

### Schemas

The schemas tab highlights renamed, added, or removed columns:

![](../../.gitbook/assets/datadiff\_101\_schemas.png)

### Primary Keys

Primary Keys tab shows samples of the data meeting the following conditions for primary keys:

1. Are there any PKs that exist in Table A but are missing from Table B and vice versa
2. Are there any duplicate PKs in either table?

![](../../.gitbook/assets/datadiff\_101\_primary\_keys.png)

### Column Profiles

Datafold profiles every column for both tables and plots value distributions side-by-side. Using the profiles, you can identify the sources of the differences faster:

![](../../.gitbook/assets/datadiff\_101\_column\_profiles.png)

### Values

Shows values side-by-side for every primary key. When values diverge, they are highlighted. You can select which columns are shown in what order by clicking on the gear menu on the left:

![](../../.gitbook/assets/datadiff\_101\_values.png)

### Timelines

Plots the percentage of rows that are different between the two tables for every column. It can be helpful in identifying cases where the data is broken for particular partitions and for debugging time-based filters:

![](../../.gitbook/assets/datadiff\_101\_timeline.png)
