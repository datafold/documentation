---
description: Setting up your BigQuery data source in Datafold
---

# BigQuery

The following steps will walk you through creating a service account for Datafold to have read-access to your datasets and write-access to a new temporary table.&#x20;

<details>

<summary>Create a service account for Datafold in your Big Query project</summary>

To connect Datafold to your BigQuery project, you will need to create a _service account_ for Datafold to use.

1. Navigate to the [Google Developers Console](https://console.developers.google.com/). Before proceeding, click on the drop-down to the left of the search bar and select the project you want to connect to.
2. If you do not see the project, you would like to connect to listed in the drop-down, click on the account switcher in the upper right corner of the window and ensure you are logged in to a Google account that is a member of the project.

Click on the hamburger menu in the upper left and select **IAM & Admin,** and then **Service Accounts**.

<img src="../../.gitbook/assets/image (62).png" alt="" data-size="original">

Let's create a new service account:

<img src="../../.gitbook/assets/image (173).png" alt="" data-size="original">

Give the Service Account a name, for example Datafold:

<img src="../../.gitbook/assets/image (286).png" alt="" data-size="original">



</details>

<details>

<summary>Give the service account access (BigQuery Data Viewer, BigQuery Job User, BigQuery Resource Viewer)</summary>

For Datafold we require the **BigQuery Data Viewer** for read access on all the datasets in the project. We need the **BigQuery Job User** to run queries. Next to that Datafold requires the **BigQuery Resource Viewer** role for fetching the query logs to parse lineage.

<img src="../../.gitbook/assets/image (127).png" alt="" data-size="original">

Next, we can hit **Done** to create the service account. Datafold does not require additional user access.&#x20;

</details>

<details>

<summary>Create a temporary dataset that Datafold can write to with a <strong>BigQuery Data Editor role</strong></summary>

We need to set one more permission on Datafolds' temporary dataset. Let's navigate to BigQuery in the console. Datafold requires read permissions on all the datasets that contain user data but needs one dataset to materialize in between datasets. By materializing this data in BigQuery we reduce the volumes of data that are being processed in Datafold itself.&#x20;

<img src="../../.gitbook/assets/image (34).png" alt="" data-size="original">

Give the dataset a name that is related to Datafold, in the example we call it `datafold_tmp`.

<img src="../../.gitbook/assets/image (84).png" alt="" data-size="original">

**Make sure that the dataset lives in the same region as the rest of the data, otherwise, the dataset will not be found.**

Now we have to set the permissions, to make sure that Datafold can create tables.

<img src="../../.gitbook/assets/image (246).png" alt="" data-size="original">

&#x20;After clicking on Permissions, we need to add a new principal to the Dataset:

<img src="../../.gitbook/assets/image (39).png" alt="" data-size="original">

Datafold requires the **BigQuery Data Editor** role on the newly created Dataset. Now we're set with the permissions. Next, we need to create a new key that we need to upload to Datafold:

<img src="../../.gitbook/assets/image (266).png" alt="" data-size="original">



</details>

<details>

<summary>Generate a key for the Datafold service account ( JSON format is recommended)</summary>

Next, we have to go back to the **IAM & Admin** page to generate a key for Datafold:

<img src="../../.gitbook/assets/image (223).png" alt="" data-size="original">

For Datafold, we use the recommended json format. After creating the key, it will be saved on your local machine:

<img src="../../.gitbook/assets/image (170).png" alt="" data-size="original">

</details>

{% hint style="warning" %}
In the **Project ID** field, enter the BigQuery project ID. It can be found in the URL of your Google Developers Console: `https://console.developers.google.com/apis/library?project=MY_PROJECT_ID`

In the **Schema for temporary tables** field, enter the project id and temporary table name in the following format `Project_id.temp_table_name`.
{% endhint %}

{% hint style="info" %}
[IP Whitelisting ->](../../developer/security/network-security.md)
{% endhint %}

{% hint style="success" %}
After setting permissions in your data source, move on to [Configuration ->](../configuration/)
{% endhint %}
