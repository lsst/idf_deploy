# Terraform Module to create Service Account

This module allows easy creation of one or more service accounts, and granting them basic roles.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account\_id | If assigning billing role, specificy a billing account (default is to assign at the organizational level). | `string` | `""` | no |
| description | Descriptions of the created service accounts (defaults to no description) | `string` | `""` | no |
| display\_name | Display names of the created service accounts (defaults to 'Terraform-managed service account') | `string` | `"Terraform-managed service account"` | no |
| generate\_keys | Generate keys for service accounts. | `bool` | `false` | no |
| grant\_billing\_role | Grant billing user role. | `bool` | `false` | no |
| grant\_xpn\_roles | Grant roles for shared VPC management. | `bool` | `false` | no |
| names | Names of the service accounts to create. | `list(string)` | `[]` | no |
| org\_id | Id of the organization for org-level roles. | `string` | `""` | no |
| prefix | Prefix applied to service account names. | `string` | `"test-sa"` | no |
| project\_id | Project id where service account will be created. | `string` | n/a | yes |
| project\_roles | Common roles to apply to all service accounts, project=>role as elements. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| email | The service account email. |
| iam\_email | The service account IAM-format email. |