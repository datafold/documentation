# Indexing

The process of indexing is pulling the schema from the database. This is done periodically, to make sure that new tables are being reflected in the Datafold catalog.

![](<../../.gitbook/assets/image (79).png>)

Depending on how often the schema is being altered, a recommended setting is between 10 and 30 minutes. If you for example have a custom Airflow DAG that creates new tables, then you want to make sure that these tables show in Datafold ASAP in order to be able to do a manual data diff. If you use [the ci](../../integrations/ci/), then you could set the frequency a bit lower.

By default, Datafold will crawl all the objects within the permissions that it has. You can exclude certain schema's from Datafold. Keep in mind, that tables in these schema's are also excluded from the lineage. We recommend to only ignore temporary tables and such.
