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

resource "google_storage_bucket_iam_member" "cloudrun_track_chunks_storage_viewer_configs" {
  bucket = google_storage_bucket.config.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_track_chunks.email}"
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
  location = var.region

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
      service = google_cloudfunctions2_function.track_chunk.name
      region = var.region
    }
  }
}

# Cloud Run Functions Gen2 Definition
resource "google_cloudfunctions2_function" "track_chunk" {
  name        = "track-chunk"
  project     = local.project_id
  location    = var.region
  description = "Tracks processing chunks"

  build_config {
    runtime         = var.track_chunk_runtime
    entry_point     = "track_chunk"
    service_account = google_service_account.cloudrun_build.id

    # Placeholder source code bucket/object for initial creation
    source {
      storage_source {
        bucket = google_storage_bucket_object.placeholder_zip_track_chunk.bucket
        object = google_storage_bucket_object.placeholder_zip_track_chunk.name
      }
    }
  }

  service_config {
    service_account_email            = google_service_account.cloudrun_track_chunks.email
    min_instance_count               = var.track_chunk_cloud_run_min_instance_count
    max_instance_count               = var.track_chunk_cloud_run_max_instance_count
    max_instance_request_concurrency = var.track_chunk_cloud_run_concurrency

    direct_vpc_network_interface {
      network    = local.network
      subnetwork = local.subnet
    }
    direct_vpc_egress = "VPC_EGRESS_PRIVATE_RANGES_ONLY"

    environment_variables = {
      PPDB_CONFIG_URI                   = var.track_chunk_cloud_run_ppdb_config_uri
      PPDB_USE_SECRET_MANAGER           = var.track_chunk_cloud_run_ppdb_use_secret_manager
      CLOUDSQL_ENABLED                  = "true"
      CLOUDSQL_IP_TYPE                  = "private"
      CLOUDSQL_INSTANCE_CONNECTION_NAME = "${local.project_id}:${var.region}:ppdb-${var.environment}"
      CLOUDSQL_USER                     = "${google_service_account.cloudrun_track_chunks.account_id}@${local.project_id}.iam"
      CLOUDSQL_DB_NAME                  = "ppdb-chunk-tracking"
    }
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = "projects/${local.project_id}/topics/track-chunk-topic"
    retry_policy   = var.track_chunk_cloud_run_retry_policy
  }

  # Instructs Terraform to ignore modifications to the source code artifact made by CI
  lifecycle {
    ignore_changes = [
      build_config[0].source,
    ]
  }
}

# Dummy zip file to build function
data "archive_file" "dummy_source_track_chunk" {
  type        = "zip"
  output_path = "${path.module}/dummy_source_track_chunk.zip"

  source {
    content  = "def track_chunk(event, context=None):\n    return 'OK'"
    filename = "main.py"
  }
}

# Upload the dummy zip to Cloud Storage
resource "google_storage_bucket_object" "placeholder_zip_track_chunk" {
  name   = "source/placeholder-track-chunk.zip"
  bucket = google_storage_bucket.config.id
  source = data.archive_file.dummy_source_track_chunk.output_path
}
