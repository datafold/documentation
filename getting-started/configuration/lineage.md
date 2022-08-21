# Lineage

The lineage is a lightweight process that will fetch the historical statements from the data warehouse. It is recommended to set this to every 10 minutes `*/10 * * *`

This will make sure that the lineage is up to date, and will lower the impact on the DWH since it will fetch the statements in an incremental fashion:

![](<../../.gitbook/assets/image (279).png>)

The most important part of setting up lineage is making sure that it has the appropriate permissions, as fetching the historical statements requires special permissions stated under the [Data Warehouse Integrations](../data-warehouses/).
