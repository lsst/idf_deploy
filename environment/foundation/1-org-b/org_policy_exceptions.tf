locals {
  organization_id = module.constants.deploy_at_root ? module.constants.values.org_id : null
  folder_id       = module.constants.deploy_at_root ? null : module.constants.values.parent_folder
  parent_resource_id   = var.parent_folder != "" ? var.parent_folder : module.constants.values.org_id
  parent_resource_type = var.parent_folder != "" ? "folder" : "organization"
}

# ----------------------------------------
#  Optional
# ----------------------------------------

//  SKIP DEFAULT NETWORK CREATION
module "org_skip_default_network" {
  #for_each        = data.google_active_folder.org_pol_skip_network_create
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.skipDefaultNetworkCreation"
  #exclude_folders = ["${data.google_active_folder.org_pol_skip_network_create.name}"]
  exclude_folders = ["folders/${var.skip_default_network_exclude_folders}"]
}


//   DOMAIN RESTRCITED SHARING
module "org_domain_restricted_sharing" {
  #for_each         = data.google_active_folder.org_pol_domain_restrict_sharing
  source           = "terraform-google-modules/org-policy/google//modules/domain_restricted_sharing"
  version          = "~> 3.0"
  organization_id  = local.organization_id
  folder_id        = local.folder_id
  policy_for       = local.parent_resource_type
  domains_to_allow = module.constants.values.domains_to_allow
  #exclude_folders = ["${data.google_active_folder.org_pol_domain_restrict_sharing.name}"]
  exclude_folders = ["folders/${var.domain_restrict_sharing_exclude_folders}"]
}