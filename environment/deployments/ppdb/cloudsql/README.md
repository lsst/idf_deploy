# PPDB CloudSQL

There are some things that we need to do manually before and after applying this Terraform config.

## Pre-provisioning

By default, our Google Cloud Organizational Policies do not let us provision CloudSQL db instances with public IPs.
The PPDB cloudsql instance needs a public IP because there are processes at USDF that must connect to it.

Override this Organizational Policy at the project level (replacing the project id as needed):

```console
$ gcloud resource-manager org-policies disable-enforce sql.restrictPublicIp --project ppdb-int-6c62
```

## Post-provisioning

### Re-enforce organizational policies

Now that we have provisioned the CloudSQL instance, we have to re-enforce the public IP policy (replace the project ID as needed):

```console
$ gcloud resource-manager org-policies delete sql.restrictPublicIp --project=ppdb-int-6c62
```

### Manual database setup

After this terraform is applied and the database instance and database are created, we need to manually run some SQL on the newly created instance.
This can be done locally via the [CloudSQL auth proxy](https://docs.cloud.google.com/sql/docs/mysql/connect-auth-proxy), or through the Google Cloud web console via the CloudSQL Studio.
Here is the [CloudSQL Studio link for the `int` environment, for example](https://console.cloud.google.com/sql/instances/ppdb-int/studio?project=ppdb-int-6c62).

* Get a session in the db either through the sql proxy or the CloudSQL Studio and run this sql:

```sql
-- This is the role that will own all of the PPDB database objects
CREATE ROLE ppdb NOLOGIN CREATEDB;

-- We have to allow the cloudsqlsuperuser role (who we're operating as) to
-- assume this role in order to grant it to other roles.
GRANT ppdb TO cloudsqlsuperuser;

-- Change the ownership of everything in the ppdb database to the ppdb user
ALTER DATABASE "ppdb" OWNER TO ppdb;
ALTER SCHEMA "public" OWNER to ppdb;

-- Allow anyone in the gcp-ppdb-administrators Google group to assume the ppdb
-- role
GRANT ppdb TO "gcp-ppdb-administrators@lsst.cloud";

-- The cloudsqlsuperuser role user no longer needs this. We can always grant
-- it again if we need to.
REVOKE ppdb FROM cloudsqlsuperuser;
```

## Doing anything else

Whenever you need to make manual changes to the contents of the DB instance from now on:
* Make sure your personal `@lsst.cloud` Google account is in the `gcp-ppdb-administrators` Google group
* Log in to the DB using your personal IAM user
* Assume the `ppdb` or `cloudsqlsuperuser` roles if you need to with `SET ROLE <role>`.
