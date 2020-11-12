provider "google" {
  version = "~> 3.43.0"
}

provider "google-beta" {
  version = "~> 3.43.0"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

/*************************************************
  Bootstrap GCP Organization.
*************************************************/

module "seed_bootstrap" {
  source  = "terraform-google-modules/bootstrap/google"
  version = "~> 1.6"

  org_id               = var.org_id
  billing_account      = var.billing_account
  group_org_admins     = var.group_org_admins
  group_billing_admins = var.group_billing_admins
  default_region       = var.default_region
  org_project_creators = var.org_project_creators
  activate_apis        = var.activate_apis
  folder_id            = var.folder_id
  project_prefix       = var.project_prefix
  #project_id           = var.project_id
}