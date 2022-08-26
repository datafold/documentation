# Redshift

To connect to Amazon Redshift, you need to create a user with read-only access to all tables in all schemas, write access to Datafold-specific schema for temporary tables, and the ability to access SQL logs:

```sql
/* Create schema for Datafold to write temporary tables to.
    This is the only schema where Datafold will modify anything in your environment.*/

CREATE SCHEMA datafold_tmp;

/* Since Redshift does not allow granting read-nonly access to ALL schemas which
   Datafold needs to correctly work, you need to grant superuser level privilege to
   the datafold user: */
      
CREATE USER datafold CREATEUSER PASSWORD 'SOMESECUREPASSWORD';


/* The following permission allows Datafold to pull SQL logs and construct
   column-level lineage */

ALTER USER datafold WITH SYSLOG ACCESS UNRESTRICTED;
```

{% hint style="info" %}
[IP Whitelisting ->](../../developer/security/network-security.md)
{% endhint %}

{% hint style="success" %}
After setting permissions in your data source, move on to [Configuration ->](../configuration/)
{% endhint %}
