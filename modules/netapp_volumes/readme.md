# Terraform Module for File Store

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | A description of the instance. | `string` | `"A description of the instance."` | no |
| fileshare\_capacity | File share capacity in GiB. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier. | `number` | `2660` | no |
| fileshare\_name | The name of the fileshare (16 characters or less) | `string` | `"share1"` | no |
| labels | Labels | `map` | <pre>{<br>  "application_name": "app_name",<br>  "name": "cluster"<br>}</pre> | no |        
| modes | IP versions for which the instance has IP addresses assigned. Each value may be one of ADDRESS\_MODE\_UNSPECIFIED, MODE\_IPV4, and MODE\_IPV6. | `list(string)` | <pre>[<br>  "MODE_IPV4"<br>]</pre> | no |
| name | The resource name of the instance. | `string` | `"test-instance"` | no |
| network | The name of the GCE VPC network to which the instance is connected. | `string` | `"default"` | no |
| project | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| tier | The service tier of the instance. Possible values are TIER\_UNSPECIFIED, STANDARD, PREMIUM, BASIC\_HDD, BASIC\_SSD, and HIGH\_SCALE\_SSD. | `string` | `"STANDARD"` | no |
| zone | The name of the Filestore zone of the instance | `string` | `"us-central1-b"` | no |

## Outputs

No output.