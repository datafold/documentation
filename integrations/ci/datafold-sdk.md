---
description: The datafold-sdk enables our CI capabilities without using dbt
---

# datafold-sdk

Datafold allows you to trigger data diffs from CI using the [datafold-sdk](https://pypi.org/project/datafold-sdk/). This allows you to easily integrate Datafold in your CI with arbitrary pipeline orchestrators. This often requires some glue code to wire, for example, Airflow to Datafold. First, you go to[ CI settings](https://app.datafold.com/settings/ci\_integrations).

![](<../../.gitbook/assets/image (194).png>)

Next, click "Add new CI config":

![](<../../.gitbook/assets/image (7) (1).png>)

First, we select the repository set up under [Git settings](git/). Then we choose the data source that [we have set up earlier](../../getting-started/data-warehouses/), and we give it a name so we can easily remember the settings. The other settings are optional; more info can be found under the question-mark icon. After saving, we'll have a CI config id that we need later on:

![](<../../.gitbook/assets/image (269).png>)

Now, the connection has been set up, and for the pull request, you'll see the Datafold check on the pull request:

![](<../../.gitbook/assets/image (244).png>)

Now, you need to let Datafold know which tables we need to diff. First, we need to set the credentials using the environment variable `DATAFOLD_APIKEY`. In the case of self-hosted Datafold, you need to set the `DATAFOLD_HOST` as well:

```bash
export DATAFOLD_APIKEY=tnQrPAyIHquhx4x9LJdOHC28waU1P0FdCvabcabc
export DATAFOLD_HOST=https://datafold.company.io
```

From the CLI you can run:

```bash
datafold ci submit \
    --ci-config-id 13 \
    --pr-num 6 <<- EOF
[{
        "prod": "INTEGRATION.BEERS.BEERS",
        "pr": "INTEGRATION.BEERS_DEV.BEERS",
        "pk": ["BEER_ID"]
}]
EOF
Successfully started a diff under Run ID 401
```

This will request a single diff for the `BEERS` table between the `BEERS` and `BEERS_DEV` schema. Of course, you can add multiple tables to the array.

This will trigger the diff, and the results will be posted in the Pull Request:

![](<../../.gitbook/assets/image (93).png>)

Also, for the Pythonistas, you can do it directly from Python:

```python
Python 3.9.10 (main, Jan 15 2022, 11:48:04) 
Type 'copyright', 'credits' or 'license' for more information
IPython 7.26.0 -- An enhanced Interactive Python. Type '?' for help.

In [1]: from datafold_sdk.sdk.ci import run_diff, CiDiff

In [2]: run_id = run_diff(
   ...:     host="https://datafold.company.io",
   ...:     api_key="tnQrPAyIHquhx4x9LJdOHC28waU1P0FdCvabcabc",
   ...:     ci_config_id=13,
   ...:     pr_num=6,
   ...:     diffs=[
   ...:       CiDiff(
   ...:         prod='INTEGRATION.BEERS.BEERS',
   ...:         pr='INTEGRATION.BEERS_DEV.BEERS',
   ...:         pk=["BEER_ID"]
   ...:       )
   ...:     ]
   ...: )

In [3]: print(f"Successfully started a diff under Run ID {run_id}")
Successfully started a diff under Run ID 402
```
