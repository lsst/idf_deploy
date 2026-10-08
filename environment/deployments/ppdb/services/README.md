# PPDB services

## Sentry DSN

Terraform creates a `sentry-dsn` secret in each environment's project and grants
read access to the Cloud Run runtime service accounts and the Dataflow worker
service accounts. The Cloud Run functions and services receive `SENTRY_DSN`
from the secret's `latest` version.

Secret values and versions are managed directly in Secret Manager. Do not put
the DSN in `.tfvars` files or create a Terraform-managed secret version.

### Initial setup

An operator must populate the secret before deploying the runtime references.
For each environment:

1. Initialize Terraform in this directory with the environment's services
   backend (`bucket=lsst-terraform-state`, `prefix=ppdb/<environment>/services`).
2. Create the secret and its access grants with a targeted apply, using the
   matching `../env/<environment>-services.tfvars` file and targeting
   `google_secret_manager_secret.sentry_dsn` and
   `google_secret_manager_secret_iam_member.sentry_dsn_accessor`.
3. Add the DSN as a secret version in the environment's project. For example,
   use a local file containing only the DSN, without a trailing newline:

   ```sh
   gcloud secrets versions add sentry-dsn \
     --project=<environment-project-id> \
     --data-file=<local-dsn-file>
   ```

4. Run the full services deployment through the environment's Terraform workflow.
