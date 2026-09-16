<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.26.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 6.26.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_iam_admin"></a> [iam\_admin](#module\_iam\_admin) | ../../../modules/iam | n/a |
| <a name="module_project_factory"></a> [project\_factory](#module\_project\_factory) | ../../../modules/project_vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | The api to activate for the GCP project | `list(string)` | <pre>[<br/>  "bigquery.googleapis.com",<br/>  "billingbudgets.googleapis.com",<br/>  "cloudfunctions.googleapis.com",<br/>  "dataproc.googleapis.com",<br/>  "eventarc.googleapis.com",<br/>  "logging.googleapis.com",<br/>  "monitoring.googleapis.com",<br/>  "pubsub.googleapis.com",<br/>  "run.googleapis.com",<br/>  "secretmanager.googleapis.com",<br/>  "storage.googleapis.com"<br/>]</pre> | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of application where GCP resources relate | `string` | `"ppdb"` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associated this project with | `string` | `"0157B0-777456-72D737"` | no |
| <a name="input_budget_alert_spent_percents"></a> [budget\_alert\_spent\_percents](#input\_budget\_alert\_spent\_percents) | The list of percentages of the budget to alert on | `list(number)` | <pre>[<br/>  0.7,<br/>  0.8,<br/>  0.9,<br/>  1<br/>]</pre> | no |
| <a name="input_budget_amount"></a> [budget\_amount](#input\_budget\_amount) | The amount to use for the budget | `number` | `1000` | no |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | The default region to place subnetwork | `string` | `"us-central1"` | no |
| <a name="input_default_service_account"></a> [default\_service\_account](#input\_default\_service\_account) | Project default service account setting: can be one of delete, deprivilege, disable, or keep. | `string` | `"keep"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the single project belongs to | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The folder id where project will be created | `string` | `"441200790164"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the VPC | `string` | `"custom-vpc"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | The organization id for the associated services | `string` | `"288991023210"` | no |
| <a name="input_project_iam_permissions"></a> [project\_iam\_permissions](#input\_project\_iam\_permissions) | List of permissions granted to the group | `list(string)` | <pre>[<br/>  "roles/bigquery.admin",<br/>  "roles/dataproc.admin",<br/>  "roles/logging.admin",<br/>  "roles/monitoring.admin",<br/>  "roles/run.admin",<br/>  "roles/storage.admin",<br/>  "roles/compute.securityAdmin"<br/>]</pre> | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | Type of routing mode. Can be GLOBAL or REGIONAL | `string` | `"GLOBAL"` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | <pre>{<br/>  "subnet-01": [<br/>    {<br/>      "ip_cidr_range": "192.168.64.0/24",<br/>      "range_name": "subnet-01-secondary-01"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets being created | `list(map(string))` | <pre>[<br/>  {<br/>    "subnet_ip": "10.10.10.0/24",<br/>    "subnet_name": "subnet-01",<br/>    "subnet_region": "us-central1"<br/>  }<br/>]</pre> | no |
| <a name="input_vpc_type"></a> [vpc\_type](#input\_vpc\_type) | The type of VPC to attach the project to. Possible options are base or null. Default is null. | `string` | `""` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_budget_name"></a> [budget\_name](#output\_budget\_name) | The name of the budget if created |
| <a name="output_enabled_apis"></a> [enabled\_apis](#output\_enabled\_apis) | Enabled APIs in the project |
| <a name="output_network"></a> [network](#output\_network) | The name of the VPC being created |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of the created project. |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The name of the created project |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | The number of the created project |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | The self-links of subnets being created |
<!-- END_TF_DOCS -->