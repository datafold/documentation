---
description: This guide will take you through the GitLab integration.
---

# GitLab

> Setting up the GitLab integrations requires **Admin** privileges. Confirm that you have the correct permissions before continuing.

This guide will take you through the required steps to set up Datafold with GitLab. Let's start by adding a new Git config.

![](<../../../.gitbook/assets/image (91).png>)

The integration name is a reference to the repository.

![](<../../../.gitbook/assets/image (234).png>)

As the token we both support [project access token](https://docs.gitlab.com/ee/user/project/settings/project\_access\_tokens.html) and personal token. Project access tokens are preferred since they will stay active if the person leaves the Gitlab organization:

![](<../../../.gitbook/assets/image (264).png>)

Datafold requires the Maintainer role.

For the personal access token; you can fetch the access token from [your profile page in GitLab](https://gitlab.com/-/profile/personal\_access\_tokens). For the integration the `api` permissions are sufficient.

![](<../../../.gitbook/assets/image (10) (1).png>)

Let's use our example repository [datafold/dbt-snowflake](https://gitlab.com/datafold/dbt-snowflake) in GitLab. As the name suggests, this is a simple example setup using dbt with a Snowflake backend.

![](<../../../.gitbook/assets/image (174).png>)

After saving, it is always a good idea to hit the **Test** button to check if everything is set up correctly:

![](<../../../.gitbook/assets/image (109).png>)

After this, make sure to set up a CI under the CI settings.
