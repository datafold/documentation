---
description: Setting up your Postgres data source in Datafold
---

# Postgres

To connect to Postgres, you need to create a user with read-only access to all tables in all schemas, write access to Datafold-specific schema for temporary tables:

```sql
/* Create schema for Datafold to write temporary tables to.
    This is the only schema where Datafold will modify anything in your environment.*/

CREATE SCHEMA datafold_tmp;

/* Create a datafold user */

CREATE ROLE datafold WITH LOGIN ENCRYPTED PASSWORD 'SOMESECUREPASSWORD';

/* Make sure that the postgres user has read permissions on the tables */

GRANT USAGE ON SCHEMA myschema TO datafold;
GRANT SELECT ON ALL TABLES IN SCHEMA myschema TO datafold;

```

### AWS Aurora Postgres Lineage

This will guide you through setting up Lineage with AWS using CloudWatch. AWS Aurora Serverless is not tied to any (virtual) machine, and therefore it only allows you to send the logs to CloudWatch. In these steps we will:

* **Increase the verbosity of the logging of Postgres;** to make sure that we log the required statements to track lineage
* **Set up an account for fetching the logs from CloudWatch;** we will follow the best practices and create a new account for Datafold, to fetch the logs from CloudWatch.

#### Increased verbosity

Let's say that we have `fokkos-aurora` Postgresql instance in AWS that we want to extract lineage from:

![](<../../.gitbook/assets/image (160).png>)

First, we need to create a new Parameter group. The database instance runs with the default parameters. If you want to set parameters (such as the logging verbosity), you need to create a new Parameter group. Hit **Parameter Groups** on the menu, and create a new Parameter Group:

![](<../../.gitbook/assets/image (217).png>)

Next, we select the `aurora-postgresql10` parameter group family. This depends on the cluster that you're running. For Aurora serverless, this is the appropriate family.,

![](<../../.gitbook/assets/image (67).png>)

We want to set the `log_statement` enum field. By default, this isn't set, and we want to set it to mod, meaning that it will log all the DDL statements, plus data-modifying statements:

![](<../../.gitbook/assets/image (195).png>)

After saving the parameter group, we can go back to our database, and select the right DB cluster parameter group:

![](<../../.gitbook/assets/image (146).png>)

After saving, we're ready to hook up Datafold to CloudWatch.

### Connect Datafold to CloudWatch

Creating a user for Datafold is quite straightforward. It is best to create a new user to isolate the permissions as much as possible. First, we go to IAM an create a new user:

![](<../../.gitbook/assets/image (148).png>)

Make sure that the Programmatic Access checkbox has been checked. Next, we'll create a new group:

![](<../../.gitbook/assets/image (118).png>)

We call this group `CloudWatchLogsReadOnly` and attache the `CloudWatchLogsReadOnlyAccess` policy to it. Next, we select the group:

![](<../../.gitbook/assets/image (12).png>)

When reviewing the user, it should have the freshly created group attached to it:

![](<../../.gitbook/assets/image (265).png>)

Now we have the new access together with the Access key ID and the Secret access key:

![](<../../.gitbook/assets/image (36).png>)

Make sure that the credentials are kept secure. Store them somewhere safely (for example, a password manager), because we need them later to store them into Datafold.

Next, go to CloudWatch and lookup the Log group:

![](<../../.gitbook/assets/image (13).png>)

We need to supply the Credentials and the Log group to Datafold:

![](<../../.gitbook/assets/image (262).png>)

> [IP Whitelisting ->](../../developer/security/network-security.md)


>After setting permissions in your data source, move on to [Configuration ->](../configuration/)

