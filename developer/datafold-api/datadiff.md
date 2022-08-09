---
description: >-
  The API documentation for creating comparing datasets programmatically using
  Data Diff.
---

# Data Diff

## Creating a new Diff

This method creates a new data diff job asynchronously and returns the `id` that can later be used to retrieve the diff results.

|                       |                     |
| --------------------- | ------------------- |
| Endpoint              | `/api/v1/datadiffs` |
| Method                | `POST`              |
| Request Content-Type  | `application/json`  |
| Response Content-Type | `application/json`  |

{% tabs %}
{% tab title="Request" %}
Example request body:

```javascript
{
    "data_source1_id": 10,
    "data_source2_id": 10,
    "table1": ["df", "prod", "page_views"],
    "query2": "SELECT * FROM df.dev.page_views WHERE date > '2020-01-01'",
    "materialize_dataset1": true,
    "pk_columns": ["organization_id", "user_email"],
    "filter1": "date > '2020-01-01'",
    "sampling_tolerance": 0.0001,
    "sampling_confidence": 99.9,
    "diff_tolerances_per_column": [
        {"column_name": "col_name",
         "tolerance_value": 0.001,
         "tolerance_mode": "absolute"}]
}
```

| Parameter                                                | Required | Type      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| -------------------------------------------------------- | -------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| data\_source1\_id                                        | required | integer   | Id of data source. You can look it up in Datafold UI: Settings -> Data Sources -> Connection, it'll be the last number in the URL.                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| data\_source2\_id                                        | required | integer   | Id of the second datasource. It should be the same as `data_source1_id`, unless you are doing cross-database diffs                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| table1                                                   |          | \[string] | Use the table as the first datasource. Table is specified as a list of segments. Names are case-sensitive.                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| query1                                                   |          | string    | Use provided query as the first datasource. Either `table1`, or `query1` must be specified.                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| table2                                                   |          | \[string] | Use this table as the second data source.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| query2                                                   |          | string    | Use the query as the second data source. Either `table2` or `query2` must be specified.                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| materialize\_dataset1                                    | optional | bool      | Force materialization of dataset 1. It's useful if `table1` is a view and it needs to be materialized prior to diffing. If a query is used as a dataset, then this flag is ignored.                                                                                                                                                                                                                                                                                                                                                                                   |
| materialize\_dataset2                                    | optional | bool      | Force materialization of dataset 2.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| pk\_columns                                              | required | \[string] | List of primary key columns. It's case-sensitive.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| include\_columns                                         | optional | \[string] | Include only specified columns, besides PK columns.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| exclude\_columns                                         | optional | \[string] | Exclude those columns from diff. Useful for excluding data transfer timestamps and such.                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| time\_column                                             | optional | string    | Time column to use for DataDiff time view.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| filter1                                                  | optional | string    | SQL filter for dataset 1. It'll be injected as-is to WHERE clauses during diffing.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| filter2                                                  | optional | string    | SQL filter for dataset 2.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| time\_travel\_point1                                     | optional | string    | <p>Allows you to select a specific version of the table. <a href="https://docs.snowflake.com/en/sql-reference/constructs/at-before.html#syntax">Snowflake:</a></p><ul><li>Relative using a negative integer (ex. -220) for an offset in seconds.</li><li>At a certain point in time using a timestamp (ex. 2021-08-13T00:00:00)</li><li>At a certain statement using the query id.</li></ul><p><a href="https://cloud.google.com/bigquery/docs/time-travel">BigQuery:</a></p><ul><li>At a certain point in time using a timestamp (ex. 2021-08-13T00:00:00)</li></ul> |
| time\_travel\_point2                                     | optional | string    | Same as the abovementioned, for the second data source.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| sampling\_tolerance                                      | optional | float     | Ratio of acceptable number of rows that can be different to the total number of rows. Used only in sampling.                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| sampling\_confidence                                     | optional | float     | Confidence that number of differing rows is less than allowed by sampling\_tolerance, in percents. E.g. `99.9`.                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| diff\_tolerances\_per\_column                            | optional | \[object] | List of objects to configure tolerance value per column.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| <p>diff_tolerances_per_column.</p><p>column_name</p>     | required | string    | The name of the column to which the tolerance applies. Must be of type integer or float, ignored otherwise.                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| <p>diff_tolerances_per_column.</p><p>tolerance_value</p> | required | float     | The value applied to the tolerance.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| <p>diff_tolerances_per_column.</p><p>tolerance_mode</p>  | required | string    | <p>The tolerance mode to apply.</p><p><code>absolute</code> : <code>abs(b-a) &#x3C; X</code></p><p><code>relative</code> : <code>abs((b-a) / a) &#x3C; X</code></p>                                                                                                                                                                                                                                                                                                                                                                                                   |
{% endtab %}

{% tab title="Response" %}
The call returns all data from the request with missing values filled in with either `null`s or defaults. In addition to that, it returns the diff `id` that can be used later to get diff results.

```javascript
{
  "id": 69004,
  "user_id": 1,
  "data_source1_id": 7,
  "data_source2_id": 7,
  "table1": ["df", "prod", "page_views"],
  "table2": null,
  "query1": null,
  "query2": "SELECT * FROM df.dev.page_views WHERE date > '2020-01-01'",
  "filter1": null,
  "filter2": null,
  "pk_columns": ["col0"],
  "include_columns": [],
  "exclude_columns": [],
  "time_column": null,
  "time_aggregate": null,
  "time_interval_start": null,
  "time_interval_end": null,
  "sampling_tolerance": null,
  "sampling_confidence": null,
  "materialize_dataset1": false,
  "materialize_dataset2": false,
  "done": false,
  "result_statuses": {},  
}
```
{% endtab %}
{% endtabs %}

## Getting Diff Results

This method retrieves results of previously created data diff.

|                       |                                          |
| --------------------- | ---------------------------------------- |
| Endpoint              | /api/v1/datadiffs/\<id>/summary\_results |
| Method                | GET                                      |
| Response Content-Type | application/json                         |

{% tabs %}
{% tab title="Response" %}
Immediately after the diff is submitted, the status will be either `waiting` for `processing`:

```javascript
{
  "status": "running",
}
```

When the diff task is done, the status will be set to `done` and additional fields will contain high-level statistics:

```javascript
{
  "status": "success",
  
  "schema": {
    "columns_mismatched": [3, 4],
    "column_type_mismatches": 0,
    "column_reorders": 0,
    "column_counts": [20, 21]
  },
  "pks": {
    "total_rows": [17343000, 19294000],
    "nulls": [0, 0],
    "dupes": [0, 0],
    "exclusives": [0, 1951000],
    "distincts": [17343000, 19294000]
  },
  "values": {
    "total_rows": 17343000,
    "rows_with_differences": 13780000,
    "total_values": 277488000,
    "values_with_differences": 19505000,
    "compared_columns": 16,
    "columns_with_differences": 5
  },
}
```

| Field Path                        | Description                                                                                                                                                       |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| schema.columns\_mismatched        | The number of columns across both datasets compared that didn't match. Datafold matches columns by name and type.                                                 |
| schema.column\_type\_mismatches   | The number of columns across both datasets compared that had a matching name but different types.                                                                 |
| schema.column\_reorders           | The approximate number of columns that were reordered (changed the ordinal position between datasets)                                                             |
| schema.column\_counts             | Column counts in each dataset that were considered for diffing (after include/exclude filters)                                                                    |
| pks.total\_rows                   | The total number of rows in each dataset.                                                                                                                         |
| pks.nulls                         | The number of `NULL` primary keys in each dataset. In the case of a composite primary key,  if any part of it is `NULL`, then the whole key is counted as `NULL`. |
| pks.dupes                         | The number of rows that have duplicate primary keys for each dataset.                                                                                             |
| pks.exclusives                    | The number of primary keys that are exclusive to the first and the second dataset.                                                                                |
| pks.distincts                     | The number of distinct primary keys in each dataset.                                                                                                              |
| values.total\_rows                | The total number of rows for which value comparison was done. Rows with exclusive, duplicate, and null primary keys are excluded from the comparison.             |
| values.compared\_columns          | The number of columns that were compared between datasets (not counting primary keys). Mismatched columns (different names or types) are not compared.            |
| values.total\_values              | The number of values (individual dataset cells) that were compared, excluding primary keys.                                                                       |
| values.rows\_with\_differences    | The number of rows with at least one value different between the datasets.                                                                                        |
| values.columns\_with\_differences | The number of columns with at least one value different between the datasets.                                                                                     |
| values.values\_with\_differences  | The number of individual cells across both rows and columns that are different between datasets.                                                                  |
{% endtab %}

{% tab title="Second Tab" %}

{% endtab %}
{% endtabs %}

In case of error `status` will be set to `failed` and the `message` field will contain error description:

```python
{
   "status" : "error",
   "error" : {
      "error_type" : "NoSuchColumnException",
      "error_value" : "unique_key"
   }
}

```

## Example: using DataDiff with curl

```bash
$ cat >diff_request.json << EOF
{
  "data_source1_id": 138,
  "data_source2_id": 138,
  "table1": ["datadiff-demo", "public", "taxi_trips"],
  "table2": ["datadiff-demo", "dev", "taxi_trips"],
  "pk_columns": ["trip_id"]
}
EOF

$ curl -d "@diff_request.json" \
     -X POST -H 'Content-Type: application/json' \
     -H 'Authorization: Key YOUR_DATAFOLD_API_KEY' \
     'https://app.datafold.com/api/v1/datadiffs' | json_pp

# use diff id returned by previous request
$ curl -H 'Authorization: Key YOUR_DATAFOLD_API_KEY' \
     'https://app.datafold.com/api/v1/datadiffs/12345/summary_results' | json_pp
```

## Example: using DataDiff with Python and requests lib

```python
#!/usr/bin/env python3
import pprint
import time

import requests

HEADERS = {'Authorization': 'Key YOUR_DATAFOLD_API_KEY'}
DIFF_REQUEST = {
  'data_source1_id': 138,
  'data_source2_id': 138,
  'table1': ['datadiff-demo', 'public', 'taxi_trips'],
  'table2': ['datadiff-demo', 'dev', 'taxi_trips'],
  'pk_columns': ['unique_key'],
}

# Create a new Diff task
resp = requests.post(
    'https://app.datafold.com/api/v1/datadiffs',
    headers=HEADERS,
    json=DIFF_REQUEST,
)
diff = resp.json()

# Poll until we get results back
while 1:
    resp = requests.get(
        f'https://app.datafold.com/api/v1/datadiffs/{diff["id"]}/'
        'summary_results',
        headers=HEADERS,
    )
    results = resp.json()
    
    if results['status'] == 'error':
        print('ERROR!', results['error'])
        break
    elif results['status'] == 'success':
        pprint.pprint(results)
        break
        
    time.sleep(20) 
```
