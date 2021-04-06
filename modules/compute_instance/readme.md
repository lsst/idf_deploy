# Compute Instance

This module is used to create compute instance (and only compute instance) without using instance templates

## Usage
Basic usage to create an instance with no external ip.
```bash
module "compute_instance" {
    source             = "./"
    project            = "my-project-id"
    subnetwork         = "subnet-01"
    hostname           = "instance-basic"
    num_instances      = 1
    subnetwork_project = "my-project-id"
}
```
Public IP usage
```bash
resource "google_compute_address" "ip_address" {
  name = "external-ip"
}

locals {
  access_config = {
    nat_ip       = google_compute_address.ip_address.address
    network_tier = "PREMIUM"
  }
}

module "instance_template" {
  source          = "./"
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  name_prefix     = "simple"
  tags            = var.tags
  labels          = var.labels
  access_config   = [local.access_config]
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_config | Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet. | <pre>list(object({<br>    nat_ip       = string<br>    network_tier = string<br>  }))</pre> | `[]` | no |
| can\_ip\_forward | Enable IP forwarding, for NAT instances for example | `string` | `"false"` | no |      
| enable\_shielded\_vm | Whether to enable the Shielded VM configuration on the instance. Note that the instance image must support Shielded VMs. See https://cloud.google.com/compute/docs/images | `bool` | `true` | no |
| hostname | Hostname of instances | `string` | `""` | no |
| image | The image from which to initialize this disk. | `string` | n/a | yes |
| labels | Labels, provided as a map | `map(string)` | `{}` | no |
| machine\_type | The machine type to create | `string` | `"e2-medium"` | no |
| metadata | Metadata, provided as a map | `map(string)` | `{}` | no |
| network | The name or self\_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks. | `string` | `""` | no |       
| network\_ip | The private IP address to assign to the instance. If emtpy, the address will be automatically assigned. | `string` | `""` | no |
| network\_tier | The networking tier for the instance. Can take `PREMIUM` or `STANDARD`. | `string` | `"PREMIUM"` | no |
| num\_instances | Number of instances to create. This value is ignored if static\_ips is provided. | `string` | `"1"` | no |
| preemptible | Allow the instance to be preempted | `bool` | `false` | no |
| project | The project id | `string` | n/a | yes |
| region | The region to deploy the instance. | `string` | n/a | yes |
| service\_account | Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account. | <pre>object({<br>    email  = string<br>    scopes = set(string)<br>  })</pre> | `null` | no |
| shielded\_instance\_config | Not used unless enable\_shielded\_vm is true. Shielded VM configuration for the instance. | <pre>object({<br>    enable_secure_boot          = bool<br>    enable_vtpm                 = 
bool<br>    enable_integrity_monitoring = bool<br>  })</pre> | <pre>{<br>  "enable_integrity_monitoring": true,<br>  "enable_secure_boot": true,<br>  "enable_vtpm": true<br>}</pre> | no |
| size | The size of the image in gigabytes. | `number` | `50` | no |
| startup\_script | User startup script to run when instances spin up | `string` | `""` | no |
| static\_ips | List of static IPs for VM instances | `list(string)` | `[]` | no |
| subnetwork | The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided. | `string` | `""` | no |
| subnetwork\_project | The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used. | `string` | `""` | no |
| tags | A list of network tags to attach to the instance | `list(string)` | `[]` | no |
| type | The GCE disk type. Maybe `pd-standard`,`pd-balanced`, `pd-ssd` | `string` | `"pd-standard"` | no | 
| zone | The zone that the machine should be created in | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| available\_zones | List of available zones in a region |
| instance\_zone | The zone the instance deployed into |
| instances\_self\_link | name of the instance |
| name | Name(s) of the instance |