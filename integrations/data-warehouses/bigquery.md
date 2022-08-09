# BigQuery

To connect Datafold to your BigQuery project, you will need to create a _service account_ for Datafold to use.

1. Navigate to the [Google Developers Console](https://console.developers.google.com/). Before proceeding, click on the drop-down to the left of the search bar and select the project you want to connect to.

{% hint style="info" %}
If you do not see the project, you would like to connect to listed in the drop-down, click on the account switcher in the upper right corner of the window and ensure you are logged in to a Google account that is a member of the project.
{% endhint %}

Click on the hamburger menu in the upper left and select **IAM & Admin,** and then **Service Accounts**.

![](<../../.gitbook/assets/image (247).png>)

Let's create a new service account:

![](<../../.gitbook/assets/image (138).png>)

Give the Service Account a name, for example Datafold:

![](<../../.gitbook/assets/image (193).png>)

For Datafold we require the **BigQuery Data Viewer** for read access on all the datasets in the project. We need the **BigQuery Job User** to run queries. Next to that Datafold requires the **BigQuery Resource Viewer** role for fetching the query logs to parse lineage.

![](<../../.gitbook/assets/image (28).png>)

Next, we can hit **Done** to create the SA:

![](<../../.gitbook/assets/image (198).png>)

We need to set one more permission on Datafolds' temporary dataset. Let's navigate to BigQuery in the console. Datafold requires read permissions on all the datasets that contain user data but needs one dataset to materialize in between datasets. By materializing this data in BigQuery we reduce the volumes of data that are being processed in Datafold itself.&#x20;

![](<../../.gitbook/assets/image (166).png>)

Give the dataset a name that is related to Datafold, in the example we call it `datafold_tmp`.

![](<../../.gitbook/assets/image (241).png>)

Make sure that the dataset lives in the same region as the rest of the data, otherwise, the dataset will not be found.

Now we have to set the permissions, to make sure that Datafold can create tables.

![](<../../.gitbook/assets/image (121).png>)

&#x20;After clicking on Permissions, we need to add a new principal to the Dataset:

![](<../../.gitbook/assets/image (242).png>)

Datafold requires the **BigQuery Data Editor** role on the newly created Dataset. Now we're set with the permissions. Next, we need to create a new key that we need to upload to Datafold:

![](<../../.gitbook/assets/image (163).png>)

Next, we have to go back to the **IAM & Admin** page to generate a key for Datafold:

![](<../../.gitbook/assets/image (238).png>)

For Datafold, we use the recommended json format. After creating the key, it will be saved on your local machine:

![](<../../.gitbook/assets/image (290).png>)

This concludes the steps we need to take in GCP. Now we can jump to Datafold to set up the Datasource:

![](<../../.gitbook/assets/image (271).png>)

In the **Project ID** field, enter the BigQuery project ID. It can be found in the URL of your Google Developers Console: `https://console.developers.google.com/apis/library?project=MY_PROJECT_ID`

In the **Schema for temporary tables** field, enter \[Project ID].datafold\_tmp.

Note that the project that contains the temporary schema does not need to be the primary project specified above
