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
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = ["desc-dc2-dr6"]
  prefix_name   = "curation-us-central1"
  versioning = {
    desc-dc2-dr6    = false
    desc-dc2-run22i = true
  }
  force_destroy = {
    desc-dc2-dr6    = true
    desc-dc2-run22i = true
  }
  labels = {
    environment = var.environment
    application = var.application_name
  }
}

// Storage Bucket
module "storage_bucket_2" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  prefix_name   = "butler-us-central1"
  suffix_name   = ["dp01-dev", "dp01-int", "dp01", "repo-locations", "dp02-user", "dp1"]
  versioning = {
    dp01-dev       = true
    dp01-int       = true
    dp01           = false
    dp01-desc-dr6  = true
    repo-locations = true
    dp02-user      = false
    dp1            = false
  }
  force_destroy = {
    dp01-dev       = true
    dp01-int       = true
    dp01           = true
    panda-dev      = true
    dp01-desc-dr6  = true
    repo-locations = true
    dp02-user      = true
    dp1            = true
  }
  labels = {
    environment = var.environment
    application = var.application_name
  }
}

// HiPS Storage Bucket (VISTA testing)
module "storage_bucket_3" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = ["dev"]
  prefix_name   = "hips-vista-us-central1"
  versioning = {
    hips-dev = false
  }
  force_destroy = {
    hips-dev = false
  }
  labels = {
    environment = var.environment
    application = "hips"
  }
}
// RO storage access to HiPS VISTA bucket
resource "google_storage_bucket_iam_binding" "hips-vista-bucket-ro-iam-binding" {
  bucket  = module.storage_bucket_3.name
  role    = "roles/storage.objectViewer"
  members = var.hips_service_accounts
}

// HiPS Storage Bucket (DP0.2)
module "storage_bucket_4" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = ["dp02-hips", "dp1-hips"]
  prefix_name   = "static-us-central1"
  versioning = {
    dp02-hips = false
    dp1-hips = false
  }
  force_destroy = {
    dp02-hips = false
    dp1-hips = false
  }
  labels = {
    environment = var.environment
    application = "hips"
  }
}
// RO storage access to HiPS buckets
resource "google_storage_bucket_iam_binding" "dp-hips-bucket-ro-iam-binding" {
  for_each = toset(module.storage_bucket_4.names_list)
  bucket  = each.key
  role    = "roles/storage.objectViewer"
  members = var.hips_service_accounts
}

moved {
  from = google_storage_bucket_iam_binding.dp02-hips-bucket-ro-iam-binding
  to = google_storage_bucket_iam_binding.dp-hips-bucket-ro-iam-binding["static-us-central1-dp02-hips"]
}

// Git LFS Storage Bucket (Prod)
module "storage_bucket_5" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = ["git-lfs"]
  prefix_name   = "rubin-us-central1"
  versioning = {
    git-lfs = false
  }
  force_destroy = {
    git-lfs = false
  }
  labels = {
    environment = var.environment
    application = "giftless"
  }
}
// RO storage access to Git-LFS bucket
resource "google_storage_bucket_iam_binding" "git-lfs-bucket-ro-iam-binding" {
  bucket  = module.storage_bucket_5.name
  role    = "roles/storage.objectViewer"
  members = var.git_lfs_ro_service_accounts
}
// RW storage access to Git-LFS bucket
resource "google_storage_bucket_iam_binding" "git-lfs-bucket-rw-iam-binding" {
  bucket  = module.storage_bucket_5.name
  role    = "roles/storage.objectUser"
  members = var.git_lfs_rw_service_accounts
}

// Git LFS Storage Bucket (Dev)
module "storage_bucket_6" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = ["git-lfs-dev"]
  prefix_name   = "rubin-us-central1"
  versioning = {
    git-lfs-dev = false
  }
  force_destroy = {
    git-lfs-dev = false
  }
  labels = {
    environment = var.environment
    application = "giftless"
  }
}
// RO storage access to Git-LFS Dev bucket
resource "google_storage_bucket_iam_binding" "git-lfs-bucket-dev-ro-iam-binding" {
  bucket  = module.storage_bucket_6.name
  role    = "roles/storage.objectViewer"
  members = var.git_lfs_ro_dev_service_accounts
}
// RW storage access to Git-LFS Dev bucket
resource "google_storage_bucket_iam_binding" "git-lfs-bucket-dev-rw-iam-binding" {
  bucket  = module.storage_bucket_6.name
  role    = "roles/storage.objectUser"
  members = var.git_lfs_rw_dev_service_accounts
}

# This account was formerly used by end users for direct butler
# access.  Users should no longer provided with this access,
# but for the moment this is disabled instead of deleted
# to confirm there are no surprises.
resource "google_service_account" "legacy_butler_service_account" {
  account_id = "butler-gcs-butler-gcs-data-sa"
  display_name = "Butler GCS Service account for Data Curation Prod"
  description  = "Butler GCS access service account managed by Terraform"
  disabled = true
}

moved {
  from = module.data_curation_prod_accounts.module.service_accounts.google_service_account.service_accounts["butler-gcs-data-sa"]
  to = google_service_account.legacy_butler_service_account
}

// RW storage access to DP 0.1 bucket for Butler
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp0" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket   = "butler-us-central1-dp01"
  role     = each.value
  member   = "serviceAccount:${google_service_account.legacy_butler_service_account.email}"
}
// RW storage access to the -dev Butler bucket
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp0_dev" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket   = "butler-us-central1-dp01-dev"
  role     = each.value
  member   = "serviceAccount:${google_service_account.legacy_butler_service_account.email}"
}
// RW storage access to the -int Butler bucket
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp0_int" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket   = "butler-us-central1-dp01-int"
  role     = each.value
  member   = "serviceAccount:${google_service_account.legacy_butler_service_account.email}"
}
// RW storage access to repo-locations Butler bucket 
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_repo_locations" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket   = "butler-us-central1-repo-locations"
  role     = each.value
  member   = "serviceAccount:${google_service_account.legacy_butler_service_account.email}"
}
// RW storage access to DP 0.2 bucket for Butler
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp02_user" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket   = "butler-us-central1-dp02-user"
  role     = each.value
  member   = "serviceAccount:${google_service_account.legacy_butler_service_account.email}"
}
// RW storage access to DP 0.2 HiPS bucket for Butler (temporary)
resource "google_storage_bucket_iam_member" "data_curation_prod_rw_dp02_hips" {
  for_each = toset(["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"])
  bucket   = "static-us-central1-dp02-hips"
  role     = each.value
  member   = "serviceAccount:${google_service_account.legacy_butler_service_account.email}"
}


# Service account used by Butler server (running inside science platform
# Phalanx) to access Google Cloud Storage buckets.
module "butler_server_account" {
  source = "../../../modules/service_accounts/"

  project_id   = module.project_factory.project_id
  prefix       = "butler-server"
  names        = ["gcs"]
  display_name = "Butler Server service account for Data Curation Prod"
  description  = "Butler Server GCS access service account managed by Terraform"

  project_roles = [
  ]
}

resource "google_storage_bucket_iam_member" "data_curation_prod_ro_dp1" {
  for_each = toset(["roles/storage.objectViewer", "roles/storage.legacyBucketReader"])
  bucket   = "butler-us-central1-dp1"
  role     = each.value
  member   = "serviceAccount:${module.butler_server_account.email}"
}

resource "google_storage_bucket_iam_member" "data_curation_prod_ro_dp02_user" {
  for_each = toset(["roles/storage.objectViewer", "roles/storage.legacyBucketReader"])
  bucket   = "butler-us-central1-dp02-user"
  role     = each.value
  member   = "serviceAccount:${module.butler_server_account.email}"
}