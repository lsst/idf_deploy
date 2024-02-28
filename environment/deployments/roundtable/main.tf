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

// Vault server key management
// prod
module "kms" {
  source         = "../../../modules/kms"
  project_id     = module.project_factory.project_id
  location       = "us-central1"
  keyring        = "vault-server"
  keys           = ["vault-seal"]
  set_owners_for = ["vault-seal"]
  decrypters     = ["serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"]
  encrypters     = ["serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"]
  owners         = ["serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"]
}

// Vault Server Storage Bucket
module "storage_bucket" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = [var.vault_server_bucket_suffix]
  prefix_name   = "rubin"
  versioning = {
    (var.vault_server_bucket_suffix) = true
  }
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        num_newer_versions = 3
      }
    }
  ]
  force_destroy = {
    (var.vault_server_bucket_suffix) = false
  }
  labels = {
    environment = var.environment
    application = "vault"
  }
}

// Vault Server Storage Bucket (Backup)
module "storage_bucket_b" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = ["${var.vault_server_bucket_suffix}-backup"]
  prefix_name   = "rubin"
  versioning = {
    "${var.vault_server_bucket_suffix}-backup" = true
  }
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        num_newer_versions = "20"
      }
    }
  ]
  force_destroy = {
    "${var.vault_server_bucket_suffix}-backup" = false
  }
  labels = {
    environment = var.environment
    application = "vault"
  }
}

// Service account and roles for Vault Server

// Service account for Vault Server
resource "google_service_account" "vault_server_sa" {
  account_id   = "vault-server"
  display_name = "Vault Server"
  description  = "Terraform-managed service account for Vault server"
  project      = module.project_factory.project_id
}

// Use Workload Identity to have the service run as the appropriate service
// account (bound to a Kubernetes service account)
resource "google_project_iam_member" "vault_server_sa_wi" {
  project = module.project_factory.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[vault/vault]"
}

// The Vault service account must be granted the roles Cloud KMS Viewer and
// Cloud KMS CryptoKey Encrypter/Decrypter
resource "google_project_iam_member" "vault_server_viewer_sa" {
  project = module.project_factory.project_id
  role    = "roles/cloudkms.viewer"
  member  = "serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "vault_server_cryptokey_sa" {
  project = module.project_factory.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

// RW storage access to Vault Server bucket
resource "google_storage_bucket_iam_member" "vault_server_storage_sa" {
  bucket  = module.storage_bucket.name
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

// Admin storage access to Vault Server backup bucket
resource "google_storage_bucket_iam_member" "vault_server_storage_backup_sa" {
  bucket  = module.storage_bucket_b.name
  role    = "roles/storage.admin"
  member  = "serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

// Hidden SA for data transfer job

data "google_storage_transfer_project_service_account" "vault_backup_transfer_sa" {
  project = module.project_factory.project_id
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_source_sa" {
  bucket  = module.storage_bucket.name
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa}.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_source_sa_r" {
  bucket  = module.storage_bucket.name
  role    = "roles/storage.legacyBucketReader"
  member  = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa}.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_sink_sa" {
  bucket  = module.storage_bucket_b.name
  role    = "roles/storage.legacyBucketWriter"
  member  = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa}.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_sink_sa_r" {
  bucket  = module.storage_bucket_b.name
  role    = "roles/storage.legacyBucketReader"
  member  = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa}.iam.gserviceaccount.com"
}

// Resources for Vault Server storage backups

resource "google_storage_transfer_job" "vault_server_storage_backup" {
  description = "Nightly backup of Vault Server storage"
  project     = module.project_factory.project_id
  transfer_spec {
    gcs_data_source {
      bucket_name = module.storage_bucket.name
    }
    gcs_data_sink {
      bucket_name = module.storage_bucket_b.name
    }
  }
  schedule {
    schedule_start_date {
      year  = 2024
      month = 1
      day   = 1
    }
    start_time_of_day { // UTC: 2 AM Pacific Standard Time
      hours   = 10
      minutes = 0
      seconds = 0
      nanos   = 0
    }
  }
  depends_on = [google_storage_bucket_iam_member.vault_server_storage_backup_sa]
}

# Service account for Git LFS read/write
resource "google_service_account" "git_lfs_rw_sa" {
  account_id   = "git-lfs-rw"
  display_name = "Git LFS (RW)"
  description  = "Terraform-managed service account for Git LFS RW access"
  project      = module.project_factory.project_id
}



# Use Workload Identity to have the service run as the appropriate service
# account (bound to a Kubernetes service account)
resource "google_project_iam_member" "git_lfs_rw_sa_wi" {
  project = module.project_factory.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-rw]"
}

# The git-lfs service accounts must be granted the ability to generate
# tokens for themselves so that they can generate signed GCS URLs
# starting from the GKE service account token without requiring an
# exported secret key for the underlying Google service account.
resource "google_project_iam_member" "git_lfs_rw_gcs_sa" {
  project = module.project_factory.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:git-lfs-rw@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

# Service account for Git LFS read-only
resource "google_service_account" "git_lfs_ro_sa" {
  account_id   = "git-lfs-ro"
  display_name = "Git LFS (RO)"
  description  = "Terraform-managed service account for Git LFS RO access"
  project      = module.project_factory.project_id
}

# See above, but for read-only account
resource "google_project_iam_member" "git_lfs_ro_sa_wi" {
  project = module.project_factory.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-ro]"
}

# See above, but for read-only account
resource "google_project_iam_member" "git_lfs_ro_gcs" {
  project = module.project_factory.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:git-lfs-ro@${module.project_factory.project_id}.iam.gserviceaccount.com"
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

module "firewall_cert_manager" {
  source = "../../../modules/firewall"

  project_id   = module.project_factory.project_id
  network      = module.project_factory.network_name
  custom_rules = var.custom_rules
}

// Reserve a public IP for ingress
resource "google_compute_address" "external_ip_address" {
  name    = "public-ip"
  region  = var.default_region
  project = module.project_factory.project_id
}

// Reserve a static ip for Cloud NAT
resource "google_compute_address" "static" {
  count        = var.num_static_ips
  project      = module.project_factory.project_id
  name         = "${var.application_name}-${var.environment}-nat-${count.index}"
  description  = "Reserved static IP ${count.index} addresses managed by Terraform."
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.default_region
}

module "nat" {
  source  = "../../../modules/nat"
  name    = var.router_name
  project = module.project_factory.project_id
  network = module.project_factory.network_name
  region  = var.default_region
  #nats   = var.nats
  nats = [{
    name    = "cloud-nat",
    nat_ips = google_compute_address.static.*.name
  }]
}
