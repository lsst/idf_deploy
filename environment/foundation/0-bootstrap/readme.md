# 0-bootstrap

The purpose of this step is to bootstrap a GCP organization, creating all the required resources & permissions to start using the Cloud Foundation Toolkit (CFT). This step also configures Cloud Build & Cloud Source Repos for foundations code in subsequent stages.

## Prerequisites

1. A GCP [Organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization)
1. A GCP [Billing Account](https://cloud.google.com/billing/docs/how-to/manage-billing-account)
1. Cloud Identity / G Suite Google Groups for Organization Admins and Billing Admins already created.
1. Membership in the `group_org_admins` group for the user running Terraform.
1. Grant the roles mentioned in bootstrap [README.md](https://github.com/terraform-google-modules/terraform-google-bootstrap#permissions), as well as `roles/resourcemanager.folderCreator` for the user running the step.

## Usage

1. Clone the repo: `git clone https://github.com/Burwood/terraform-gcp-greenfield.git`
    (Optional) 1. Change into the correct branch with `git checkout [branch_name]`
1. Change into 0-bootstrap folder
1. Copy tfvars by running `cp terraform.tfvars.example terraform.tfvars` and update `terraform.tfvars` with values from your environment.
1. Run `terraform init`
1. Run `terraform plan` and review output
1. Run `terraform apply`
    1. <b>WARNING</b>
    If using GitHub for source code repo, you must <b>MANUALLY</b> create the connector to the repo. `Terraform` will fail. Once the connector is built re-run and create the Cloud Build triggers.
1. Copy the backend by running `cp backend.tf.example backend.tf` and update `backend.tf` with your bucket from the apply step (The value from `terraform output gcs_bucket_tfstate`)
1. Re-run `terraform init` agree to copy state to gcs when prompted
    1. (Optional) Run terraform apply to verify state is configured cor

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.1 |
| google-beta | ~> 3.1 |
| random | ~> 2.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | List of APIs to enable in the seed project | `list(string)` | <pre>[<br>  "cloudresourcemanager.googleapis.com",<br>  "cloudbilling.googleapis.com",<br>  "billingbudgets.googleapis.com",<br>  "iam.googleapis.com",<br>  "admin.googleapis.com",<br>  "cloudbuild.googleapis.com",<br>  "serviceusage.googleapis.com",<br>  "servicenetworking.googleapis.com",<br>  "compute.googleapis.com",<br>  "logging.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "storage-api.googleapis.com",<br>  "container.googleapis.com"<br>]</pre> | no |
| branch | What branch to pull from | `string` | `"^master$"` | no |
| cloud\_triggers | Name of triggers to deploy | `list(string)` | <pre>[<br>  "1-org",<br>  "1-org-b",<br>  "2-networks"<br>]</pre> | no |
| cloudbuild\_org\_iam\_permissions | List of permissions granted to the CloudBuild service account. | `list(string)` | <pre>[<br>  "roles/resourcemanager.organizationAdmin",<br>  "roles/billing.user",<br>  "roles/pubsub.admin",<br>  "roles/iam.organizationRoleAdmin",<br>  "roles/resourcemanager.folderAdmin",<br>  "roles/orgpolicy.policyAdmin",<br>  "roles/resourcemanager.projectCreator",<br>  "roles/compute.xpnAdmin",<br>  "roles/compute.networkAdmin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/resourcemanager.projectIamAdmin",<br>  "roles/storage.admin",<br>  "roles/logging.admin"<br>]</pre> | no |
| cloudops\_triggers | Name of triggers to deploy | `list(string)` | <pre>[<br>  "project-apply"<br>]</pre> | no |
| deployment\_dir | The directory that has the deployments / tfvars | `string` | `"projects"` | no |
| disable\_services\_on\_destroy | Whether project services will be disabled when the resources are destroyed | `string` | `true` | no |
| disable\_trigger | To enable or disable the trigger for automatic deployment | `string` | `false` | no |
| filename\_path | The file path name of where the cloudbuild yaml files are located | `string` | `"cloudbuild"` | no |
| github\_name | Name of the repository. | `string` | n/a | yes |
| github\_owner | Owner of the repository. | `string` | n/a | yes |
| modules\_dir | The directory that has the modules to deploy | `string` | `"project_iam_vpc"` | no |
| org\_admins\_org\_iam\_permissions | List of permissions granted to the group supplied in group\_org\_admins variable across the GCP organization. | `list(string)` | <pre>[<br>  "roles/billing.user",<br>  "roles/resourcemanager.organizationAdmin"<br>]</pre> | no |
| parent\_folder | Optional - if using a folder for testing. | `string` | `""` | no |
| project\_labels | Labels to apply to the project. | `map(string)` | <pre>{<br>  "billing_code": "012345",<br>  "envrionment": "prod",<br>  "owner": "its"<br>}</pre> | no |
| project\_prefix | Name prefix to use for projects created. | `string` | `"automation"` | no |
| random\_project\_id | Adds a suffix of 4 random characters to the `project_id` | `string` | `true` | no |
| sa\_enable\_impersonation | Allow org\_admins group to impersonate service account & enable APIs required. | `bool` | `false` | no |
| seed\_folder\_name | Name of the folder that will contain the `Cloud Control Plane` projects. | `string` | `"Administration"` | no |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| storage\_bucket\_labels | Labels to apply to the storage bucket. | `map(string)` | `{}` | no |
| terraform\_tag | Dockerhub tag value for Terraform container | `string` | `"latest"` | no |
| tfvars\_name | Name of the tfvars file | `string` | `"new-project"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudbuild\_project\_id | Project where service accounts and core APIs will be enabled. |
| cloudbuild\_service\_account | The Cloud Build service account |
| gcs\_bucket\_tfstate | Bucket used for storing terraform state for foundations pipelines in seed project. |
| seed\_folder\_id | The folder id of the seed folder |