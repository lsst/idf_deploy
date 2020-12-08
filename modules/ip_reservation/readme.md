# Terraform Module to Reserve Static IP

This module can be used to reserve a static IP address.

## Usage
```terraform
module "reserve_static_ip" {
  source = "../../../modules/ip_reservation"

  project = "<PROJECT_ID>"
  region = "us-central1"
  name = "load balancer"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_type | The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL | `string` | `"EXTERNAL"` | no |  
| description | An optional description of this resource | `string` | `"Reserved static ip address."` | no |
| name | Name of the resource. | `string` | `"ip_reservation"` | no |
| network\_tier | The networking tier used for configuring this address. If this field is not specified, it is assumed to be PREMIUM. Possible values are PREMIUM and STANDARD | `string` | `"PREMIUM"` | no |
| project | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| purpose | The purpose of this resource, which can be one of the following values:GCE\_ENDPOINT or SHARED\_LOADBALANCER\_VIP | `string` | `"GCE_ENDPOINT"` | no |
| region | The Region in which the created address should reside. | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The id of the resource |
| self\_link | The URI of the created resource |