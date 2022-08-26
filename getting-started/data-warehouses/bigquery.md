# BigQuery

The following steps will walk you through creating a service account for Datafold to have read-access to your datasets and write-access to a new temporary table.&#x20;

**Steps to complete:**

* ****[Create a Service Account](bigquery.md#create-a-service-account)
* [Give the Service Account BigQuery Data Viewer, BigQuery Job User, BigQuery Resource Viewer access](bigquery.md#service-account-access-and-permissions)
* [Create a temporary dataset and give BiqQuery Data Editor access to the service account](bigquery.md#create-a-temporary-dataset)
* [Generate a Service Account JSON key](bigquery.md#generate-a-service-account-key)

### Create a Service Account

To connect Datafold to your BigQuery project, you will need to create a _service account_ for Datafold to use.

* Navigate to the [Google Developers Console](https://console.developers.google.com/). Before proceeding, click on the drop-down to the left of the search bar and select the project you want to connect to.
* If you do not see the project, you would like to connect to listed in the drop-down, click on the account switcher in the upper right corner of the window and ensure you are logged in to a Google account that is a member of the project.
* Click on the hamburger menu in the upper left and select **IAM & Admin,** and then **Service Accounts**.
* Create the service account and name it Datafold

<figure><img src="../../.gitbook/assets/image (62).png" alt=""><figcaption></figcaption></figure>

### Service Account Access and Permissions

For Datafold we require the **BigQuery Data Viewer** for read access on all the datasets in the project. We need the **BigQuery Job User** to run queries. Next to that Datafold requires the **BigQuery Resource Viewer** role for fetching the query logs to parse lineage.

<figure><img src="../../.gitbook/assets/image (127).png" alt=""><figcaption></figcaption></figure>

### Create a Temporary Dataset

We need to set one more permission on Datafold's temporary dataset. Let's navigate to BigQuery in the console. Datafold requires read permissions on all the datasets that contain user data but needs one dataset to materialize in between datasets. By materializing this data in BigQuery we reduce the volumes of data that are being processed in Datafold itself.&#x20;

<figure><img src="../../.gitbook/assets/image (222) (1) (1).png" alt=""><figcaption></figcaption></figure>

Give the dataset a name that is related to Datafold, in the example we call it `datafold_tmp`.

**Make sure that the dataset lives in the same region as the rest of the data, otherwise, the dataset will not be found.**

Datafold requires the **BigQuery Data Editor** role on the newly created Dataset. Now we're set with the permissions.&#x20;

### Generate a Service Account Key

Next, we have to go back to the **IAM & Admin** page to generate a key for Datafold:

<figure><img src="../../.gitbook/assets/image (223).png" alt=""><figcaption></figcaption></figure>

For Datafold, we use the recommended json format. After creating the key, it will be saved on your local machine**.**

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
