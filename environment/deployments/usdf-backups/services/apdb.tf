# Config GCS Bucket
resource "google_storage_bucket" "apdb_backup" {
  name          = "apdb-backup-${var.environment}"
  project       = local.project_id
  location      = var.apdb_backup_location
  storage_class = var.apdb_backup_gcs_storage_class

  versioning {
    enabled = var.apdb_backup_object_versioning_enabled
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      with_state                 = "ARCHIVED"
      days_since_noncurrent_time = var.apdb_backup_object_versioning_retention_time
    }
  }

  autoclass {
    enabled = var.apdb_backup_gcs_autosclass_enabled
    terminal_storage_class = var.apdb_backup_gcs_autosclass_tier
  }
}

resource "google_service_account" "usdf_apdb_backup_storage" {
  account_id   = "usdf-apdb-backup-storage"
  display_name = "USDF APDB Backup Storage"
  project      = local.project_id
}

resource "google_storage_bucket_iam_member" "usdf_apdb_backup_storage_object_user" {
  bucket = google_storage_bucket.apdb_backup.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.usdf_apdb_backup_storage.email}"
}
