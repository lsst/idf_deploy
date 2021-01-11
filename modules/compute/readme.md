# Terraform GCP Compute Instance
This module allows you to create a Google Compute Engine instance resource.

## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_delete | Whether or not the boot disk should be auto-deleted | `string` | `"true"` | no |
| can\_ip\_forward | Enable IP forwarding, for NAT instances for example | `string` | `"false"` | no |
| disk\_size\_gb | Boot disk size in GB | `string` | `"100"` | no |
| disk\_type | Boot disk type, can be either pd-ssd, local-ssd, or pd-standard | `string` | `"pd-standard"` | no |
| hostname | VM hostname | `string` | `"instance-simple"` | no |
| labels | Labels, provided as a map | `map(string)` | n/a | yes |
| machine\_type | Machine type to create, e.g. n1-standard-1 | `string` | `"n1-standard-1"` | no |
| metadata | Metadata, provided as a map | `map(string)` | `{}` | no |
| nat\_ip | Public ip address | `any` | `null` | no |
| network\_tier | Network network\_tier | `string` | `"PREMIUM"` | no |
| num\_instances | Number of instances to create | `number` | `1` | no |
| preemptible | Allow the instance to be preempted | `bool` | `false` | no |
| project\_id | The GCP project to use for integration tests | `string` | n/a | yes |
| region | The default region to place subnetwork | `string` | `"us-central1"` | no |
| service\_account | Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account. | <pre>object({<br>    email  = string,<br>    scopes = set(string)<br>  })</pre> | <pre>{<br>  "email": null,<br>  "scopes": [<br>    "userinfo-email",<br>    "compute-ro",<br>    "storage-ro"<br>  ]<br>}</pre> | no |
| source\_image | Source disk image. If neither source\_image nor source\_image\_family is specified, defaults to the latest public CentOS image. | `string` | `""` | no |
| source\_image\_family | Source image family. If neither source\_image nor source\_image\_family is specified, defaults to the latest public CentOS image. | `string` | `"centos-7"` | no |
| source\_image\_project | Project where the source image comes from. The default project contains images that support Shielded VMs if desired | `string` | `"gce-uefi-images"` | no |
| startup\_script | User startup script to run when instances spin up | `string` | `""` | no |
| subnetwork | The name of the subnetwork create this instance in. | `string` | `""` | no |
| tags | Network tags, provided as a list | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| available\_zones | List of available zones in region |
| instances\_self\_links | List of self-links for compute instances |
| name | Name of the instance templates |
| self\_link | Self-link to the instance template |