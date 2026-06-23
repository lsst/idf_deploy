# Cloud Run Trigger Stage Chunk Service Account
resource "google_service_account" "cloudrun_trigger_stage_chunk" {
  account_id   = "cloudrun-trigger-stage-chunk"
  display_name = "Terraform-managed service account for cloud run trigger stage chunk"
  project      = local.project_id
}

resource "google_project_iam_member" "cloudrun_trigger_stage_chunk_dataflow" {
  role    = "roles/dataflow.developer"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = local.project_id
}

resource "google_pubsub_topic_iam_member" "cloudrun_trigger_stage_chunk_sa_stage_chunk_topic" {
  topic  = google_pubsub_topic.stage_chunk_topic.id
  role   = "roles/pubsub.subscriber"
  member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = local.project_id
}

# Dedicated Service Account for Eventarc
resource "google_service_account" "eventarc_sa_trigger_stage_chunk" {
  account_id   = "eventarc-stage-chunk-sa"
  display_name = "Eventarc Trigger Service Account for Trigger Stage Chunk"
  project      = local.project_id
}

# Grant the Event Arc Service Account permission to receive and route events
resource "google_project_iam_member" "event_receiver_trigger_stage_chunk" {
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc_sa_trigger_stage_chunk.email}"
  project = local.project_id
}

# Grant the Service Account permission to invoke the Trigger Stage Chunk Cloud Run service
resource "google_project_iam_member" "run_invoker_trigger_stage_chunk" {
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.eventarc_sa_trigger_stage_chunk.email}"
  project = local.project_id
}

# Event Arc Definition
resource "google_eventarc_trigger" "pubsub_trigger_trigger_stage_chunk" {
  name     = "trigger-stage-chunk"
  project  = local.project_id
  location = "us-central1"

  service_account = google_service_account.eventarc_sa_trigger_stage_chunk.email

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.stage_chunk_topic.id
    }
  }

  destination {
    cloud_run_service {
      service = google_cloud_run_v2_service.trigger_stage_chunk.name
      region  = "us-central1"
    }
  }
}

# Cloud Run Definition
resource "google_cloud_run_v2_service" "trigger_stage_chunk" {
  name     = "trigger-stage-chunk"
  project  = local.project_id
  location = "us-central1"

  template {
    service_account = google_service_account.cloudrun_trigger_stage_chunk.email

    timeout                          = var.trigger_stage_chunk_cloud_run_timeout
    max_instance_request_concurrency = var.trigger_stage_chunk_cloud_run_concurrency

    scaling {
      min_instance_count = var.promote_chunks_cloud_run_min_instance_count
      max_instance_count = var.promote_chunks_cloud_run_max_instance_count
    }

    containers {
      # This image serves as a placeholder for the initial provision
      image = "us-central1-docker.pkg.dev/${local.project_id}/${google_artifact_registry_repository.ppdb_repo.repository_id}/trigger-stage-chunk:latest"

      resources {
        startup_cpu_boost = true
        cpu_idle          = true

        limits = {
          cpu    = var.trigger_stage_chunk_cloud_run_cpu_limit
          memory = var.trigger_stage_chunk_cloud_run_memory_limit
        }
      }

      ports {
        container_port = 8080
      }

      env {
        name  = "DATAFLOW_TEMPLATE_PATH"
        value = var.trigger_stage_chunk_cloud_run_dataflow_template_path
      }

      env {
        name  = "LOG_LEVEL"
        value = var.trigger_stage_chunk_cloud_run_log_level
      }

      env {
        name  = "PROJECT_ID"
        value = local.project_id
      }

      env {
        name  = "REGION"
        value = "us-central1"
      }

      env {
        name  = "SERVICE_ACCOUNT_EMAIL"
        value = google_service_account.cloudrun_trigger_stage_chunk.email
      }

      env {
        name  = "TEMP_LOCATION"
        value = var.trigger_stage_chunk_cloud_run_temp_location
      }

      env {
        name  = "TOPIC_NAME"
        value = google_pubsub_topic.track_chunk_topic.name
      }

      env {
        name  = "LOG_EXECUTION_ID"
        value = var.trigger_stage_chunk_cloud_run_log_execution_id
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
