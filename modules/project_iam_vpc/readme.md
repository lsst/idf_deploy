# Terraform Standard Project Module (Custome VPC)

This module creates a base GCP project. It will create a new GCP project, attach a billing account, assign a Google Group with the `roles/Editor` role, and assign a custom VPC.

The Custom VPC with IP address are deployed using the following subnet range: `	"10.128.0.0/16"`

## Usage

Full examples are in the [examples](./examples) folder.
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| google | ~> 3.1 |
| google-beta | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The api to activate for the GCP project | `list(string)` | <pre>[<br>  "compute.googleapis.com"<br>]</pre> | no |
| application\_name | The name of application where GCP resources relate | `string` | n/a | yes |
| billing\_account | The ID of the billing account to associated this project with | `string` | n/a | yes |
| cost\_centre | The cost centre that links to the application | `string` | n/a | yes |
| default\_region | The default region to place subnetwork | `string` | `"us-west1"` | no |
| default\_service\_account | Project default service account setting: can be one of delete, deprivilege, disable, or keep. | `string` | `"keep"` | no |
| environment | The environment the single project belongs to | `string` | n/a | yes |
| folder\_id | The folder id where project will be created | `string` | n/a | yes |
| group\_name | Name of the Google Group to assign to the project. | `string` | n/a | yes |
| group\_name\_binding | The role to bind the Google group to. Default is Editor | `string` | `"roles/editor"` | no |
| mode | Mode for adding the IAM policies/bindings, additive and authoritative | `string` | `"additive"` | no |
| network\_name | Name of the VPC | `string` | `"custom-vpc"` | no |
| org\_id | The organization id for the associated services | `string` | n/a | yes |
| project\_prefix | The name of the GCP project | `string` | n/a | yes |
| routing\_mode | Type of routing mode. Can be GLOBAL or REGIONAL | `string` | `"REGIONAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | <pre>{<br>  "subnet-01": [<br>    {<br>      "ip_cidr_range": "192.168.64.0/24",<br>      "range_name": "subnet-01-secondary-01"<br>    }<br>  ]<br>}</pre> | no |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | `bool` | `true` | no |
| subnets | The list of subnets being created | `list(map(string))` | <pre>[<br>  {<br>    "subnet_ip": "10.10.10.0/24",<br>    "subnet_name": "subnet-01",<br>    "subnet_region": "us-central1"<br>  }<br>]</pre> | no |
| vpc\_type | The type of VPC to attach the project to. Possible options are base or null. Default is null. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| network | The created network |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| project\_id | n/a |
| project\_name | n/a |
| project\_number | n/a |
| service\_account\_display\_name | The display name of the default service account |
| service\_account\_email | The email of the default service account |
| service\_account\_id | The id of the default service account |
| service\_account\_name | The fully-qualified name of the default service account |
| subnets | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding subnets. |
| subnets\_flow\_logs | Whether the subnets will have VPC flow logs enabled |
| subnets\_ips | The IPs and CIDRs of the subnets being created |
| subnets\_names | The names of the subnets being created |
| subnets\_regions | The region where the subnets will be created |
| subnets\_self\_links | The self-links of subnets being created |