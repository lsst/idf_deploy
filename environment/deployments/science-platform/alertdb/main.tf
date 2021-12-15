# Creates two buckets, one for alert packet data and one for alert schema data.

# The alert packet bucket may optionally have a lifecycle rule to delete old
# alert data.

# Creates two ServiceAccounts, one with readwrite access and the other with
# readonly access to the objects. Sets both up to be accessible from
# Kubernetes via Workload Identity.

module "alert_packet_bucket" {
  source        = "../../../../modules/bucket"
  project_id    = var.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  prefix_name   = "alertdb"
  suffix_name   = ["packets"]
  labels        = var.labels

  # Conditionally set up a rule to delete old alert data
  lifecycle_rules = var.purge_old_alerts ? [
    {
      action = {
        type = "Delete"
      },
      condition = {
        age = var.maximum_alert_age
      }
    }
  ] : []
}

module "alert_schema_bucket" {
  source        = "../../../../modules/bucket"
  project_id    = var.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  prefix_name   = "alertdb"
  suffix_name   = ["schemas"]
  labels        = var.labels
}

module "bucket_writer_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"

  project_id   = var.project_id
  prefix       = "alertdb"
  names        = ["writer"]
  display_name = "Alert database writer"
  description  = "Grants write access to the packet and schema buckets for the alert DB"
}

// RW storage access to the alert packet bucket
resource "google_storage_bucket_iam_member" "alert_packet_readwrite" {
  bucket = module.alert_packet_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.bucket_writer_account.email}"
}

// RW storage access to the alert schema bucket
resource "google_storage_bucket_iam_member" "alert_schema_readwrite" {
  bucket = module.alert_schema_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.bucket_writer_account.email}"
}

# Grant the writer k8s serviceaccount the right to assume the
# bucket_writer_account identity.
resource "google_service_account_iam_binding" "writer_workload_identity_binding" {
  service_account_id = module.bucket_writer_account.service_accounts_map["writer"].name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.writer_k8s_namespace}/${var.writer_k8s_serviceaccount_name}]"
  ]
}

// Grant access to the Workload Identity system so this can be used in GKE
module "bucket_reader_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"

  project_id   = var.project_id
  prefix       = "alertdb"
  names        = ["reader"]
  display_name = "Alert database reader"
  description  = "Grants read access to the packet and schema buckets for the alert DB"
}

// Read access to the alertdb packet bucket
resource "google_storage_bucket_iam_member" "alert_packet_read_buckets" {
  bucket = module.alert_packet_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${module.bucket_reader_account.email}"
}

// Read access to the alertdb schema bucket
resource "google_storage_bucket_iam_member" "alert_schema_read_buckets" {
  bucket = module.alert_schema_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${module.bucket_reader_account.email}"
}

# Grant the k8s service account the right to assume the bucket_reader_account
# identity.
resource "google_service_account_iam_binding" "reader_workload_identity_binding" {
  service_account_id = module.bucket_reader_account.service_accounts_map["reader"].name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.reader_k8s_namespace}/${var.reader_k8s_serviceaccount_name}]"
  ]
}
