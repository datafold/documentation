# Snowflake

{% hint style="info" %}
A full script can be found at the bottom of this page.
{% endhint %}

**Step 1: Create a user and role for Datafold**

It is best practice to create a separate role for the Datafold integration. In this guide, we will refer to the role as `DATAFOLDROLE` :

```sql
CREATE ROLE DATAFOLDROLE;
CREATE USER DATAFOLD DEFAULT_ROLE = "DATAFOLDROLE" MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE DATAFOLDROLE TO USER DATAFOLD;
```

To provide column-level lineage, Datafold needs to read & parse all SQL statements executed in your Snowflake account:

```sql
GRANT MONITOR EXECUTION ON ACCOUNT TO ROLE DATAFOLDROLE;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE DATAFOLDROLE;
```

**Step 2a: Use password-based authentication**

Datafold supports username/password authentication, but also key-pair authentication.

```sql
ALTER USER DATAFOLD SET PASSWORD = 'SomethingSecret';
```

You can set the username/password in the Datafold web UI.

**Step 2b: Use key-pair authentication**

If you want to use key-pair authentication, please [follow the steps of Snowflake](https://docs.snowflake.com/en/user-guide/key-pair-auth.html). The public key will be set to the Snowflake user:

```sql
ALTER USER DATAFOLD SET rsa_public_key='abc..'
```

The private key needs to be uploaded to Datafold, and the optional passphrase of the private-key can be set to the user.

**Step 3: Create schema for Datafold**

Datafold requires a schema that is being used as a scratch surface for performance, and this allows us to keep the data processing inside of the DWH, and only fetch the results back to Datafold.

```sql
CREATE SCHEMA <database_name>.DATAFOLD_TMP;
GRANT ALL ON SCHEMA <database_name>.DATAFOLD_TMP TO DATAFOLDROLE;
```

This is the only schema that Datafold needs write access to.

**Step 4: Give the Datafold role access to your Data warehouse**

Datafold will only scan the tables that it has access to. The snippet below will give Datafold read access to a database. Make sure to grant access to all the databases that you want to use in Datafold.

```sql
/* Repeat for every DATABASE to be usable in Datafold. This allows Datafold to
correctly discover, profile & diff each table */
GRANT USAGE ON WAREHOUSE <warehouse_name> TO ROLE DATAFOLDROLE;
GRANT USAGE ON DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT USAGE ON ALL SCHEMAS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT SELECT ON ALL TABLES IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT SELECT ON FUTURE TABLES IN DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT SELECT ON ALL VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT SELECT ON FUTURE VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT SELECT ON ALL MATERIALIZED VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
```

### Full Script

```sql
--Step 1: Create a user and role for Datafold
CREATE ROLE DATAFOLDROLE;
CREATE USER DATAFOLD DEFAULT_ROLE = "DATAFOLDROLE" MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE DATAFOLDROLE TO USER DATAFOLD;

GRANT MONITOR EXECUTION ON ACCOUNT TO ROLE DATAFOLDROLE;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE DATAFOLDROLE;

--Step 2a: Use password-based authentication
ALTER USER DATAFOLD SET PASSWORD = 'SomethingSecret';
--OR
--Step 2b: Use key-pair authentication
--ALTER USER DATAFOLD SET rsa_public_key='abc..'

--Step 3: Create schema for Datafold
CREATE SCHEMA <database_name>.DATAFOLD_TMP;
GRANT ALL ON SCHEMA <database_name>.DATAFOLD_TMP TO DATAFOLDROLE;

--Step 4: Give the Datafold role access to your Data warehouse
/*
  Repeat for every DATABASE to be usable in Datafold. This allows Datafold to
  correctly discover, profile & diff each table
*/
GRANT USAGE ON WAREHOUSE <warehouse_name> TO ROLE DATAFOLDROLE;
GRANT USAGE ON DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT USAGE ON ALL SCHEMAS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT SELECT ON ALL TABLES IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT SELECT ON FUTURE TABLES IN DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT SELECT ON ALL VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT SELECT ON FUTURE VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;

GRANT SELECT ON ALL MATERIALIZED VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN DATABASE <database_name> TO ROLE DATAFOLDROLE;
```
