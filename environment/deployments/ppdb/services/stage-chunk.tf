# Cloud Run Stage Chunk Service Account
resource "google_service_account" "cloudrun_stage_chunk" {
  account_id   = "cloudrun-stage-chunk"
  display_name = "Terraform-managed service account for cloud run stage chunk"
  project      = local.project_id
}

# Read access to the chunk files, for the manifest and the load jobs
resource "google_storage_bucket_iam_member" "cloudrun_stage_chunk_chunk_ingest_object_viewer" {
  bucket = google_storage_bucket.chunk_ingest.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
}

resource "google_project_iam_member" "cloudrun_stage_chunk_logging_writer" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
  project = local.project_id
}

# Cloud SQL access, to check and update the replica chunk status
resource "google_project_iam_member" "cloudrun_stage_chunk_sql_client" {
  project = local.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
}

resource "google_project_iam_member" "cloudrun_stage_chunk_sql_instance_user" {
  project = local.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
}

# IAM database user for CloudSQL
resource "google_sql_user" "cloudrun_stage_chunk_iam_sql_user" {
  name     = split(".gserviceaccount.com", google_service_account.cloudrun_stage_chunk.email)[0]
  instance = local.sql_instance_name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
  project  = local.project_id
}

# Read access to the PPDB config
resource "google_storage_bucket_iam_member" "cloudrun_stage_chunk_storage_viewer_configs" {
  bucket = google_storage_bucket.config.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
}

# BigQuery access, to load a chunk into its landing tables and copy them
# into the staging tables
resource "google_project_iam_member" "cloudrun_stage_chunk_bq_job_user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
  project = local.project_id
}

resource "google_bigquery_dataset_access" "cloudrun_stage_chunk_staging_dataset_editor" {
  dataset_id = google_bigquery_dataset.ppdb_staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  iam_member = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
  project    = local.project_id
}

resource "google_bigquery_dataset_access" "cloudrun_stage_chunk_landing_dataset_editor" {
  dataset_id = google_bigquery_dataset.ppdb_landing.dataset_id
  role       = "roles/bigquery.dataEditor"
  iam_member = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
  project    = local.project_id
}


# Grant the Service Account permission to invoke the Stage Chunk Cloud Run service
resource "google_cloud_run_v2_service_iam_member" "run_invoker_stage_chunk" {
  project  = local.project_id
  location = var.region
  name     = google_cloudfunctions2_function.stage_chunk.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.cloudrun_stage_chunk.email}"
}

# Push Subscription Definition
resource "google_pubsub_subscription" "stage_chunk" {
  name    = "stage-chunk"
  project = local.project_id
  topic   = google_pubsub_topic.stage_chunk_topic.id

  ack_deadline_seconds = 600

  push_config {
    push_endpoint = google_cloudfunctions2_function.stage_chunk.service_config[0].uri

    oidc_token {
      service_account_email = google_service_account.cloudrun_stage_chunk.email
    }
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.stage_chunk_dlt.id
    max_delivery_attempts = var.stage_chunk_pubsub_max_delivery_attempts
  }

  expiration_policy {
    ttl = ""
  }
}

# Dead-letter subscription, which keeps undeliverable messages for inspection
# and replay. A topic without a subscription discards its messages.
resource "google_pubsub_subscription" "stage_chunk_dlt" {
  name    = "stage-chunk-dlt-sub"
  project = local.project_id
  topic   = google_pubsub_topic.stage_chunk_dlt.id

  # 31 days, the maximum
  message_retention_duration = "2678400s"

  expiration_policy {
    ttl = ""
  }
}

# Grant the Pub/Sub service agent permission to forward undeliverable messages
resource "google_pubsub_topic_iam_member" "pubsub_agent_stage_chunk_dlt_publisher" {
  project = local.project_id
  topic   = google_pubsub_topic.stage_chunk_dlt.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${local.pubsub_service_agent}"
}

resource "google_pubsub_subscription_iam_member" "pubsub_agent_stage_chunk_subscriber" {
  project      = local.project_id
  subscription = google_pubsub_subscription.stage_chunk.id
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${local.pubsub_service_agent}"
}

# Cloud Run Functions Gen2 Definition
resource "google_cloudfunctions2_function" "stage_chunk" {
  name        = "stage-chunk"
  project     = local.project_id
  location    = var.region
  description = "Stages replica chunks into the BigQuery staging tables"

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
    runtime         = var.stage_chunk_runtime
    entry_point     = "stage_chunk"
    service_account = google_service_account.cloudrun_build.id

    # Placeholder source code bucket/object for initial creation
    source {
      storage_source {
        bucket = google_storage_bucket_object.placeholder_zip_stage_chunk.bucket
        object = google_storage_bucket_object.placeholder_zip_stage_chunk.name
      }
    }
  }

  service_config {
    service_account_email            = google_service_account.cloudrun_stage_chunk.email
    min_instance_count               = var.stage_chunk_cloud_run_min_instance_count
    max_instance_count               = var.stage_chunk_cloud_run_max_instance_count
    max_instance_request_concurrency = var.stage_chunk_cloud_run_concurrency

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
      LOG_LEVEL                         = var.stage_chunk_cloud_run_log_level
      BIGQUERY_CHECK_TIMEOUT_SECONDS    = var.stage_chunk_bigquery_check_timeout_seconds
      BIGQUERY_JOB_TIMEOUT_SECONDS      = var.stage_chunk_bigquery_job_timeout_seconds
      BIGQUERY_RETRY_TIMEOUT_SECONDS    = var.stage_chunk_bigquery_retry_timeout_seconds
      PROJECT_ID                        = local.project_id
      LOG_EXECUTION_ID                  = var.stage_chunk_cloud_run_log_execution_id
      SENTRY_ENVIRONMENT                = local.sentry_environment
      PPDB_CONFIG_URI                   = var.stage_chunk_cloud_run_ppdb_config_uri
      CLOUDSQL_ENABLED                  = "true"
      CLOUDSQL_IP_TYPE                  = "private"
      CLOUDSQL_INSTANCE_CONNECTION_NAME = "${local.project_id}:${var.region}:ppdb-${var.environment}"
      CLOUDSQL_USER                     = "${google_service_account.cloudrun_stage_chunk.account_id}@${local.project_id}.iam"
      CLOUDSQL_DB_NAME                  = var.stage_chunk_db_name
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
data "archive_file" "dummy_source_stage_chunk" {
  type        = "zip"
  output_path = "${path.module}/dummy_source_stage_chunk.zip"

  source {
    content  = "def stage_chunk(event, context=None):\n    return 'OK'"
    filename = "main.py"
  }
}

# Upload the dummy zip to Cloud Storage
resource "google_storage_bucket_object" "placeholder_zip_stage_chunk" {
  name   = "source/placeholder-stage-chunk.zip"
  bucket = google_storage_bucket.config.id
  source = data.archive_file.dummy_source_stage_chunk.output_path
}
