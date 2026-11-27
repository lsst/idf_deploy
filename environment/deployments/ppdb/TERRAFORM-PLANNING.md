# PPDB dev Terraform plan and apply access

Users need membership in both groups:

- `gcp-ppdb-dev-deployers@lsst.cloud` receives Terraform backend access
  from [`foundation/1-org-b/ppdb-dev-terraform-appliers.tf`](../../foundation/1-org-b/ppdb-dev-terraform-appliers.tf).
- `gcp-ppdb-administrators@lsst.cloud` receives infrastructure permissions from
  the PPDB project stack, including the dev-only additions for networking,
  private service access, project IAM, API activation, builds, Eventarc,
  Scheduler, Workflows, project metadata and the single-project budget.

Provision backend grants through the existing foundation `1-org-b` workflow
with `1-org-b.tfvars`. Apply the PPDB dev project stack with an existing
privileged deployment identity to bootstrap the additional administrator
permissions before group members use them. Both workflows are triggered by
changes to their respective tfvars files.

These grants operate on the existing PPDB dev project. Creating a replacement
project or changing its parent or billing account requires the corresponding
folder and billing-account privileges, which are outside these grants.

In `gs://lsst-terraform-state`, object contents can be read only at:

| Object | Access and purpose |
| --- | --- |
| `ppdb/dev/default.tfstate` | Read/write: project stack and remote state |
| `ppdb/dev/cloudsql/default.tfstate` | Read/write: Cloud SQL stack and remote state |
| `ppdb/dev/services/default.tfstate` | Read/write: services stack |
| `science-platform/dev/cloudsql/default.tfstate` | Read-only: services stack's BigQuery TAP service account dependency |

The appliers group can create, overwrite and delete the three PPDB state files
and their `default.tflock` objects. Science Platform state remains read-only.
Other workspaces are excluded. State access exposes the complete state
contents, including any sensitive values stored there.

Terraform's GCS backend lists workspaces during initialization. The bucket-level
`roles/storage.legacyBucketReader` grant exposes object names and metadata across
the state bucket; GCS IAM cannot restrict `storage.objects.list` by prefix. Reads
of object contents remain limited to the exact state and lock names above.
Conditional bucket bindings require uniform bucket-level access on the existing
state bucket.

The administrator group's existing `roles/storage.admin` grant on the PPDB
project covers the services stack's buckets and placeholder source ZIP objects.
The appliers group receives no infrastructure or application-bucket grants.

With Google Application Default Credentials for a member of both groups, run each stack
from the repository root:

```bash
terraform -chdir=environment/deployments/ppdb init \
  -backend-config=bucket=lsst-terraform-state -backend-config=prefix=ppdb/dev
terraform -chdir=environment/deployments/ppdb plan -var-file=env/dev.tfvars

terraform -chdir=environment/deployments/ppdb/cloudsql init \
  -backend-config=bucket=lsst-terraform-state -backend-config=prefix=ppdb/dev/cloudsql
terraform -chdir=environment/deployments/ppdb/cloudsql plan -var-file=../env/dev-cloudsql.tfvars

terraform -chdir=environment/deployments/ppdb/services init \
  -backend-config=bucket=lsst-terraform-state -backend-config=prefix=ppdb/dev/services
terraform -chdir=environment/deployments/ppdb/services plan -var-file=../env/dev-services.tfvars
```

After reviewing a plan, use `terraform apply` with the same directory and
`-var-file` argument to apply it. Use the `default` workspace and leave locking
enabled. New infrastructure resource types may require administrator role
updates; new state dependencies may require backend grant updates.
