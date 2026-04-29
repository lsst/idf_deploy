<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | 6.50.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_constants"></a> [constants](#module\_constants) | ../constants | n/a |
| <a name="module_sub_folders_alert_production"></a> [sub\_folders\_alert\_production](#module\_sub\_folders\_alert\_production) | terraform-google-modules/folders/google | ~> 5.1 |
| <a name="module_sub_folders_epo"></a> [sub\_folders\_epo](#module\_sub\_folders\_epo) | terraform-google-modules/folders/google | ~> 5.1 |
| <a name="module_sub_folders_ppdb"></a> [sub\_folders\_ppdb](#module\_sub\_folders\_ppdb) | terraform-google-modules/folders/google | ~> 5.1 |
| <a name="module_sub_folders_processing"></a> [sub\_folders\_processing](#module\_sub\_folders\_processing) | terraform-google-modules/folders/google | ~> 5.1 |
| <a name="module_sub_folders_science_platform"></a> [sub\_folders\_science\_platform](#module\_sub\_folders\_science\_platform) | terraform-google-modules/folders/google | ~> 5.1 |
| <a name="module_sub_folders_square"></a> [sub\_folders\_square](#module\_sub\_folders\_square) | terraform-google-modules/folders/google | ~> 5.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [google_folder_iam_member.gcp_epo_administrators_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_ppdb_administrators_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_processing_administrator_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_processing_gke_cluster_admins_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_processing_gke_developer_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_science_platform_administrator_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_science_platform_gke_cluster_admins_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_science_platform_gke_developer_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_shared_service_org_admin_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_square_administrator_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_square_gke_cluster_admins_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_folder_iam_member.gcp_square_gke_developer_iam_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_active_folder.alert_production_sub_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/active_folder) | data source |
| [google_active_folder.epo_sub_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/active_folder) | data source |
| [google_active_folder.ppdb_sub_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/active_folder) | data source |
| [google_active_folder.processing_sub_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/active_folder) | data source |
| [google_active_folder.shared_services_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/active_folder) | data source |
| [google_active_folder.splatform_sub_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/active_folder) | data source |
| [google_active_folder.square_sub_folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/active_folder) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_alert_production_display_name"></a> [alert\_production\_display\_name](#input\_alert\_production\_display\_name) | The display name of the parent folder. | `string` | `"Alert Production"` | no |
| <a name="input_epo_display_name"></a> [epo\_display\_name](#input\_epo\_display\_name) | The display name of the parent folder. | `string` | `"EPO"` | no |
| <a name="input_gcp_epo_administrators_iam_permissions"></a> [gcp\_epo\_administrators\_iam\_permissions](#input\_gcp\_epo\_administrators\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/resourcemanager.projectCreator",<br/>  "roles/container.admin",<br/>  "roles/editor"<br/>]</pre> | no |
| <a name="input_gcp_org_administrators_shared_service_iam_permissions"></a> [gcp\_org\_administrators\_shared\_service\_iam\_permissions](#input\_gcp\_org\_administrators\_shared\_service\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/storage.admin",<br/>  "roles/domains.admin"<br/>]</pre> | no |
| <a name="input_gcp_ppdb_administrators_iam_permissions"></a> [gcp\_ppdb\_administrators\_iam\_permissions](#input\_gcp\_ppdb\_administrators\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/storage.admin"<br/>]</pre> | no |
| <a name="input_gcp_processing_administrators_iam_permissions"></a> [gcp\_processing\_administrators\_iam\_permissions](#input\_gcp\_processing\_administrators\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/resourcemanager.projectCreator",<br/>  "roles/container.admin",<br/>  "roles/editor"<br/>]</pre> | no |
| <a name="input_gcp_processing_gke_cluster_admins_iam_permissions"></a> [gcp\_processing\_gke\_cluster\_admins\_iam\_permissions](#input\_gcp\_processing\_gke\_cluster\_admins\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/container.admin",<br/>  "roles/container.clusterAdmin",<br/>  "roles/logging.admin",<br/>  "roles/resourcemanager.projectCreator",<br/>  "roles/monitoring.admin",<br/>  "roles/storage.admin",<br/>  "roles/compute.instanceAdmin",<br/>  "roles/logging.admin",<br/>  "roles/file.editor",<br/>  "roles/compute.networkAdmin",<br/>  "roles/compute.securityAdmin"<br/>]</pre> | no |
| <a name="input_gcp_processing_gke_developer_iam_permissions"></a> [gcp\_processing\_gke\_developer\_iam\_permissions](#input\_gcp\_processing\_gke\_developer\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/container.clusterViewer",<br/>  "roles/container.viewer",<br/>  "roles/container.developer",<br/>  "roles/logging.viewer",<br/>  "roles/monitoring.editor",<br/>  "roles/storage.objectViewer"<br/>]</pre> | no |
| <a name="input_gcp_science_platform_administrators_iam_permissions"></a> [gcp\_science\_platform\_administrators\_iam\_permissions](#input\_gcp\_science\_platform\_administrators\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/resourcemanager.projectCreator",<br/>  "roles/container.admin",<br/>  "roles/editor"<br/>]</pre> | no |
| <a name="input_gcp_science_platform_gke_cluster_admins_iam_permissions"></a> [gcp\_science\_platform\_gke\_cluster\_admins\_iam\_permissions](#input\_gcp\_science\_platform\_gke\_cluster\_admins\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/container.admin",<br/>  "roles/container.clusterAdmin",<br/>  "roles/logging.admin",<br/>  "roles/resourcemanager.projectCreator",<br/>  "roles/monitoring.admin",<br/>  "roles/storage.admin",<br/>  "roles/compute.instanceAdmin",<br/>  "roles/logging.admin",<br/>  "roles/file.editor",<br/>  "roles/compute.networkAdmin",<br/>  "roles/compute.securityAdmin"<br/>]</pre> | no |
| <a name="input_gcp_science_platform_gke_developer_iam_permissions"></a> [gcp\_science\_platform\_gke\_developer\_iam\_permissions](#input\_gcp\_science\_platform\_gke\_developer\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/container.clusterViewer",<br/>  "roles/container.viewer",<br/>  "roles/container.developer",<br/>  "roles/logging.viewer",<br/>  "roles/monitoring.editor",<br/>  "roles/storage.objectViewer"<br/>]</pre> | no |
| <a name="input_gcp_square_administrators_iam_permissions"></a> [gcp\_square\_administrators\_iam\_permissions](#input\_gcp\_square\_administrators\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/resourcemanager.projectCreator",<br/>  "roles/container.admin",<br/>  "roles/editor"<br/>]</pre> | no |
| <a name="input_gcp_square_gke_cluster_admins_iam_permissions"></a> [gcp\_square\_gke\_cluster\_admins\_iam\_permissions](#input\_gcp\_square\_gke\_cluster\_admins\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/container.admin",<br/>  "roles/container.clusterAdmin",<br/>  "roles/logging.admin",<br/>  "roles/resourcemanager.projectCreator",<br/>  "roles/monitoring.admin",<br/>  "roles/storage.admin",<br/>  "roles/compute.instanceAdmin",<br/>  "roles/logging.admin",<br/>  "roles/file.editor",<br/>  "roles/compute.networkAdmin",<br/>  "roles/compute.securityAdmin"<br/>]</pre> | no |
| <a name="input_gcp_square_gke_developer_iam_permissions"></a> [gcp\_square\_gke\_developer\_iam\_permissions](#input\_gcp\_square\_gke\_developer\_iam\_permissions) | List of permissions granted to the group. | `list(string)` | <pre>[<br/>  "roles/container.clusterViewer",<br/>  "roles/container.viewer",<br/>  "roles/container.developer",<br/>  "roles/logging.viewer",<br/>  "roles/monitoring.editor",<br/>  "roles/storage.objectViewer"<br/>]</pre> | no |
| <a name="input_parent_folder"></a> [parent\_folder](#input\_parent\_folder) | Optional - if using a folder for testing. | `string` | `""` | no |
| <a name="input_ppdb_display_name"></a> [ppdb\_display\_name](#input\_ppdb\_display\_name) | The display name of the parent folder. | `string` | `"PPDB"` | no |
| <a name="input_processing_display_name"></a> [processing\_display\_name](#input\_processing\_display\_name) | The display name of the parent folder. | `string` | `"Processing"` | no |
| <a name="input_shared_services_display_name"></a> [shared\_services\_display\_name](#input\_shared\_services\_display\_name) | The display name of the parent folder. | `string` | `"Shared Services"` | no |
| <a name="input_splatform_display_name"></a> [splatform\_display\_name](#input\_splatform\_display\_name) | The display name of the parent folder. | `string` | `"Science Platform"` | no |
| <a name="input_square_display_name"></a> [square\_display\_name](#input\_square\_display\_name) | The display name of the parent folder. | `string` | `"SQuaRE"` | no |
| <a name="input_sub_folder_names"></a> [sub\_folder\_names](#input\_sub\_folder\_names) | List out the sub folders to be created. | `list(string)` | <pre>[<br/>  "Dev",<br/>  "Integration",<br/>  "Production"<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->