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
|------|-------------|------|---------|:--------:|
| activate\_apis\_audit\_log\_project | What APIs to activate for this project. | `list(string)` | <pre>[<br>  "logging.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "stackdriver.googleapis.com",<br>  "pubsub.googleapis.com",<br>  "securitycenter.googleapis.com",<br>  "billingbudgets.googleapis.com"<br>]</pre> | no |
| activate\_apis\_billing\_project | What APIs to activate for this project. | `list(string)` | <pre>[<br>  "logging.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "billingbudgets.googleapis.com"<br>]</pre> | no |
| activate\_apis\_monitoring\_project | What APIs to activate for this project. | `list(string)` | <pre>[<br>  "logging.googleapis.com",<br>  "monitoring.googleapis.com",<br>  "stackdriver.googleapis.com",<br>  "billingbudgets.googleapis.com"<br>]</pre> | no |
| activate\_apis\_shared\_services\_project | What APIs to activate for this project. | `list(string)` | <pre>[<br>  "compute.googleapis.com",<br>  "container.googleapis.com",<br>  "stackdriver.googleapis.com",<br>  "dns.googleapis.com",<br>  "servicenetworking.googleapis.com",<br>  "billingbudgets.googleapis.com"<br>]</pre> | no |
| audit\_log\_project\_name | The name to append to the var.project\_prefix value. | `string` | `"infosec"` | no |
| auto\_create\_network | Create the default network | `bool` | `false` | no |
| billing\_project\_name | The name to append to the var.project\_prefix value. | `string` | `"billing-logs"` | no |
| default\_service\_account | Project default service account setting: can be one of delete, depriviledge, or keep. | `string` | `"depriviledge"` | no |
| enable\_audit\_log\_project | Option to enable or disable the creation of the project for: Audit Log Project | `number` | `1` | no |
| enable\_billing\_project | Option to enable or disable the creation of the project for: Billing Project. | `number` | `1` | no |
| enable\_monitoring\_project | Option to enable or disable the creation of the project for: Monitoring Project. | `number` | `1` | no |
| enable\_shared\_services\_project | Option to enable or disable the creation of the project for: Shared Host Project | `number` | `1` | no |
| folder\_names | Folder names. | `list(string)` | <pre>[<br>  "Sensitive",<br>  "Learn",<br>  "Researchers"<br>]</pre> | no |
| include\_children | To include all child objects in sink. | `string` | `"true"` | no |
| label\_environment | Project label for the environment | `string` | `"prod"` | no |
| log\_sink\_name\_pubsub | Name of the pub/sub log sink | `string` | `"pubsub_org_sink"` | no |
| log\_sink\_name\_storage | Name of the storage log sink | `string` | `"storage_org_sink"` | no |
| monitoring\_project\_name | The name to append to the var.project\_prefix value. | `string` | `"monitoring"` | no |
| org\_admins\_org\_iam\_permissions | List of permissions granted to the group supplied in group\_org\_admins variable across the GCP organization. | `list(string)` | <pre>[<br>  "roles/billing.user",<br>  "roles/resourcemanager.organizationAdmin",<br>  "roles/resourcemanager.folderAdmin",<br>  "roles/resourcemanager.projectCreator",<br>  "roles/iam.organizationRoleAdmin"<br>]</pre> | no |
| org\_audit\_log\_project\_alert\_pubsub\_topic | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project. | `string` | `null` | no |
| org\_audit\_log\_project\_alert\_spent\_percents | A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project. | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| org\_audit\_log\_project\_budget\_amount | The amount to use as the budget for the org billing logs project. | `number` | `1000` | no |
| org\_billing\_logs\_project\_alert\_pubsub\_topic | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project. | `string` | `null` | no |
| org\_billing\_logs\_project\_alert\_spent\_percents | A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project. | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| org\_billing\_logs\_project\_budget\_amount | The amount to use as the budget for the org billing logs project. | `number` | `1000` | no |
| org\_monitoring\_project\_alert\_pubsub\_topic | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project. | `string` | `null` | no |
| org\_monitoring\_project\_alert\_spent\_percents | A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project. | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| org\_monitoring\_project\_budget\_amount | The amount to use as the budget for the org billing logs project. | `number` | `1000` | no |
| org\_network\_admins\_org\_iam\_permissions | List of permissions granted to the group supplied in group\_org\_admins variable across the GCP organization. | `list(string)` | <pre>[<br>  "roles/compute.networkAdmin",<br>  "roles/compute.xpnAdmin",<br>  "roles/resourcemanager.folderViewer",<br>  "roles/compute.networkUser"<br>]</pre> | no |
| org\_security\_admins\_org\_iam\_permissions | List of permissions granted to the group supplied in group\_org\_admins variable across the GCP organization. | `list(string)` | <pre>[<br>  "roles/compute.securityAdmin",<br>  "roles/orgpolicy.policyAdmin",<br>  "roles/orgpolicy.policyViewer",<br>  "roles/iam.securityReviewer",<br>  "roles/iam.organizationRoleViewer",<br>  "roles/resourcemanager.folderIamAdmin",<br>  "roles/logging.privateLogViewer",<br>  "roles/logging.configWriter",<br>  "roles/bigquery.dataViewer"<br>]</pre> | no |
| org\_shared\_services\_project\_alert\_pubsub\_topic | The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project. | `string` | `null` | no |
| org\_shared\_services\_project\_alert\_spent\_percents | A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project. | `list(number)` | <pre>[<br>  0.5,<br>  0.75,<br>  0.9,<br>  0.95<br>]</pre> | no |
| org\_shared\_services\_project\_budget\_amount | The amount to use as the budget for the org billing logs project. | `number` | `1000` | no |
| org\_viewer\_org\_iam\_permissions | List of permissions granted to the group supplied in group\_org\_admins variable across the GCP organization. | `list(string)` | <pre>[<br>  "roles/orgpolicy.policyViewer",<br>  "roles/iam.securityReviewer",<br>  "roles/iam.organizationRoleViewer",<br>  "roles/logging.privateLogViewer",<br>  "roles/bigquery.dataViewer",<br>  "roles/resourcemanager.folderViewer"<br>]</pre> | no |
| parent\_folder | Optional - if using a folder for testing. | `string` | `""` | no |
| project\_prefix | Adds a prefix to the core projects. | `string` | `"core"` | no |
| random\_project\_id | Adds a suffix of 4 random characters to the `project_id` | `bool` | `true` | no |
| resource\_region\_location\_restriction | The location to restrict where resources can be created from. | `list(string)` | <pre>[<br>  "in:us-locations"<br>]</pre> | no |
| scc\_notification\_subscription | Name of the pub/sub SCC notification subscription | `string` | `"sub-scc-notification"` | no |
| scc\_notification\_topic | Name of the pub/sub SCC notification topic | `string` | `"top-scc-notification"` | no |
| seed\_folder\_name | Folder ID that contains the `Cloud Control Plane` projects. | `string` | `""` | no |
| shared\_services\_project\_name | The name to append to the var.project\_prefix value. | `string` | `"shared-vpc"` | no |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| storage\_archive\_bucket\_name | The name for the bucket that will store archive of admin activity logs | `string` | `"archive_active_logs"` | no |
| storage\_class | Storage class | `string` | `"STANDARD"` | no |
| storage\_location | Region to put archive | `string` | `"US"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ids | Folder ids. |
| ids\_list | List of folder ids. |
| names | Folder names. |