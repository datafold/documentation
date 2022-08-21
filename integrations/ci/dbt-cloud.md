---
description: Integrate Datafold with managed dbt Cloud
---

# dbt Cloud

## Prerequisites

{% hint style="warning" %}
You will need an API key for a dbt Cloud user whose account will be used for the integration. Their name will show up in the pull/merge request. You can either create a "synthetic" user "team@yourcompany.com" or use one of the existing accounts.
{% endhint %}

### Configure dbt Cloud in Datafold

Go to **Datafold** > **Settings** > **CI Settings**, select **dbt Cloud,** and fill out the form:

![](<../../.gitbook/assets/image (256).png>)

* Get an [API key](https://cloud.getdbt.com/#/profile/api/) in your dbt Cloud user profile.
* After you specify the API key, you'll be able to select the account and production and PR build ID's to use.
* Set the primary key tag name that you use, described above.
* The meta synchronization schedule allows you to synchronize the metadata from dbt into the catalog at a preset time. Keep in mind however that when you select this option, all user edits will be overwritten next time the schedule runs.

| Parameter                                | Description                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Repository                               | Select the repository that generates the webhooks and where pull / merge requests will be raised.                                                                                                                                                                                                                                                                                                                                                   |
| Datasource                               | Select the datasource where the code that is changed in the repository will run.                                                                                                                                                                                                                                                                                                                                                                    |
| Name                                     | An identifier to be able to find the CI configuration later from the main screen                                                                                                                                                                                                                                                                                                                                                                    |
| CI config id                             | An identifier that is only used when running CI with the datafold-sdk, not for dbt Cloud.                                                                                                                                                                                                                                                                                                                                                           |
| API Key                                  | This is an API key from dbt Cloud, taken from the "Profile \| API Access" page.                                                                                                                                                                                                                                                                                                                                                                     |
| Account name                             | This becomes selectable when a valid API key is filled in. After that, select your account to use.                                                                                                                                                                                                                                                                                                                                                  |
| Job that builds production tables        | This becomes selectable after a valid API key is filled in. Select the job that builds production tables.                                                                                                                                                                                                                                                                                                                                           |
| Job that builds pull requests            | This becomes selectable after a valid API key is filled in. Select the job that builds pull requests.                                                                                                                                                                                                                                                                                                                                               |
| Primary key tag                          | See [dbt Integration](./)                                                                                                                                                                                                                                                                                                                                                                                                                           |
| Sync metadata on every push to prod      | When selected, will sync the metadata from the dbt run with Datafold every time a push happens on the default branch.                                                                                                                                                                                                                                                                                                                               |
| Files to ignore                          | <p>If defined, the files matching the pattern will be ignored in the PRs. The pattern uses the syntax of .gitignore. Excluded files can be re-included by using the negation; re-included files can be later re-excluded again to narrow down the filter. For example, to exclude everything except the <code>/dbt</code> folder, but not the dbt <code>.md</code> files, do:<br><code>*</code><br><code>!dbt/*</code><br><code>dbt/*.md</code></p> |
| Mark the CI check as failed on errors    | If the checkbox is disabled, the errors in the CI runs will be reported back to GitHub/GitLab as successes, to keep the check "green" and not block the PR/MR. By default (enabled), the errors are reported as failures.                                                                                                                                                                                                                           |
| Require the 'datafold' label to start CI | When this is ticked, the Datafold CI process will only run when the 'datafold' label has been applied. This label needs to be created manually in GitHub or GitLab and the title or name must match 'datafold' exactly.                                                                                                                                                                                                                             |
| Sampling tolerance                       | The tolerance to apply in sampling for all datadiffs                                                                                                                                                                                                                                                                                                                                                                                                |
| Sampling confidence                      | The confidence to apply when sampling                                                                                                                                                                                                                                                                                                                                                                                                               |

### Trigger dbt Cloud after a merge

By default, dbt Cloud runs the production job on a schedule. For example, the production dataset is being triggered every hour or even on a daily schedule. It can be that Datafold will run against an older version of the pipeline, or it will wait for the latest commit to being built.

To avoid this you can set up a simple GitHub Action that will trigger the job after a commit has been made on the branch, ensuring that the main branch is always up to date.

```
name: Trigger dbt Cloud

on:
  push:
    branches:
      - main

jobs:
  run:
    runs-on: ubuntu-20.04
    timeout-minutes: 15

    steps:
      - name: checkout
        uses: actions/checkout@v2

      - name: Trigger dbt Cloud job
        run: |
          output=$(curl -X POST --fail \
            --header "Authorization: Token ${DBT_API_KEY}" \
            --header "Content-Type: application/json" \
            --data '{"cause": "Commit '"${GIT_SHA}"'"}' \
            https://cloud.getdbt.com/api/v2/accounts/${ACCOUNT_ID}/jobs/${JOB_ID}/run/)

          echo "Triggered dbt Cloud run at:"
          echo ${output} | jq -r .data.href
        env:
          DBT_API_KEY: ${{ secrets.DBT_API_KEY }}
          ACCOUNT_ID: 1234 # dbt account id
          JOB_ID: 4567 # dbt job id of the production tables
          GIT_SHA: "${{ github.ref == 'refs/heads/master' && github.sha || github.event.pull_request.head.sha }}"
```

You need to add the dbt Cloud API key as a secret in GitHub Actions, and you need to set the IDs of the account and the job id that builds the production job. You can also find this easily in the dbt Cloud UI:

![](<../../.gitbook/assets/image (219).png>)
