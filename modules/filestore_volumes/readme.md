## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity"></a> [capacity](#input\_capacity) | File share capacity in GiB. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier. | `number` | `2600` | no |
| <a name="input_definition"></a> [definition](#input\_definition) | n/a | <pre>object({<br/>    location = string<br/>    capacity = number<br/>    name     = string<br/>    modes    = list(string)<br/>    tier     = string<br/>  })</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | A description of the instance. | `string` | `"A description of the instance."` | no |
| <a name="input_fileshare_name"></a> [fileshare\_name](#input\_fileshare\_name) | The name of the fileshare (16 characters or less) | `string` | `"share1"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels | `map` | <pre>{<br/>  "application_name": "app_name",<br/>  "name": "cluster"<br/>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | The name of the Filestore zone or region (depends on tier) of the instance | `string` | `"us-central1-b"` | no |
| <a name="input_modes"></a> [modes](#input\_modes) | IP versions for which the instance has IP addresses assigned. Each value may be one of ADDRESS\_MODE\_UNSPECIFIED, MODE\_IPV4, and MODE\_IPV6. | `list(string)` | <pre>[<br/>  "MODE_IPV4"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The resource name of the instance. | `string` | `"test-instance"` | no |
| <a name="input_network"></a> [network](#input\_network) | The name of the GCE VPC network to which the instance is connected. | `string` | `"default"` | no |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | The service tier of the instance. Possible values are TIER\_UNSPECIFIED, STANDARD, PREMIUM, BASIC\_HDD, BASIC\_SSD, and HIGH\_SCALE\_SSD. | `string` | `"BASIC_SSD"` | no |

## Outputs

No outputs.
