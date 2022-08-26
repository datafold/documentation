---
description: >-
  This section describes how to set up automatic tests of pull requests (PR) on
  GitHub.
---

# GitHub

The GitHub integration with Datafold enables automation of ETL code regression testing with **Data Diff:** on every pull request to the ETL code, Datafold GitHub App will run a data diff to evaluate the impact of the change to the ETL source code on the data produced. The summary of the diff will be posted in the Pull Request discussion, and the detailed diff view can be then explored in the Datafold App:

![Example attachment of datadiff to GitHub Pull Request](<../../../../.gitbook/assets/image (120).png>)

The GitHub permissions requested by the Datafold App are:

```
"contents": "read"
"metadata": "read"
"statuses": "write"
"pull_requests": "write"
```

### Installing the Datafold GitHub App

> If you are on an on-prem deployment, you should first create the GitHub App. See [GitHub integration for Datafold on-prem](github-integration-for-datafold-on-prem.md). Then, proceed with the current tutorial.


The easiest way to integrate with Datafold is to allow access to the repositories using the GitHub App.&#x20;

> You have to be an admin of your GitHub organization to be able to install the GitHub App.


Go to the _Git settings screen_ in Datafold. Click _Install GitHub App_. Follow through the steps. Instead of _all repositories_, select the specific repositories the app should have access to.

![](<../../../../.gitbook/assets/image (283).png>)

When the process is complete, you are returned to the settings screen.

The _Refresh_ button is available when an administrator makes changes to the repositories that the app has access to. When any administrative change has occurred on GitHub, that button can be used to synchronize Datafold with the remote changes.

![](<../../../../.gitbook/assets/image (235).png>)

If you select the repository and hit Save, you will return to the Git settings screen:

![](<../../../../.gitbook/assets/image (143).png>)

Now you can set up the CI Integration. For more information, please refer to [dbt integration](../../).
