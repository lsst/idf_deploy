module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 3.0"

  project_id         = var.project_id
  prefix             = var.prefix
  names              = var.names
  project_roles      = var.project_roles
  grant_billing_role = var.grant_billing_role
  billing_account_id = var.billing_account_id
  grant_xpn_roles    = var.grant_xpn_roles
  org_id             = var.org_id
  generate_keys      = var.generate_keys
  display_name       = var.display_name
  description        = var.description
}