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

# Cloud Run 
resource "google_cloud_run_v2_service" "promote_chunks" {
  name     = "promote-chunks"
  project  = local.project_id
  location = "us-central1"

  template {
    service_account = google_service_account.cloudrun_promote_chunks.email

    timeout                          = var.promote_chunks_cloud_run_timeout
    max_instance_request_concurrency = var.promote_chunks_cloud_run_concurrency

    scaling {
      min_instance_count = var.promote_chunks_cloud_run_min_instance_count
      max_instance_count = var.promote_chunks_cloud_run_max_instance_count
    }

    containers {
      # This image serves as a placeholder for the initial provision
      image = "us-central1-docker.pkg.dev/${local.project_id}/${google_artifact_registry_repository.ppdb_repo.repository_id}/promote-chunks:latest"

      resources {
        startup_cpu_boost = true
        cpu_idle          = true

        limits = {
          cpu    = var.promote_chunks_cloud_run_cpu_limit
          memory = var.promote_chunks_cloud_run_memory_limit
        }
      }

      ports {
        container_port = 8080
      }

      env {
        name  = "PPDB_CONFIG_URI"
        value = var.promote_chunks_cloud_run_ppdb_config_uri
      }

      env {
        name  = "PPDB_USE_SECRET_MANAGER"
        value = var.promote_chunks_cloud_run_ppdb_use_secret_manager
      }

      env {
        name  = "LOG_EXECUTION_ID"
        value = var.promote_chunks_cloud_run_log_execution_id
      }
    }
  }

  lifecycle {
    # Keeps Terraform from reverting the image during future applies
    ignore_changes = [
      template[0].containers[0].image,
    ]
  }
}
