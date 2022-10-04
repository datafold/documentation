# Usage, popularity, & impact per table or column

A large enough Data Warehouse quickly accumulates a great number of tables; not all of these tables are often, or ever, used.

Can we separate popular tables from the rest, to understand their impact on the business?

### Table level query count & popularity

Here is a lineage graph view for a fragment of [datafold/dbt-beers](https://github.com/datafold/dbt-beers) repository. Notice the **Queries** and the **Popularity** fields on every table block.

<figure><img src="../../.gitbook/assets/image (17).png" alt=""><figcaption><p>A sample graph with statistics</p></figcaption></figure>

**Queries** field shows the number of SQL queries affecting the table (both for reading and for writing) over last 7 days. This number is updated daily. On this picture, the statistics ranges from humble 21 to the whopping 3.16K queries.

Such granularity is not always informative; oftentimes, we only want to see how different tables relate to each other in terms of usage statistics. That's what **Popularity** indicator is for. Here's the scale for its values:

| Popularity                                                                    | Meaning                                            |
| ----------------------------------------------------------------------------- | -------------------------------------------------- |
| <mark style="color:green;">▮ ▮ ▮ ▮</mark> <mark style="color:green;">▮</mark> | Top 2%                                             |
| <mark style="color:green;">▮ ▮ ▮</mark> <mark style="color:green;">▮</mark> ▮ | Top 7% _(except top 2%)_                           |
| <mark style="color:green;">▮ ▮</mark> <mark style="color:green;">▮</mark> ▮ ▮ | Top 15% _(except top 7%)_                          |
| <mark style="color:green;">▮</mark> <mark style="color:green;">▮</mark> ▮ ▮ ▮ | Top 25% _(except top 15%)_                         |
| <mark style="color:green;">▮</mark> ▮ ▮ ▮ ▮                                   | All the remaining objects with at least one access |
| ▮ ▮ ▮ ▮ ▮                                                                     | Objects with no registered accesses at all         |

We can see that `ORDER_LINES` table is within top 7% tables in the warehouse by popularity, and `PROMO_DELIVERIES` is within top 15%.

### Filter tables by popularity

There might be tables in a data warehouse which have dozens and even hundreds of downstreams, making the lineage graph hard to navigate. Luckily, in many cases, most of these tables aren't very often used, and thus we can safely ignore them for most purposes.

Here, by configuring maximum and minimum popularity in the **Filters** panel, we exclude the `PROMO_DELIVERIES` table — which is the least popular kid on the block.

<figure><img src="../../.gitbook/assets/image (13).png" alt=""><figcaption></figcaption></figure>

### Down to the column level

Query counts and popularity scales are also available for individual **columns**. Expand the column list of a table and hover over the :information\_source:️ icon. This helps identify columns in tables which might be obsolete and unused.

<figure><img src="../../.gitbook/assets/image (19).png" alt=""><figcaption><p>Not too many queries but still this is rather popular in comparison to the other columns in the Data Warehouse.</p></figcaption></figure>

{% hint style="info" %}
**Popularity** filter does not apply to individual columns, it only can exclude a table as a whole.
{% endhint %}

{% hint style="info" %}
For a table, <mark style="color:green;">▮ ▮ ▮</mark> <mark style="color:green;">▮</mark> ▮ means the table is in top 15% tables in the Data Warehouse; for a column, it means it's one of the top 15% columns. Popularity scales for tables and columns are independent from each other.
{% endhint %}

### Statistics per direction and per user

As mentioned above, the query count in the lineage graph is a sum of read operations (`SELECT`) and write operations (`CREATE`, `INSERT INTO`, …).

* What if we want to know exactly how many writes and reads had happened?
* What if we want to see which database users have performed those operations?

We can do that!

Both tables and columns have context menu with a **Usage details** item in it.

<figure><img src="../../.gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

By clicking it, we reveal the following:

<figure><img src="../../.gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

The **total** number in this table (444) equals the query count on the graph.

* It's clear that `DATAFOLD_DEMO` user doesn't write to the table, it just reads sometimes;
* `INTEGRATION` user both writes and reads the table but it reads much more often than writes.

### Cumulative Read

A table or column might be important not because it is popular itself but because its downstreams are popular. For instance, a table with list of US states might not be often queried but the data it provides are copied to many other tables along the ELT pipeline.

We reflect that fact with the metric named **Cumulative Read**. For instance, on the screenshot above `BEERS_WITH_BREWERIES` has Cumulative Read = 3480. What does it mean, exactly?

{% hint style="info" %}
**Cumulative Read** counter on a database object is the sum of all read operations for the database object itself and **for all of its downstreams**.
{% endhint %}

`BEERS_WITH_BREWERIES` has only one downstream table: `SALES`.

<figure><img src="../../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

Note that:

* `SALES` has no downstreams, which explains that its Total Read = Cumulative Read,
* and both equal 4939, which is even greater than the Cumulative Read of its upstream table = 3480.

How is that possible? That's because Cumulative Read is calculated **on column level**. Let's take a closer look at the relationship between these two tables.

<figure><img src="../../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

Not every column of `SALES` is really a downstream for `BEERS_WITH_BREWERIES`. Let's calculate the Cumulative Read value for `BEERS_WITH_BREWERIES`:

* In Usage Details window, each column in `BEERS_WITH_BREWERIES` shows 30 read operations; 30 queries × 12 columns = 360;
* 12 columns of `SALES` are downstreams for `BEERS_WITH_BREWERIES`, and the usage stats for each show Total Read = 260; in total we have 12 columns × 260 queries = 3120 queries.

Finally, 360 + 3120 = **3480**. Everything matches :ok\_hand:
