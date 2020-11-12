# 1-org

The purpose of this step is to setup top level shared folders, monitoring & networking projects, org level logging and set baseline security settings through organizational policy.

## Prerequisites

1. 0-bootstrap executed successfully.

## Usage

1. Change into 1-org directory
1. Copy tfvars by running `cp terraform.tfvars.example terraform.tfvars` and update `terraform.tfvars` with values from your environment.
1. Push the changes back into the repo using `git add .` next `git commit -m "updated tfvars"`, then `git push origin [branch_name]`
    1. If your .gitignore is blocking `*.tfvars` then you'll need to force the update using `git add . -f`
1. This push will kickoff the CloudBuild trigger for `1-org` and start deploying

## Run Terraform Locally

1. Change into 1-org folder
1. Rename terraform.example.tfvars to terraform.tfvars and update the file with values from your environment and bootstrap.
1. Rename backend.tf.example backend.tf and update with your bucket from bootstrap.
1. Run terraform init
1. Run terraform plan and review output
1. Run terraform apply

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.1 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| auto\_create\_network | Create the default network | `bool` | `false` | no |
| billing\_account | The ID of the billing account to associate this project with | `string` | n/a | yes |
| default\_service\_account | Project default service account setting: can be one of delete, depriviledge, or keep. | `string` | `"keep"` | no |
| domain | The domain name (optional). | `string` | `""` | no |
| domains\_to\_allow | The list of domains to allow users from | `list(string)` | <pre>[<br>  "prorelativity.com"<br>]</pre> | no |
| folder\_names | Folder names. | `list(string)` | <pre>[<br>  "Sensitive",<br>  "Learn",<br>  "ITS",<br>  "For-Researchers"<br>]</pre> | no |
| gcp\_admin\_group | The org-level Google group name used for gcp-admin-group | `any` | n/a | yes |
| gcp\_billing\_admin\_group | The org-level Google group name used for gcp-billing-admin-group | `any` | n/a | yes |
| gcp\_network\_admin\_group | The org-level Google group name used for gcp-network-admin-group | `any` | n/a | yes |
| gcp\_security\_admin\_group | The org-level Google group name used for gcp-security-admin-group | `any` | n/a | yes |
| log\_sink\_name\_pubsub | Name of the pub/sub log sink | `string` | `"pubsub_org"` | no |
| log\_sink\_name\_storage | Name of the storage log sink | `string` | `"storage_org_sink"` | no |
| org\_id | The organization id for putting the policy | `any` | n/a | yes |
| organization\_one | Organization | `any` | n/a | yes |
| parent\_folder | Optional - if using a folder for testing. | `string` | `""` | no |
| random\_project\_id | Adds a suffix of 4 random characters to the `project_id` | `bool` | `true` | no |
| skip\_default\_network\_exclude\_folders | Set of folders to exclude from the skip default network policy | `set(string)` | `[]` | no |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| storage\_archive\_bucket\_name | The name for the bucket that will store archive of admin activity logs | `string` | `"archive_active_logs"` | no |

## Outputs

| Name | Description |
|------|-------------|
| email | The service account email. |
| iam\_email | The service account IAM-format email. |
| ids | Folder ids. |
| ids\_list | List of folder ids. |
| names | Folder names. |