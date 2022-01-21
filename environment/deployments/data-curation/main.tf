module "project_factory" {
  source                      = "../../../modules/project_vpc"
  org_id                      = var.org_id
  folder_id                   = var.folder_id
  billing_account             = var.billing_account
  project_prefix              = "${var.application_name}-${var.environment}"
  application_name            = var.application_name
  environment                 = var.environment
  activate_apis               = var.activate_apis
  budget_amount               = var.budget_amount
  budget_alert_spent_percents = var.budget_alert_spent_percents
  network_name                = var.network_name
  subnets                     = var.subnets
  secondary_ranges            = var.secondary_ranges
  routing_mode                = var.routing_mode
}

module "iam_admin" {
  source                  = "../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"  
}

module "service_account_cluster" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 2.0"
  project_id = module.project_factory.project_id
  prefix     = var.environment
  names      = ["cluster"]
  project_roles = [
    "${module.project_factory.project_id}=>roles/container.clusterAdmin",
  ]
}


module "firewall_1" {
  source = "../../../modules/firewall"

  project_id   = module.project_factory.project_id
  network      = module.project_factory.network_name
  custom_rules = var.custom_rules
}

module "nat" {
  source = "../../../modules/cloud_nat"

  project_id        = module.project_factory.project_id
  region            = var.default_region
  network           = module.project_factory.network_name
  router_name       = var.router_name
  address_count     = var.address_count
  address_name      = var.address_name
  address_type      = var.address_type
  nat_name          = "${var.application_name}-${var.environment}-cloud-nat"
  min_ports_per_vm  = var.min_ports_per_vm
  log_config_enable = var.log_config_enable
  log_config_filter = var.log_config_filter
  address_labels = {
    application_name = var.application_name
    environment      = var.environment
  }
}


// Storage Bucket
module "storage_bucket" {
  source      = "../../../modules/bucket"
  project_id  = module.project_factory.project_id
  storage_class = "REGIONAL"
  location   = "us-central1"
  suffix_name = ["desc-dc2-dr6", "desc-dc2-run22i"]
  prefix_name = "curation"
  versioning = {
    desc-dc2-dr6  = false
    desc-dc2-run22i = true
  }
  force_destroy = {
    desc-dc2-dr6  = true
    desc-dc2-run22i = true
  }
  labels = {
    environment = var.environment
    application = var.application_name
  }
}

// Storage Bucket
module "storage_bucket_2" {
  source      = "../../../modules/bucket"
  project_id  = module.project_factory.project_id
  storage_class = "REGIONAL"
  location   = "us-central1"
  suffix_name = ["dp01-dev", "dp01-int", "dp01", "panda-dev", "dp01-desc-dr6"]
  prefix_name = "butler"
  versioning = {
    dp01-dev  = true
    dp01-int  = true
    dp01      = false
    dp01-desc-dr6 = true
  }
  force_destroy = {
    dp01-dev  = true
    dp01-int  = true
    dp01      = true
    dp01-desc-dr6 = true
  }
  labels = {
    environment = var.environment
    application = var.application_name
  }
}

#---------------------------------------------------------------
// Data Curation Prod
#---------------------------------------------------------------
module "data_curation_prod_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "data-curation-prod-fbdb"
  prefix       = "butler-gcs"
  names        = var.data_curation_prod_names
  display_name = "Butler GCS Service account for Data Curation Prod"
  description  = "Butler GCS access service account managed by Terraform"

  project_roles = [
  ]
}
// RW storage access to DP 0.1 bucket for Butler
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp0" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket = "butler-us-central1-dp01"
  role   = each.value
  member = "serviceAccount:${module.data_curation_prod_accounts.email}"
}
// RO storage access to DESC DC2 Run22i bucket
resource "google_storage_bucket_iam_member" "data_curation_prod_ro_desc_dc2_run22i" {
  bucket = "curation-us-central1-desc-dc2-run22i"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${module.data_curation_prod_accounts.email}"
}
// RO storage access to DESC DR6 bucket
resource "google_storage_bucket_iam_member" "data_curation_prod_ro_desc_dr6" {
  bucket = "butler-us-central1-dp01-desc-dr6"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${module.data_curation_prod_accounts.email}"
}
// RW storage access to the -dev Butler bucket
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp0_dev" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket = "butler-us-central1-dp01-dev"
  role   = each.value
  member = "serviceAccount:${module.data_curation_prod_accounts.email}"
}
// RW storage access to the -int Butler bucket
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp0_int" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket = "butler-us-central1-dp01-int"
  role   = each.value
  member = "serviceAccount:${module.data_curation_prod_accounts.email}"
}
// RW storage access to panda-dev's Butler bucket
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_panda_dev" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket = "butler-us-central1-panda-dev"
  role   = each.value
  member = "serviceAccount:${module.data_curation_prod_accounts.email}"
}
