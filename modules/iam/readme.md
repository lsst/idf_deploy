# Module Project IAM

This optional module is used to assign project roles.

## Example Usage
```terraform

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| member | Identities that will be granted the privilege in 'role'. | `string` | n/a | yes |
| project | The project ID. | `string` | n/a | yes |
| project\_iam\_permissions | List of permissions granted to the group | `list(string)` | <pre>[<br>  "roles/monitoring.admin"<br>]</pre> | no |

## Outputs

No output.