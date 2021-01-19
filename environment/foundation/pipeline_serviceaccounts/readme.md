# Create Service Account per Pipeline

This terraform module will create a new service account for each pipeline. Having dedicated service accounts per pipeline reduces the blast radius so one service account cannot affect other GCP projects and pipelines.

### Process
* The terraform module will create a new service account in the `rubin-automation-prod` project.
* Next, IAM permissions are then assigned to the desired projects.
* Then, IAM permissions are added to the Terraform State bucket so the Service Account can read and write to the bucket for the terraform state.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| qserv\_dev\_gke\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| qserv\_dev\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| qserv\_int\_gke\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| qserv\_int\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| rsp\_dev\_gke\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| rsp\_dev\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| rsp\_int\_gke\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| rsp\_int\_names | Names of the service accounts to create. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| qserv\_dev\_email | The service account email. |
| qserv\_dev\_gke\_email | The service account email. |
| qserv\_dev\_gke\_iam\_email | The service account IAM-format email. |
| qserv\_dev\_iam\_email | The service account IAM-format email. |
| qserv\_int\_email | The service account email. |
| qserv\_int\_gke\_email | The service account email. |
| qserv\_int\_gke\_iam\_email | The service account IAM-format email. |
| qserv\_int\_iam\_email | The service account IAM-format email. |
| rsp\_dev\_email | The service account email. |
| rsp\_dev\_gke\_email | The service account email. |
| rsp\_dev\_gke\_iam\_email | The service account IAM-format email. |
| rsp\_dev\_iam\_email | The service account IAM-format email. |
| rsp\_int\_email | The service account email. |
| rsp\_int\_gke\_email | The service account email. |
| rsp\_int\_gke\_iam\_email | The service account IAM-format email. |
| rsp\_int\_iam\_email | The service account IAM-format email. |