locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${module.constants.values.org_id}"
}

# ----------------------------------------
#   Infosec Project
# ----------------------------------------

data "google_projects" "prod_host_project" {
  filter = "labels.application=${var.label_application} labels.owner=${module.constants.values.core_projects_owner}"
}

# ----------------------------------------
#   Lookup parent folder by folder name
# ----------------------------------------

data "google_active_folder" "sub_folder1" {
  parent = local.parent
  display_name = var.parent_display_name
}

# ----------------------------------------
#   Custom Role
# ----------------------------------------

data "google_organization" "org" {
  organization = module.constants.values.org_id
}

data "google_active_folder" "custom_role_bind" {
  display_name = var.folder_to_bind_custome_role
  parent = local.parent
}



# data "google_active_folder" "org_pol_skip_network_create" {
#   #for_each     = toset(var.skip_default_network_exclude_folders)
#   display_name = var.skip_default_network_exclude_folders
#   parent       = local.parent
# }

# data "google_active_folder" "org_pol_domain_restrict_sharing" {
#   # for_each     = toset(var.domain_restrict_sharing_exclude_folders)
#   display_name = var.domain_restrict_sharing_exclude_folders
#   parent       = local.parent
# }