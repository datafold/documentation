---
description: In case you want to run your dbt open source from your own pipeline
---

# dbt Core / datafold-sdk

You can also use Datafold when you don't have a dbt cloud account and are running dbt from your own Continuous Integration environments, such as CircleCI, Github, Travis, Jenkins, or others. Datafold uses some artifacts from the build to determine the tables that changed and those have to be uploaded for every run of dbt executed in your `production` or `pull_request` runs.&#x20;

* Go to **Datafold** > **Settings** > **CI Settings**, select **Add new CI config,** and fill out the form below:

![](<../../../.gitbook/assets/image (20).png>)

| Parameter                                | Description                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Repository                               | Select the repository that generates the webhooks and where pull / merge requests will be raised.                                                                                                                                                                                                                                                                                                                                                   |
| Datasource                               | Select the datasource where the code that is changed in the repository will run.                                                                                                                                                                                                                                                                                                                                                                    |
| Name                                     | An identifier to be able to find the CI configuration later from the main screen                                                                                                                                                                                                                                                                                                                                                                    |
| CI config id                             | An identifier that is used when running the datafold SDK                                                                                                                                                                                                                                                                                                                                                                                            |
| Primary key tag                          | See [dbt Integration](../)                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Sync metadata on every push to prod      | When selected, will sync the metadata from the dbt run with Datafold every time a push happens on the default branch.                                                                                                                                                                                                                                                                                                                               |
| Files to ignore                          | <p>If defined, the files matching the pattern will be ignored in the PRs. The pattern uses the syntax of .gitignore. Excluded files can be re-included by using the negation; re-included files can be later re-excluded again to narrow down the filter. For example, to exclude everything except the <code>/dbt</code> folder, but not the dbt <code>.md</code> files, do:<br><code>*</code><br><code>!dbt/*</code><br><code>dbt/*.md</code></p> |
| Mark the CI check as failed on errors    | If the checkbox is disabled, the errors in the CI runs will be reported back to GitHub/GitLab as successes, to keep the check "green" and not block the PR/MR. By default (enabled), the errors are reported as failures.                                                                                                                                                                                                                           |
| Require the 'datafold' label to start CI | When this is ticked, the Datafold CI process will only run when the 'datafold' label is applied to the Pull Request. This label needs to be created manually in GitHub or GitLab and the title or name matches 'datafold' exactly.                                                                                                                                                                                                                  |
| Sampling tolerance                       | The tolerance to apply in sampling for all datadiffs                                                                                                                                                                                                                                                                                                                                                                                                |
| Sampling confidence                      | The confidence to apply when sampling                                                                                                                                                                                                                                                                                                                                                                                                               |

We've created [datafold-sdk](https://pypi.org/project/datafold-sdk/) Python package to automate this process in a CI agnostic way. This utility will zip dbt's `target` directory and upload that to the Datafold server application. It is available from pypi.org:

`pip install datafold-sdk`

The command used to automate the entire upload process is `dbt` :&#x20;

```
> export DATAFOLD_APIKEY=3YUjoHKF4dL2vfqCvD0ZgQ7Z12345abcdefg1925
> datafold dbt upload \
    --ci-config-id 1 \
    --run-type pull_request \
    --target-folder ./target/ \
    --commit-sha f94ea0bfd3baba6f192677486701b3dfa18529fe
```

Make sure that the credentials are available using the environment variables`DATAFOLD_APIKEY`. You can create an access token in your [personal account](https://app.datafold.com/users/me).

| CLI argument    | Description                                                                                                                                                                                                                                                                                                     |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| --ci-config     | This is the identifier of the CI config id visible on the CI settings screen. In the example screenshot it is set at 21.                                                                                                                                                                                        |
| --run-type      | This is either `pull_request` or `production`, depending on the type of run in dbt.                                                                                                                                                                                                                             |
| --target-folder | The target folder produced by dbt in the run. All artifacts in the root of the directory are recursively zipped.                                                                                                                                                                                                |
| --commit-sha    | Optional. The SHA of the latest commit in the PR branch. This is the same as the `pr_sha` in the GitHub `pull_request` webhook if you have your CI set up with GitHub. If the target folder was produced in the source repository itself, the CLI will attempt to derive the commit SHA using a `git` command.  |

> If you are using **GitHub Actions**, by default you'll be working with merge commit that is automatically created by merging PR into the base branch. This commit is ephemeral and doesn't exist outside of the action runner, so Datafold won't be able to link artifact submission to the PR.
>
> For that reason when submitting artifacts, you should use PR HEAD sha instead. It can be extracted with the following snippet:

```
export PR_SHA=$(cat $GITHUB_EVENT_PATH | jq -r .pull_request.head.sha)          
```


Or, use the Datafold SDK in your python code directly:

```python
import os

from datafold.sdk.dbt import submit_artifacts

host = os.environ.get("DATAFOLD_HOST")
api_key = os.environ.get('DATAFOLD_APIKEY')

submit_artifacts(host=host,
                 api_key=api_key,
                 ci_config_id=1,
                 run_type='pull_request',
                 target_folder='<abs-path-to-dbt-target-folder>',
                 commit_sha='abcdef1234567890')
```

