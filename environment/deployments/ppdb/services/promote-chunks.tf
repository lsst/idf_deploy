# Cloud Run Service Account and Roles
resource "google_service_account" "cloudrun_promote_chunks" {
  account_id   = "cloudrun-promote-chunks"
  display_name = "Terraform-managed service account for Cloud Run to promote chunks"
  project      = local.project_id
}

resource "google_storage_bucket_iam_member" "cloudrun_promote_chunks_ingest_object_viewer" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
}

resource "google_bigquery_dataset_access" "cloudrun_promote_chunks_staging_dataset_editor" {
  dataset_id = google_bigquery_dataset.ppdb_staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  iam_member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_promote_chunks_bq_job_user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_promote_chunks_sql_client" {
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_promote_chunks_sql_instance_user" {
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
  project = local.project_id
}

# Cloud Run Functions Gen2 Definition
resource "google_cloudfunctions2_function" "promote_chunks" {
  name        = "promote-chunks"
  project     = local.project_id
  location    = var.region
  description = "Promotes Chunks"

  build_config {
    runtime         = var.promote_chunks_runtime
    entry_point     = "promote_chunks"
    service_account = google_service_account.cloudrun_build.id

    # Placeholder source code bucket/object for initial creation
    source {
      storage_source {
        bucket = google_storage_bucket_object.placeholder_zip_promote_chunks.bucket
        object = google_storage_bucket_object.placeholder_zip_promote_chunks.name
      }
    }
  }

  service_config {
    available_memory                 = var.promote_chunks_cloud_run_memory_limit
    service_account_email            = google_service_account.cloudrun_promote_chunks.email
    min_instance_count               = var.promote_chunks_cloud_run_min_instance_count
    max_instance_count               = var.promote_chunks_cloud_run_max_instance_count
    max_instance_request_concurrency = var.promote_chunks_cloud_run_concurrency
    timeout_seconds                  = var.promote_chunks_cloud_run_timeout

    direct_vpc_network_interface {
      network    = local.network
      subnetwork = local.subnet
    }
    direct_vpc_egress = "VPC_EGRESS_PRIVATE_RANGES_ONLY"

    environment_variables = {
      PPDB_CONFIG_URI                   = var.promote_chunks_cloud_run_ppdb_config_uri
      PPDB_USE_SECRET_MANAGER           = var.promote_chunks_cloud_run_ppdb_use_secret_manager
    }
  }

  # Instructs Terraform to ignore modifications to the source code artifact made by CI
  lifecycle {
    ignore_changes = [
      build_config[0].source,
    ]
  }
}

# Dummy zip file to build function
data "archive_file" "dummy_source_promote_chunks" {
  type        = "zip"
  output_path = "${path.module}/dummy_source_promote_chunks.zip"

  source {
    content  = "def promote_chunks(event, context=None):\n    return 'OK'"
    filename = "main.py"
  }
}

# Upload the dummy zip to Cloud Storage
resource "google_storage_bucket_object" "placeholder_zip_promote_chunks" {
  name   = "source/placeholder-promote-chunks.zip"
  bucket = google_storage_bucket.config.id
  source = data.archive_file.dummy_source_promote_chunks.output_path
}
