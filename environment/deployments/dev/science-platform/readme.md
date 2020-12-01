# Dev Science Platform Build

This example illustrates how to use the `modules` directory to build a project and add in additional services like GKE and Filestore.

## Requirements

| Name | Version |
|------|---------|
| google | ~> 3.1 |
| google-beta | ~> 3.1 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The api to activate for the GCP project | `list(string)` | <pre>[<br>  "compute.googleapis.com"<br>]</pre> | no |
| application\_name | The name of application where GCP resources relate | `string` | n/a | yes |
| billing\_account | The ID of the billing account to associated this project with | `string` | n/a | yes |
| budget\_amount | The amount to use for the budget | `number` | `100` | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | <pre>{<br>  "environment": "environment",<br>  "owner": "owner_here"<br>}</pre> | no |
| cost\_centre | The cost centre that links to the application | `string` | n/a | yes |
| default\_region | The default region to place subnetwork | `string` | `"us-west1"` | no |
| default\_service\_account | Project default service account setting: can be one of delete, deprivilege, disable, or keep. | `string` | `"keep"` | no |
| environment | The environment the single project belongs to | `string` | n/a | yes |
| fileshare\_capacity | File share capacity in GiB. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier. | `number` | `2660` | no |
| fileshare\_name | The name of the fileshare (16 characters or less) | `string` | `"share1"` | no |
| folder\_id | The folder id where project will be created | `string` | n/a | yes |
| modes | IP versions for which the instance has IP addresses assigned. Each value may be one of ADDRESS\_MODE\_UNSPECIFIED, MODE\_IPV4, and MODE\_IPV6. | `list(string)` | <pre>[<br>  "MODE_IPV4"<br>]</pre> | no |
| name | The resource name of the instance. | `string` | `"test-instance"` | no |
| network\_name | Name of the VPC | `string` | `"custom-vpc"` | no |
| node\_pools\_labels | Map of maps containing node labels by node-pool name | `map(map(string))` | <pre>{<br>  "all": {<br>    "environment": "environment_here",<br>    "owner": "owner_here"<br>  }<br>}</pre> | no |
| org\_id | The organization id for the associated services | `string` | n/a | yes |
| owner | The owner of the project. | `string` | n/a | yes |
| project\_iam\_permissions | List of permissions granted to the group | `list(string)` | <pre>[<br>  "roles/monitoring.admin",<br>  "roles/storage.admin",<br>  "roles/container.clusterAdmin",<br>  "roles/container.admin",<br>  "roles/compute.instanceAdmin",<br>  "roles/logging.admin",<br>  "roles/file.editor"<br>]</pre> | no |
| project\_prefix | The name of the GCP project | `string` | n/a | yes |
| routing\_mode | Type of routing mode. Can be GLOBAL or REGIONAL | `string` | `"REGIONAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | <pre>{<br>  "subnet-01": [<br>    {<br>      "ip_cidr_range": "192.168.64.0/24",<br>      "range_name": "subnet-01-secondary-01"<br>    }<br>  ]<br>}</pre> | no |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| subnets | The list of subnets being created | `list(map(string))` | <pre>[<br>  {<br>    "subnet_ip": "10.10.10.0/24",<br>    "subnet_name": "subnet-01",<br>    "subnet_region": "us-central1"<br>  }<br>]</pre> | no |
| tier | The service tier of the instance. Possible values are TIER\_UNSPECIFIED, STANDARD, PREMIUM, BASIC\_HDD, BASIC\_SSD, and HIGH\_SCALE\_SSD. | `string` | `"STANDARD"` | no |
| vpc\_type | The type of VPC to attach the project to. Possible options are base or null. Default is null. | `string` | `""` | no |
| zone | The name of the Filestore zone of the instance | `string` | `"us-central1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| budget\_name | The name of the budget if created |
| enabled\_apis | Enabled APIs in the project |
| network | The name of the VPC being created |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| project\_id | The ID of the created project. |
| project\_name | The name of the created project |
| project\_number | The number of the created project |
| subnets\_self\_links | The self-links of subnets being created |