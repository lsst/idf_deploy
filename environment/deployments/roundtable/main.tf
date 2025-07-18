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
  prefix_name   = "rubin-us-central1"
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
  prefix_name   = "rubin-us-central1"
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
resource "google_service_account_iam_member" "vault_server_sa_wi" {
  service_account_id = google_service_account.vault_server_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[vault/vault]"
}

// The Vault service account must be granted the roles Cloud KMS Viewer
// and Cloud KMS CryptoKey Encrypter/Decrypter. Note that this grants
// access to every KMS key in the project, which is not ideal and should
// be restricted to only the Vault keys.
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
  bucket = module.storage_bucket.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

// Admin storage access to Vault Server backup bucket
resource "google_storage_bucket_iam_member" "vault_server_storage_backup_sa" {
  bucket = module.storage_bucket_b.name
  role   = "roles/storage.admin"
  member = "serviceAccount:vault-server@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

// Hidden SA for data transfer job

data "google_storage_transfer_project_service_account" "vault_backup_transfer_sa" {
  project = module.project_factory.project_id
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_source_sa" {
  bucket = module.storage_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa.email}"
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_source_sa_r" {
  bucket = module.storage_bucket.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa.email}"
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_sink_sa" {
  bucket = module.storage_bucket_b.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa.email}"
}

resource "google_storage_bucket_iam_member" "vault_server_storage_transfer_sink_sa_r" {
  bucket = module.storage_bucket_b.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.vault_backup_transfer_sa.email}"
}

// In-cluster Grafana access

// The service account is created in the cloudsql config
data "google_service_account" "grafana_service_account" {
  account_id = "grafana"
  project    = module.project_factory.project_id
}

resource "google_project_iam_member" "grafana_monitoring_viewer" {
  project = module.project_factory.project_id
  role    = "roles/monitoring.viewer"
  member  = data.google_service_account.grafana_service_account.member
}

// A separate service account is needed for google cloud monitoring access
// through the built-in Prometheus plugin because it doesn't speak oauth2 and
// we need a separate process to periodically auth to google and update a JWT
// in grafana via the grafana API:
//
// https://cloud.google.com/stackdriver/docs/managed-prometheus/query#ui-grafana
resource "google_service_account" "grafana_datasource_syncer" {
  account_id   = "grafana-datasource-syncer"
  display_name = "Created by Terraform"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "grafana_datasource_syncer" {
  service_account_id = google_service_account.grafana_datasource_syncer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[google-cloud-observability/grafana-datasource-syncer]"
}

resource "google_project_iam_member" "grafana_datasource_syncer_monitoring_viewer" {
  project = module.project_factory.project_id
  role    = "roles/monitoring.viewer"
  member  = google_service_account.grafana_datasource_syncer.member
}

resource "google_project_iam_member" "grafana_datasource_syncer_service_account_token_creator" {
  project = module.project_factory.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = google_service_account.grafana_datasource_syncer.member
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
  depends_on = [google_storage_bucket_iam_member.vault_server_storage_transfer_source_sa, google_storage_bucket_iam_member.vault_server_storage_transfer_sink_sa, google_storage_bucket_iam_member.vault_server_storage_transfer_source_sa_r, google_storage_bucket_iam_member.vault_server_storage_transfer_sink_sa_r]
}

# Service account for EUPS Ready only
resource "google_service_account" "eups_distributor_sa" {
  account_id   = "eups-distributor"
  display_name = "EUPS Distributor SA"
  description  = "Terraform-managed service account for EUPS Distributor GCS access"
  project      = module.project_factory.project_id
}

# Use Workload Identity to have the service run as the appropriate service
# account (bound to a Kubernetes service account)
resource "google_service_account_iam_member" "eups_distributor_sa_wi" {
  service_account_id = google_service_account.eups_distributor_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[eups-distributor/eups-distributor]"
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
resource "google_service_account_iam_member" "git_lfs_rw_sa_wi" {
  service_account_id = google_service_account.git_lfs_rw_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-rw]"
}

# The git-lfs service accounts must be granted the ability to generate
# tokens for themselves so that they can generate signed GCS URLs starting
# from the GKE service account token without requiring an exported secret
# key for the underlying Google service account.
resource "google_service_account_iam_member" "git_lfs_rw_gcs_sa" {
  service_account_id = google_service_account.git_lfs_rw_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:git-lfs-rw@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

# Service account for Git LFS read-only
resource "google_service_account" "git_lfs_ro_sa" {
  account_id   = "git-lfs-ro"
  display_name = "Git LFS (RO)"
  description  = "Terraform-managed service account for Git LFS RO access"
  project      = module.project_factory.project_id
}

# See above, but for read-only account
resource "google_service_account_iam_member" "git_lfs_ro_sa_wi" {
  service_account_id = google_service_account.git_lfs_ro_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-ro]"
}

# See above, but for read-only account
resource "google_service_account_iam_member" "git_lfs_ro_gcs" {
  service_account_id = google_service_account.git_lfs_ro_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:git-lfs-ro@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

# The reaper service account must be granted the ability to generate
# tokens for itself so that they it can generate signed GCS URLs starting
# from the GKE service account token without requiring an exported secret
# key for the underlying Google service account.
resource "google_service_account_iam_member" "reaper_gcs_sa" {
  service_account_id = google_service_account.reaper_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:reaper@${module.project_factory.project_id}.iam.gserviceaccount.com"
}

# Service account for reaper
resource "google_service_account" "reaper_sa" {
  account_id   = "reaper"
  display_name = "Reaper"
  description  = "Terraform-managed service account for Reaper artifact registry access"
  project      = module.project_factory.project_id
}

# Service account for Atlantis
resource "google_service_account" "atlantis" {
  account_id   = "atlantis"
  display_name = "Atlantis"
  description  = "Terraform-managed service account for the Atlantis service in the RSP cluster"
  project      = module.project_factory.project_id
}

# Allow the Atlantis app in the RSP cluster to impersonate the service account
resource "google_service_account_iam_binding" "atlantis" {
  service_account_id = google_service_account.atlantis.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${module.project_factory.project_id}.svc.id.goog[atlantis/atlantis]",
  ]
}

# Allow the active Atlantis instance service account to have read/write powers
# on Google Cloud monitoring in this project
resource "google_project_iam_member" "atlantis_monitoring_admin" {
  project = module.project_factory.project_id
  role    = "roles/monitoring.admin"
  member  = var.atlantis_monitoring_admin_service_account_member
}

# Prodromos terraform state bucket
module "prodromos_state_bucket" {
  source        = "../../../modules/bucket"
  project_id    = module.project_factory.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = [var.prodromos_terraform_state_bucket_suffix]
  prefix_name   = "rubin-us-central1"
  versioning = {
    (var.prodromos_terraform_state_bucket_suffix) = true
  }
  force_destroy = {
    (var.vault_server_bucket_suffix) = false
  }
  labels = {
    environment = var.environment
    application = "prodromos"
  }
}

# Give Atlantis read/write access to the Prodromos state bucket
resource "google_storage_bucket_iam_member" "prodromos_read_write" {
  bucket = module.prodromos_state_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.atlantis.email}"
}

module "service_account_cluster" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.4.3"
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
