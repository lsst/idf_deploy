locals {
  organization_id = module.constants.deploy_at_root ? module.constants.values.org_id : null
  folder_id       = module.constants.deploy_at_root ? null : module.constants.values.parent_folder
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
#   RESTRICT PUBLIC IP ACCESS ON CLOUD SQL
# ----------------------------------------

module "org_restrict_public_ip_access_cloudsql" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/sql.restrictPublicIp"
}

# ----------------------------------------
#   DISABLE SERVICE ACCOUNT KEY CREATION
# ----------------------------------------

module "org_disable_service_account_key_create" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/iam.disableServiceAccountKeyCreation"
}

# ----------------------------------------
#   DISABLE AUTOMATIC IAM GRANTS
# ----------------------------------------

module "org_disable_automatic_iam_grants" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
}

# ----------------------------------------
#   SHIELDED VMS  
# ----------------------------------------

module "org_shielded_vms" {
  source          = "terraform-google-modules/org-policy/google"
  version         = "~> 3.0"
  organization_id = local.organization_id
  folder_id       = local.folder_id
  policy_for      = local.parent_resource_type
  policy_type     = "boolean"
  enforce         = "true"
  constraint      = "constraints/compute.requireShieldedVm"
}
