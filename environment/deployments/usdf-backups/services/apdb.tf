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

resource "google_project_iam_member" "usdf_apdb_backup_storage_transfer_agent" {
  role    = "roles/storagetransfer.transferAgent"
  member  = "serviceAccount:${google_service_account.usdf_apdb_backup_storage.email}"
  project = local.project_id
}

resource "google_storage_bucket_iam_member" "usdf_apdb_backup_storage_object_user" {
  bucket = google_storage_bucket.apdb_backup.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.usdf_apdb_backup_storage.email}"
}

resource "google_storage_transfer_job" "apdb_backup_copy" {
  project     = local.project_id
  description = "ADBD Dev copy of backups"
  status      = var.apdb_storage_transfer_enabled

  transfer_spec {
    aws_s3_compatible_data_source {
      bucket_name = var.apdb_source_bucket
      endpoint    = var.apdb_source_bucket_s3_endpoint
      region      = "" # AWS S3 region in Ceph

      s3_metadata {
        auth_method   = var.apdb_source_bucket_auth_method
        request_model = var.apdb_source_bucket_request_method
      }
    }

    gcs_data_sink {
      bucket_name = google_storage_bucket.apdb_backup.name
    }

    object_conditions {
      include_prefixes = var.apdb_backup_prefixes
    }

    transfer_options {
      overwrite_when              = var.apdb_transfer_options_overwrite_when
      delete_objects_unique_in_sink = var.apdb_transfer_options_delete_objects_unique_in_sink
    }
  }

  schedule {
    schedule_start_date {
      year  = var.apdb_backup_start_year
      month = var.apdb_backup_start_month
      day   = var.apdb_backup_start_day
    }
    start_time_of_day {
      hours = var.apdb_backup_start_time_hour
      minutes = "0"
      seconds = "0"
      nanos = "0"
    }

    repeat_interval = var.apdb_transfer_job_repeat_interval
  }
}