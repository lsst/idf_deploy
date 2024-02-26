# Terraform module for KMS

This enables creation of a KMS keyring and one or more keys with linked owner/encrypter/decrypter service accounts.

It is used by Rubin Observatory to store seal keys for the Vault server that backs K8s vault-secrets-operator.  In expected use, `project_id`, `location`, `keyring`, `keys`, and access information will be set, and everything else will be left at its default value.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project\_id | Project id where the keyring will be created. | `string` | n/a | yes |
| location | Location for the keyring. | `string` | n/a | yes |
| keyring | Keyring name. | `string` | n/a | yes |
| keys | Key names. | `list(string)` | `[]` | no |
| set\_decrypters\_for | Name of keys for which decrypters will be set. | `list(str)` | `[]` | no |
| set\_encrypters\_for | Name of keys for which encrypters will be set. | `list(str)` | `[]` | no |
| set\_owners\_for | Name of keys for which owners will be set. | `list(str)` | `[]` | no |
| decrypters | List of comma-separated decrypters for each key declared in set\_decrypters\_for. | `list(str)` | `[]` | no |
| encrypters | List of comma-separated encrypters for each key declared in set\_encrypters\_for. | `list(str)` | `[]` | no |
| owners | List of comma-separated owners for each key declared in set\_owners\_for. | `list(str)` | `[]` | no |
| key\_algorithm | The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs. | `string` | `"GOOGLE_SYMMETRIC_ENCRYPTION"` | no |
| key\_destroy\_scheduled\_duration | Set the period of time that versions of keys spend in the DESTROY_SCHEDULED state before transitioning to DESTROYED. | `string` | null | no |
| key\_protection\_level | The protection level to use when creating a version based on this template. Possible values are SOFTWARE and HSM. | `string` | `"SOFTWARE"` | no |
| key\_rotation\_peroid | Generate a new key every time this period passes. | `string` | `"7776000s"` | no |
| labels | Labels, provided as a map. | `map(string)` | `{}` | no |
| prevent\_destroy | Set the prevent\_destroy lifecycle attribute on keys. | `bool` | `true` | no |
| purpose | The immutable purpose of the CryptoKey. Possible values are ENCRYPT\_DECRYPT, ASYMMETRIC\_SIGN, and ASYMMETRIC\_DECRYPT. | `string` | `"ENCRYPT_DECRYPT"` | no |

## Outputs

| Name | Description | Value |
|------|-------------|-------|
| keyring | Self link of the keyring. | `module.kms.keyring` |
| keyring\_name | Name of the keyring. | `module.kms.keyring_name` |
| keyring\_resource | Keyring resource. | `module.kms.keyring_resource` |
| keys | Map of key name => key self link. | `module.kms.keys` |

