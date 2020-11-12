# Overview
This example demonstrates the simplest usage of the GCP organization bootstrap module, accepting default values for the module variables.

The purpose of this module is to help bootstrap a GCP organization.

Google module can be found [here](https://github.com/terraform-google-modules/terraform-google-bootstrap).

## Features

The Organization Bootstrap module will take the following actions:

1. Create a new GCP seed project using project_prefix. Use project_id if you need to use custom project ID.
1. Enable APIs in the seed project using activate_apis
1. Create a new service account for terraform in seed project
1. Create GCS bucket for Terraform state and grant access to service account
1. Grant IAM permissions required for CFT modules & Organization setup
    1. Overwrite organization wide project creator and billing account creator roles
    1. Grant Organization permissions to service account using sa_org_iam_permissions
    1. Grant access to billing account for service account
    1. Grant Organization permissions to group_org_admins using org_admins_org_iam_permissions
    1. Grant billing permissions to group_billing_admins
    1. (optional) Permissions required for service account impersonation using sa_enable_impersonation

## Requirements

### Permissions

* `roles/resourcemanager.organizationAdmin` on GCP Organization
* `roels/billing.admin` on supplied billing account
* Account running terraform should be a member of group provided in `group_org_admins` variable, otherwise they will loose `roles/resourcemanager.projectCreator` access. Additional member can be added by using the `org_project_creators` variable.
## Providers

| Name | Version |
|------|---------|
| google | ~> 3.43.0 |
| google-beta | ~> 3.43.0 |
| null | ~> 2.1 |
| random | ~> 2.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | n/a | `list(string)` | <pre>[<br>  "serviceusage.googleapis.com",<br>  "servicenetworking.googleapis.com",<br>  "compute.googleapis.com",<br>  "logging.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "cloudresourcemanager.googleapis.com",<br>  "cloudbilling.googleapis.com",<br>  "iam.googleapis.com",<br>  "admin.googleapis.com",<br>  "appengine.googleapis.com",<br>  "storage-api.googleapis.com",<br>  "monitoring.googleapis.com",<br>  "container.googleapis.com"<br>]</pre> | no |
| billing\_account | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| default\_region | Default region to create resources where applicable. | `string` | `"us-central1"` | no |
| folder\_id | The ID of a folder to host this project | `string` | `""` | no |
| group\_billing\_admins | Google Group for GCP Billing Administrators | `string` | n/a | yes |
| group\_org\_admins | Google Group for GCP Organization Administrators | `string` | n/a | yes |
| org\_id | GCP Organization ID | `string` | n/a | yes |
| org\_project\_creators | Additional list of members to have project creator role accross the organization. Prefix of group: user: or 
serviceAccount: is required. | `list(string)` | `[]` | no |
| project\_id | Custom project ID to use for project created. | `string` | `""` | no |
| project\_prefix | n/a | `string` | `"domain"` | no |

## Outputs

| Name | Description |
|------|-------------|
| gcs\_bucket\_tfstate | Bucket used for storing terraform state for foundations pipelines in seed project. |
| seed\_project\_id | Project where service accounts and core APIs will be enabled. |
| terraform\_sa\_email | Email for privileged service account for Terraform. |
| terraform\_sa\_name | Fully qualified name for privileged service account for Terraform. |