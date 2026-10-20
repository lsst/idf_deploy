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
  topic   = google_pubsub_topic.stage_chunk_topic.id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = local.project_id
}

resource "google_storage_bucket_iam_member" "cloudrun_trigger_stage_chunks_dataflow_gcs_folder_viewer" {
  bucket = google_storage_bucket.dataflow.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
}

resource "google_project_iam_member" "cloudrun_trigger_stage_chunks_storage_admin" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = local.project_id
}

resource "google_service_account_iam_member" "cloudrun_trigger_stage_chunks_dataflow_sa_impersonation" {
  service_account_id = google_service_account.dataflow_stage_chunk.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
}

resource "google_project_iam_member" "cloudrun_trigger_stage_chunk_logging_writer" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = local.project_id
}

# Cloud SQL access, to check and update the replica chunk status
resource "google_project_iam_member" "cloudrun_trigger_stage_chunk_sql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
}

resource "google_project_iam_member" "cloudrun_trigger_stage_chunk_sql_instance_user" {
  project = local.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
}

# IAM database user for CloudSQL
resource "google_sql_user" "cloudrun_trigger_stage_chunk_iam_sql_user" {
  name     = split(".gserviceaccount.com", google_service_account.cloudrun_trigger_stage_chunk.email)[0]
  instance = local.sql_instance_name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
  project  = local.project_id
}

# Read access to the PPDB config
resource "google_storage_bucket_iam_member" "cloudrun_trigger_stage_chunk_storage_viewer_configs" {
  bucket = google_storage_bucket.config.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
}

# BigQuery access, to check the staging tables for a chunk's rows
resource "google_project_iam_member" "cloudrun_trigger_stage_chunk_bq_job_user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = local.project_id
}

resource "google_bigquery_dataset_access" "cloudrun_trigger_stage_chunk_staging_dataset_viewer" {
  dataset_id = google_bigquery_dataset.ppdb_staging.dataset_id
  role       = "roles/bigquery.dataViewer"
  iam_member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project    = local.project_id
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

  depends_on = [
    google_secret_manager_secret_iam_member.sentry_dsn_accessor,
    google_project_iam_member.cloudrun_deploy_functions_developer,
    google_project_iam_member.cloudrun_deploy_run_developer,
    google_project_iam_member.cloudrun_deploy_service_account_user,
    google_project_iam_member.cloudrun_deploy_builds_editor,
    google_project_iam_member.cloudrun_deploy_artifact_registry_writer,
    google_project_iam_member.cloudrun_deploy_storage_admin,
    google_project_iam_member.cloudrun_deploy_storage_object_admin,
    google_project_iam_member.cloudrun_deploy_service_account_token_creator,
  ]

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

    secret_environment_variables {
      key        = "SENTRY_DSN"
      project_id = local.project_id
      secret     = google_secret_manager_secret.sentry_dsn.secret_id
      version    = "latest"
    }

    environment_variables = {
      DATAFLOW_TEMPLATE_PATH            = var.trigger_stage_chunk_cloud_run_dataflow_template_path
      LOG_LEVEL                         = var.trigger_stage_chunk_cloud_run_log_level
      PROJECT_ID                        = local.project_id
      REGION                            = var.region
      GOOGLE_CLOUD_SUBNETWORK           = "https://www.googleapis.com/compute/v1/${local.subnet}"
      SERVICE_ACCOUNT_EMAIL             = google_service_account.dataflow_stage_chunk.email
      TEMP_LOCATION                     = var.trigger_stage_chunk_cloud_run_temp_location
      TOPIC_NAME                        = google_pubsub_topic.track_chunk_topic.name
      LOG_EXECUTION_ID                  = var.trigger_stage_chunk_cloud_run_log_execution_id
      NUM_RETRIES                       = var.trigger_stage_chunk_num_retries
      SENTRY_ENVIRONMENT                = local.sentry_environment
      PPDB_CONFIG_URI                   = var.trigger_stage_chunk_cloud_run_ppdb_config_uri
      CLOUDSQL_ENABLED                  = "true"
      CLOUDSQL_IP_TYPE                  = "private"
      CLOUDSQL_INSTANCE_CONNECTION_NAME = "${local.project_id}:${var.region}:ppdb-${var.environment}"
      CLOUDSQL_USER                     = "${google_service_account.cloudrun_trigger_stage_chunk.account_id}@${local.project_id}.iam"
      CLOUDSQL_DB_NAME                  = var.trigger_stage_chunk_db_name
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
