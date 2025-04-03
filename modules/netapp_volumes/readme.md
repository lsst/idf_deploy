# Terraform Module for Netapp Cloud Volumes

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_ips | What IP addresses may connect to the instance. | `string` | `127.0.0.1` | no |
| definition | A definition of a single volume | `object` [see example](./terraform.tfvars.example) | n/a | yes |
| description | A description of the instance. | `string` | `"A description of the instance."` | no |
| labels | Labels | `map` | <pre>{<br>  "application_name": "app_name",<br>  "name": "cluster"<br>}</pre> | no |        
| location | The name of the Filestore zone of the instance | `string` | `"us-central1-b"` | no |
| network | The name of the GCE VPC network to which the instance is connected. | `string` | `"default"` | no |
| project | The ID of the project in which the resource belongs. | `string` | n/a | yes |

## Outputs

No output.
