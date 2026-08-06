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

resource "google_storage_bucket_iam_member" "cloudrun_trigger_stage_chunks_dataflow_gcs_folder_viewer" {
  bucket = google_storage_bucket.dataflow.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
}

resource "google_project_iam_member" "cloudrun_trigger_stage_chunks_storage_admin" {
  role    = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = local.project_id
}

resource "google_service_account_iam_member" "cloudrun_trigger_stage_chunks_dataflow_sa_impersonation" {
  service_account_id = google_service_account.dataflow_stage_chunk.name
  role               = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
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
  location = var.region

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
      service = google_cloudfunctions2_function.trigger_stage_chunk.name
      region  = var.region
    }
  }
}

# Cloud Run Functions Gen2 Definition
resource "google_cloudfunctions2_function" "trigger_stage_chunk" {
  name        = "trigger-stage-chunk"
  project     = local.project_id
  location    = var.region
  description = "Triggers Stage Chunks"

  build_config {
    runtime         = var.trigger_stage_chunk_runtime
    entry_point     = "trigger_stage_chunk"
    service_account = google_service_account.cloudrun_build.id

    # Placeholder source code bucket/object for initial creation
    source {
      storage_source {
        bucket = google_storage_bucket_object.placeholder_zip_trigger_stage_chunk.bucket
        object = google_storage_bucket_object.placeholder_zip_trigger_stage_chunk.name
      }
    }
  }

  service_config {
    service_account_email            = google_service_account.cloudrun_trigger_stage_chunk.email
    min_instance_count               = var.trigger_stage_chunk_cloud_run_min_instance_count
    max_instance_count               = var.trigger_stage_chunk_cloud_run_max_instance_count
    max_instance_request_concurrency = var.trigger_stage_chunk_cloud_run_concurrency

    direct_vpc_network_interface {
      network    = local.network
      subnetwork = local.subnet
    }
    direct_vpc_egress = "VPC_EGRESS_PRIVATE_RANGES_ONLY"

    environment_variables = {
      DATAFLOW_TEMPLATE_PATH  = var.trigger_stage_chunk_cloud_run_dataflow_template_path
      LOG_LEVEL               = var.trigger_stage_chunk_cloud_run_log_level
      PROJECT_ID              = local.project_id
      REGION                  = var.region
      GOOGLE_CLOUD_SUBNETWORK = "https://www.googleapis.com/compute/v1/${local.subnet}"
      SERVICE_ACCOUNT_EMAIL   = google_service_account.dataflow_stage_chunk.email
      TEMP_LOCATION           = var.trigger_stage_chunk_cloud_run_temp_location
      TOPIC_NAME              = google_pubsub_topic.track_chunk_topic.name
      LOG_EXECUTION_ID        = var.trigger_stage_chunk_cloud_run_log_execution_id
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
data "archive_file" "dummy_source_trigger_stage_chunk" {
  type        = "zip"
  output_path = "${path.module}/dummy_source_trigger_stage_chunk.zip"

  source {
    content  = "def trigger_stage_chunk(event, context=None):\n    return 'OK'"
    filename = "main.py"
  }
}

# Upload the dummy zip to Cloud Storage
resource "google_storage_bucket_object" "placeholder_zip_trigger_stage_chunk" {
  name   = "source/placeholder-trigger-stage-chunk.zip"
  bucket = google_storage_bucket.config.id
  source = data.archive_file.dummy_source_trigger_stage_chunk.output_path
}
