# Panda Build

This example illustrates how to use the `modules` directory to build a project and add in additional services like GKE, VM Instances, Firewalls and Filestore.

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
| activate\_apis | The api to activate for the GCP project | `list(string)` | <pre>[<br>  "compute.googleapis.com",<br>  "container.googleapis.com",<br>  "stackdriver.googleapis.com",<br>  "file.googleapis.com",<br> 
 "storage.googleapis.com",<br>  "billingbudgets.googleapis.com",<br>  "servicenetworking.googleapis.com"<br>]</pre> | no |
| address\_count | The number of reserved IP addresses needed | `number` | `1` | no |
| address\_labels | Labels to add to the reserved IP address | `map(string)` | `{}` | no |
| address\_name | The name to give to the reserved IP address. | `string` | `"nat-external-address"` | no | 
| address\_type | The type of address to attach to the NAT. Options are `EXTERNAL` or `INTERNAL` | `string` 
| `"EXTERNAL"` | no |
| application\_name | The name of application where GCP resources relate | `string` | `"science_platform"` | no |
| billing\_account | The ID of the billing account to associated this project with | `string` | `"01122E-72D62B-0B0581"` | no |
| budget\_alert\_spent\_percents | The list of percentages of the budget to alert on | `list(number)` | <pre>[<br>  0.7,<br>  0.8,<br>  0.9,<br>  1<br>]</pre> | no |
| budget\_amount | The amount to use for the budget | `number` | `1000` | no |
| custom\_rules | List of custom rule definitions (refer to variables file for syntax). | <pre>map(object({<br>    description          = string<br>    direction            = string<br>    action               = string # (allow|deny)<br>    ranges               = list(string)<br>    sources              = list(string)<br> 
   targets              = list(string)<br>    use_service_accounts = bool<br>    rules = list(object({<br>  
    protocol = string<br>      ports    = list(string)<br>    }))<br>    extra_attributes = map(string)<br> 
 }))</pre> | `{}` | no |
| custom\_rules2 | List of custom rule definitions (refer to variables file for syntax). | <pre>map(object({<br>    description          = string<br>    direction            = string<br>    action               = string # (allow|deny)<br>    ranges               = list(string)<br>    sources              = list(string)<br>    targets              = list(string)<br>    use_service_accounts = bool<br>    rules = list(object({<br> 
     protocol = string<br>      ports    = list(string)<br>    }))<br>    extra_attributes = map(string)<br>  }))</pre> | `{}` | no |
| default\_region | The default region to place subnetwork | `string` | `"us-central1"` | no |
| default\_service\_account | Project default service account setting: can be one of delete, deprivilege, disable, or keep. | `string` | `"keep"` | no |
| environment | The environment the single project belongs to | `string` | n/a | yes |
| folder\_id | The folder id where project will be created | `string` | n/a | yes |
| image | The image from which to initialize this disk. | `string` | n/a | yes |
| log\_config\_enable | n/a | `bool` | `false` | no |
| log\_config\_filter | Specified the desired filtering of logs on this NAT. Possible values are `ERRORS_ONLY`, `TRANSLATIOSN_ONLY`, `ALL` | `string` | `"ERRORS_ONLY"` | no |
| machine\_type | The machine type to create | `string` | `"e2-medium"` | no |
| members | List of IAM resources to allow using the IAP tunnel. | `list(string)` | n/a | yes |
| nat\_name | Name of the NAT service. Name must be 1-63 characters. | `string` | `"cloud-nat"` | no |      
| network\_name | Name of the VPC | `string` | `"custom-vpc"` | no |
| num\_instances | Number of instances to create. This value is ignored if static\_ips is provided. | `string` | `"1"` | no |
| org\_id | The organization id for the associated services | `string` | `"288991023210"` | no |
| project\_iam\_permissions | List of permissions granted to the group | `list(string)` | <pre>[<br>  "roles/monitoring.admin",<br>  "roles/storage.admin",<br>  "roles/container.clusterAdmin",<br>  "roles/container.admin",<br>  "roles/compute.instanceAdmin.v1",<br>  "roles/logging.admin",<br>  "roles/file.editor",<br>  "roles/compute.networkAdmin",<br>  "roles/compute.securityAdmin",<br>  "roles/iam.serviceAccountUser",<br>  "roles/iap.tunnelResourceAccessor"<br>]</pre> | no |
| router\_name | The name to give to the router | `string` | `"nat-router"` | no |
| routing\_mode | Type of routing mode. Can be GLOBAL or REGIONAL | `string` | `"GLOBAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | <pre>{<br>  "subnet-01": [<br>    {<br>      "ip_cidr_range": "192.168.64.0/24",<br>      "range_name": "subnet-01-secondary-01"<br>    }<br>  ]<br>}</pre> | no |
| size | The size of the image in gigabytes. | `number` | `50` | no |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| subnets | The list of subnets being created | `list(map(string))` | <pre>[<br>  {<br>    "subnet_ip": "10.10.10.0/24",<br>    "subnet_name": "subnet-01",<br>    "subnet_region": "us-central1"<br>  }<br>]</pre> | no |
| tags | A list of network tags to attach to the instance | `list(string)` | `[]` | no |
| type | The GCE disk type. Maybe `pd-standard`,`pd-balanced`, `pd-ssd` | `string` | `"pd-standard"` | no | 
| vpc\_type | The type of VPC to attach the project to. Possible options are base or null. Default is null. 
| `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| address\_name | The name of the static ip address |
| budget\_name | The name of the budget if created |
| enabled\_apis | Enabled APIs in the project |
| instance\_name | Name of the instance |
| instance\_zone | The zone the instance was deployed |
| nat\_id | The self ID of the NAT |
| nat\_name | The name of the NAT |
| network | The name of the VPC being created |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| project\_id | The ID of the created project. |
| project\_name | The name of the created project |
| project\_number | The number of the created project |
| reserved\_ip\_address | The static external IP address represented by the resource |
| subnets\_self\_links | The self-links of subnets being created |