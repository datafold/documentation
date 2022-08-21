# Databricks

## Prepare credentials

### Generate a Personal Access Token

Visit **Settings** → **User Settings**, and then switch to **Personal Access Tokens** tab.

![](../../.gitbook/assets/1\_Screen\_Shot\_2022-06-02\_at\_6\_30\_29\_PM.png)

Then, click **Generate new token**. Save the generated token somewhere, we will need it later on.

![](../../.gitbook/assets/2\_Screen\_Shot\_2022-06-02\_at\_6\_31\_22\_PM.png)

### Retrieve SQL endpoint settings

In **SQL** mode, navigate to **SQL Endpoints**.

![](../../.gitbook/assets/3\_Screen\_Shot\_2022-06-02\_at\_6\_36\_38\_PM.png)

Choose the preferred endpoint and copy the following fields values from its **Connection Details** tab:

* Server hostname
* HTTP path

![](../../.gitbook/assets/4\_Screen\_Shot\_2022-06-02\_at\_6\_42\_12\_PM.png)

## Create a Data Source

By opening **Admin** → **Settings** at **Datafold**, you will automatically be directed to **Data Sources** tab. Click **+ New Data Source** and choose **Databricks**. Connection parameters are in the lower part of the popup window.

![](../../.gitbook/assets/5\_Screen\_Shot\_2022-06-02\_at\_6\_43\_53\_PM.png)

**Database** parameter has the format of `CATALOG_NAME.DATABASE_NAME`.

In most cases, `CATALOG_NAME` is `hive_metastore`.

Click **Save**. Your data source is ready!

{% hint style="info" %}
[IP Whitelisting ->](../../developer/security/network-security.md)
{% endhint %}

{% hint style="success" %}
After setting permissions in your data source, move on to [Configuration ->](../configuration/)
{% endhint %}
