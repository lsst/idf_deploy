# Cloud Run Track Chunks Service Account and Roles
resource "google_service_account" "cloudrun_track_chunks" {
  account_id   = "cloudrun-track-chunks"
  display_name = "Terraform-managed service account for Cloud Run to track chunks"
  project      = local.project_id
}

resource "google_project_iam_member" "cloudrun_track_chunks_sql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_track_chunks.email}"
}

resource "google_project_iam_member" "cloudrun_track_chunks_sql_instance_user" {
  project = local.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.cloudrun_track_chunks.email}"
}

# Dedicated Service Account for Eventarc
resource "google_service_account" "eventarc_sa_track_chunk" {
  project      = local.project_id
  account_id   = "eventarc-track-chunk-sa"
  display_name = "Eventarc Trigger Service Account for Track Chunk"
}

# Grant the Event Arc Service Account permission to receive and route events
resource "google_project_iam_member" "event_receiver_track_chunk" {
  project = local.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc_sa_track_chunk.email}"
}

# Grant the Service Account permission to invoke the Track Chunk Cloud Run service
resource "google_project_iam_member" "run_invoker_track_chunk" {
  project = local.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.eventarc_sa_track_chunk.email}"
}

# Event Arc Definition
resource "google_eventarc_trigger" "pubsub_trigger_track_chunk" {
  name     = "track-chunk"
  project  = local.project_id
  location = "us-central1"

  service_account = google_service_account.eventarc_sa_track_chunk.email

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.track_chunk_topic.id
    }
  }

  destination {
    cloud_run_service {
      service = google_cloud_run_v2_service.track_chunk.name
      region  = "us-central1"
    }
  }
}

# Cloud Run Definition
resource "google_cloud_run_v2_service" "track_chunk" {
  name     = "track-chunk"
  project  = local.project_id
  location = "us-central1"

  template {
    service_account = google_service_account.cloudrun_track_chunks.email

    timeout                          = var.track_chunk_cloud_run_timeout
    max_instance_request_concurrency = var.track_chunk_cloud_run_concurrency

    scaling {
      min_instance_count = var.track_chunk_cloud_run_min_instance_count
      max_instance_count = var.track_chunk_cloud_run_max_instance_count
    }

    containers {
      # This image serves as a placeholder for the initial provision so that the Cloud run instance can be created.  It is overwritten by the application gcloud deploy.
      image = "gcr.io/cloudrun/hello"

      resources {
        startup_cpu_boost = true
        cpu_idle          = true

        limits = {
          cpu    = var.track_chunk_cloud_run_cpu_limit
          memory = var.track_chunk_cloud_run_memory_limit
        }
      }

      ports {
        container_port = 8080
      }

      env {
        name  = "PPDB_CONFIG_URI"
        value = var.track_chunk_cloud_run_ppdb_config_uri
      }

      env {
        name  = "PPDB_USE_SECRET_MANAGER"
        value = var.track_chunk_cloud_run_ppdb_use_secret_manager
      }
      env {
        name  = "LOG_EXECUTION_ID"
        value = var.track_chunk_cloud_run_log_execution_id
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
