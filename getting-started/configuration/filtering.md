# Filtering

When configuring a data source, certain databases, schemas, and tables can be excluded from search results and partially from Lineage.

![In this example: show only the LIVE database, hide all other databases, but also hide all the temporary schemas and tables in the LIVE database.](<../../.gitbook/assets/image (201).png>)

Two settings define the filtering:

* Tables to include in Catalog
* Tables to exclude form Catalog

Only the tables that are included and not excluded will be shown. If the include-filter is not set, all tables are included implicitly. If the exclude-filter is not set, no tables are excluded by default. Which means that if neither of the fields is configured, all tables are shown — this is the default state.

Both filters are globs for the table references in the form `DATABASE.SCHEMA.TABLE`. A special mask `*` matches any number of characters (0..∞), while the mask `?` matches strictly one character. Multiple lines are joined with the "OR" operation — i.e the table matches the filter if it matches any line in the filter.

For simplicity, the trailing catch-all globs can be omitted: e.g., `DEV` is the same as `DEV.*` and `DEV.*.*`. Similarly, `*TMP*` is the same as `*TMP*.*.*` — it matches all tables in all databases which have the "TMP" substring in their name.

The filters are case insensitive.

The filters affect the following functionality:

* Searching the tables in the Catalog.
* Showing the downstream tables in Lineage.

#### Exclusion/inclusion in Catalog

Note that even the excluded tables will be indexed and available for search by their explicit full name (with the database and schema in it).

#### Exclusion/inclusion in Lineage

Also note that all tables, even the excluded ones, will be shown as upstream tables in Lineage. E.g., when an excluded table X was used to produce the included and shown table M, table X will be excluded from the catalog and search results but will be shown in the lineage graph of table M.

However, the excluded tables are not shown as downstream tables. E.g., when the excluded table Z was produced from the data of the shown table M, table Z will not be visible in the lineage graph of table M, so as in the search results.
