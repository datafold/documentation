---
description: Setting up continuous integration with Datafold
---

# Continuous Integrations

Continuous Integration, at its core, is about creating small changes that are built and well-tested before merging in to the source code. While teams are working quickly to make changes, data teams often feel the impact of data-related changes that have downstream consequences.&#x20;

Becoming pro-active about data quality requires data teams to find and adjust these issues BEFORE they make it to production. Datafold in your CI process can greatly reduce these issues and flag all potential downstream issues right in the PR, giving the reviewer and author to address the issues.&#x20;

### Set up your CI in two steps:

* Authorize our Github or Gitlab integrations

{% content-ref url="git/github/" %}
[github](git/github/)
{% endcontent-ref %}

{% content-ref url="git/gitlab.md" %}
[gitlab.md](git/gitlab.md)
{% endcontent-ref %}

* Use dbt or the `datafold-sdk` to implement your tests

{% content-ref url="dbt-cloud.md" %}
[dbt-cloud.md](dbt-cloud.md)
{% endcontent-ref %}

{% content-ref url="dbt-ci/" %}
[dbt-ci](dbt-ci/)
{% endcontent-ref %}

{% content-ref url="datafold-sdk.md" %}
[datafold-sdk.md](datafold-sdk.md)
{% endcontent-ref %}
