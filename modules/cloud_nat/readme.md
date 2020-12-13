# Terraform Cloud NAT

This module handles reserving external IP addresses and assigning them to a Google Cloud NAT. Additional resources, like Cloud Router, will also be created.

## Usage

Simple example below will reserve `2` external ip addresses, assign them to a Cloud NAT, which will then link to a Cloud Router.

```terraform
module "reserved_cloud_nat" {
  source  = "../nat"
  project_id = "<PROJECT_ID>"
  region  = "us-central1"
  network = "custom-vpc"
  address_count = 2
  address_labels = {
    application_name = "app_service"
    environment      = "prod"
  }
}
```

## Requirements 

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |
| google-beta | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_count | The number of reserved IP addresses needed | `number` | `1` | no |
| address\_labels | Labels to add to the reserved IP address | `map(string)` | `{}` | no |
| address\_name | The name to give to the reserved IP address. | `string` | `"nat-external-address"` | no |
| address\_type | The type of address to attach to the NAT. Options are `EXTERNAL` or `INTERNAL` | `string` | `"EXTERNAL"` | no |
| log\_config\_enable | n/a | `bool` | `false` | no |
| log\_config\_filter | Specified the desired filtering of logs on this NAT. Possible values are `ERRORS_ONLY`, `TRANSLATIOSN_ONLY`, `ALL` | `string` | `"ERRORS_ONLY"` | no |
| nat\_ip\_allocate\_option | How external IPs should be allocated for this NAT. Valid values are `AUTO_ONLY` or `MANUAL_ONLY` | `string` | `"MANUAL_ONLY"` | no || nat\_name | Name of the NAT service. Name must be 1-63 characters. | `string` | `"cloud-nat"` | no |
| network | The network name to attach the resource to | `string` | `"default"` | no |
| network\_tier | The tier of network to use. Options are 'PREMIUM' or 'STANDARD' | `string` | `"PREMIUM"` | no |
| project\_id | The project id to attach the resource to | `string` | n/a | yes |
| region | The region to place the resource | `string` | `"us-central1"` | no |
| router\_name | The name to give to the router | `string` | `"default-router"` | no |
| source\_subnetwork\_ip\_ranges\_to\_nat | How NAT should be configured per subnetwork.Possible values are `ALL_SUBNETWORKS_ALL_IP_RANGES`, `ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGE`S, and `LIST_OF_SUBNETWORKS` | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |

## Outputs

| Name | Description |
|------|-------------|
| address | The static external IP address represented by the resource |
| address\_name | The name of the static external IP address |
| address\_type | The type of address to resolve. |
| nat\_id | Identifier for the resource |
| nat\_name | Name for the resource |
| reserved\_ip\_self\_link | URI of the created resource |
| router\_name | Name of the router |