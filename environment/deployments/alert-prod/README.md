# Terraform Module for Alert Production GCP Project

These Terraform modules deploy projects and resources under the Alert Production folder.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alertprod_admin_group"></a> [alertprod\_admin\_group](#module\_alertprod\_admin\_group) | ../../../modules/google_groups | n/a |
| <a name="module_iam_admin"></a> [iam\_admin](#module\_iam\_admin) | ../../../modules/iam | n/a |
| <a name="module_project_factory"></a> [project\_factory](#module\_project\_factory) | ../../../modules/project_vpc | n/a |
| <a name="module_service_account_cluster"></a> [service\_account\_cluster](#module\_service\_account\_cluster) | terraform-google-modules/service-accounts/google | ~> 2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | The api to activate for the GCP project | `list(string)` | <pre>[<br>  "compute.googleapis.com",<br>  "container.googleapis.com",<br>  "stackdriver.googleapis.com",<br>  "file.googleapis.com",<br>  "storage.googleapis.com",<br>  "billingbudgets.googleapis.com",<br>  "sql-component.googleapis.com",<br>  "servicenetworking.googleapis.com",<br>  "iap.googleapis.com"<br>]</pre> | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of application where GCP resources relate | `string` | `"science_platform"` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associated this project with | `string` | `"01122E-72D62B-0B0581"` | no |
| <a name="input_budget_alert_spent_percents"></a> [budget\_alert\_spent\_percents](#input\_budget\_alert\_spent\_percents) | The list of percentages of the budget to alert on | `list(number)` | <pre>[<br>  0.7,<br>  0.8,<br>  0.9,<br>  1<br>]</pre> | no |
| <a name="input_budget_amount"></a> [budget\_amount](#input\_budget\_amount) | The amount to use for the budget | `number` | `1000` | no |
| <a name="input_customer_id"></a> [customer\_id](#input\_customer\_id) | Customer ID of the organization to create the group in. One of domain or customer\_id must be specified | `string` | `""` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | The default region to place subnetwork | `string` | `"us-central1"` | no |
| <a name="input_default_service_account"></a> [default\_service\_account](#input\_default\_service\_account) | Project default service account setting: can be one of delete, deprivilege, disable, or keep. | `string` | `"keep"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the group | `string` | `""` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the group | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain of the organization to create the group in. One of domain or customer\_id must be specified | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the single project belongs to | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The folder id where project will be created | `string` | n/a | yes |
| <a name="input_id"></a> [id](#input\_id) | ID of the group. For Google-managed entities, the ID must be the email address the group | `any` | n/a | yes |
| <a name="input_managers"></a> [managers](#input\_managers) | Managers of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account 
| `list` | `[]` | no |
| <a name="input_members"></a> [members](#input\_members) | Members of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | `list` | `[]` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the VPC | `string` | `"custom-vpc"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | The organization id for the associated services | `string` | `"288991023210"` | no |
| <a name="input_owners"></a> [owners](#input\_owners) | Owners of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account | `list` | `[]` | no |
| <a name="input_project_iam_permissions"></a> [project\_iam\_permissions](#input\_project\_iam\_permissions) | List of permissions granted to the group | `list(string)` | <pre>[<br>  "roles/cloudsql.admin",<br>  "roles/iap.tunnelResourceAccessor",<br>  "roles/iam.serviceAccountUser",<br>  "roles/monitoring.admin",<br>  "roles/storage.admin",<br>  "roles/container.clusterAdmin",<br>  "roles/container.admin",<br>  "roles/compute.instanceAdmin.v1",<br>  "roles/logging.admin",<br>  "roles/file.editor",<br>  "roles/compute.networkAdmin",<br>  "roles/compute.securityAdmin"<br>]</pre> | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | Type of routing mode. Can be GLOBAL or REGIONAL | `string` | `"GLOBAL"` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | <pre>{<br>  "subnet-01": [<br>    {<br>      "ip_cidr_range": "192.168.64.0/24",<br>      "range_name": "subnet-01-secondary-01"<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_skip_gcloud_download"></a> [skip\_gcloud\_download](#input\_skip\_gcloud\_download) | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets being created | `list(map(string))` | <pre>[<br>  {<br>    "subnet_ip": "10.10.10.0/24",<br>    "subnet_name": "subnet-01",<br>    "subnet_region": "us-central1"<br>  }<br>]</pre> | no |
| <a name="input_vpc_type"></a> [vpc\_type](#input\_vpc\_type) | The type of VPC to attach the project to. Possible options are base or null. Default is null. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budget_name"></a> [budget\_name](#output\_budget\_name) | The name of the budget if created |
| <a name="output_enabled_apis"></a> [enabled\_apis](#output\_enabled\_apis) | Enabled APIs in the project |
| <a name="output_network"></a> [network](#output\_network) | The name of the VPC being created |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of the created project. |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The name of the created project |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | The number of the created project |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | The self-links of subnets being created |