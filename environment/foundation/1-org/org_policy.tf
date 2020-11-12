locals {
  organization_id = module.constants.deploy_at_root ? module.constants.values.org_id : null
  folder_id       = module.constants.deploy_at_root ? null : module.constants.values.parent_folder
}

# ----------------------------------------
#   RESOURCE LOCATION RESTRICTION
# ----------------------------------------

# `allow_list_length` must equal the number of items in the `allow` list
module "resource-location-restriction" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  constraint        = "constraints/gcp.resourceLocations"
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  organization_id   = local.organization_id
  policy_type       = "list"
  allow             = var.resource_region_location_restriction
  allow_list_length = "1"
}


# ----------------------------------------
#   DOMAIN RESTRCITED SHARING
# ----------------------------------------

module "org_domain_restricted_sharing" {
  source           = "terraform-google-modules/org-policy/google//modules/domain_restricted_sharing"
  version          = "~> 3.0"
  organization_id  = local.organization_id
  folder_id        = local.folder_id
  policy_for       = local.parent_resource_type
  domains_to_allow = module.constants.values.domains_to_allow
}

# ----------------------------------------
#   DISALBE NESTED VIRTUALIZATION
# ----------------------------------------

module "org_disable_nested_virtualization" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.disableNestedVirtualization"
}

# ----------------------------------------
#   SKIP DEFAULT NETWORK CREATION
# ----------------------------------------

module "org_skip_default_network" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.skipDefaultNetworkCreation"
}

# ----------------------------------------
#   ENFORCE BUCKET LEVEL ACCESS
# ----------------------------------------

# module "org_enforce_bucket_level_access" {
#   source          = "terraform-google-modules/org-policy/google"
#   version         = "~> 3.0"
#   organization_id = local.organization_id
#   folder_id       = local.folder_id
#   policy_for      = local.parent_resource_type
#   policy_type     = "boolean"
#   enforce         = "true"
#   constraint      = "constraints/storage.uniformBucketLevelAccess"
# }