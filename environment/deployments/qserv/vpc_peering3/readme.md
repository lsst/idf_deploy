# VPC Peer

This terraform module will peer two VPCs together.

This setup assumes we're peering two GCP `projects` together and instead of hard coding the project_id we can filter the projects based on the labels assigned to the project.

Last, we need to get the VPC name so we can get the self_link to peer the two VPCs together.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_name | The local 'application\_name' label value. | `string` | n/a | yes |
| environment | The local 'environment' label value | `string` | n/a | yes |
| network\_name | The VPC name in the local project. | `string` | n/a | yes |
| remote\_application\_name | The remote 'application\_name' label value. | `string` | `"science-platform"` | no |
| remote\_environment | The remote `environment` label value. | `string` | `"dev"` | no |
| remote\_network\_name | The VPC name in the remote project to peer to | `string` | `"custom-vpc"` | no |

## Outputs