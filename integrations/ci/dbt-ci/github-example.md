# GitHub example

A simple example pipeline using GitHub Actions. In this example, we have a production and development environment. The production environment runs from the default branch, and the development from pull requests:

```python
name: dbt + datafold

on:
  push:
    branches:
      - master
  pull_request:
  schedule: # Run the pipeline every night
    - cron: '0 0 * * *'

jobs:
  run:
    runs-on: ubuntu-20.04
    timeout-minutes: 15

    steps:
      - name: checkout
        uses: actions/checkout@v2

      - uses: actions/setup-python@v2
        with:
          python-version: '3.8'

      - name: install deps
        run: pip install -q dbt datafold-sdk

      - name: dbt run
        run: dbt run --profiles-dir ./
        env:
          SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
          SNOWFLAKE_PASSWORD: ${{ secrets.SNOWFLAKE_PASSWORD }}
          SNOWFLAKE_SCHEMA: "${{ github.ref == 'refs/heads/master' && 'BEERS' || 'BEERS_DEV' }}"

      - name: submit artifacts to datafold
        run: |
          set -ex
          datafold dbt upload --ci-config-id 29 --run-type ${DATAFOLD_RUN_TYPE} --target-folder ./target/ --commit-sha ${GIT_SHA}
        env:
          DATAFOLD_APIKEY: ${{ secrets.DATAFOLD_APIKEY }}
          DATAFOLD_RUN_TYPE: "${{ github.ref == 'refs/heads/master' && 'production' || 'pull_request' }}"
          GIT_SHA: "${{ github.ref == 'refs/heads/master' && github.sha || github.event.pull_request.head.sha }}"
          
      - name: post check dbt artifacts
        if: ${{ always() }}
        run: |
          set -ex
          datafold dbt check-post-upload-dbt-artifacts --ci-config-id 29 --run-type $DATAFOLD_RUN_TYPE --branch $BRANCH --commit-sha $GIT_SHA
        env:
          DATAFOLD_APIKEY: ${{ secrets.DATAFOLD_APIKEY }}
          DATAFOLD_RUN_TYPE: "${{ github.ref == 'refs/heads/master' && 'production' || 'pull_request' }}"
          GIT_SHA: "${{ github.ref == 'refs/heads/master' && github.sha || github.event.pull_request.head.sha }}"
          BRANCH: "${{ github.ref == 'refs/heads/master' && 'master' || github.head_ref }}"   
```

You can find this example online in our [public dbt-beers](https://github.com/datafold/dbt-beers/blob/master/.github/workflows/dbt.yml) example pipeline.
