# Cloud Run Load SSO Service Account
resource "google_service_account" "cloudrun_load_sso" {
  account_id   = "cloudrun-load-sso"
  display_name = "Terraform-managed service account for cloud run load sso"
  project      = local.project_id
}

resource "google_project_iam_member" "cloudrun_load_sso_logging_writer" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
  project = local.project_id
}

# Read access to the SSO uploads, for the manifest and the load jobs
resource "google_storage_bucket_iam_member" "cloudrun_load_sso_sso_ingest_object_viewer" {
  bucket = google_storage_bucket.sso_ingest.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
}

# Publish the result of each load
resource "google_pubsub_topic_iam_member" "cloudrun_load_sso_load_sso_result" {
  topic   = google_pubsub_topic.load_sso_result.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
  project = local.project_id
}

# Read access to the PPDB config
resource "google_storage_bucket_iam_member" "cloudrun_load_sso_storage_viewer_configs" {
  bucket = google_storage_bucket.config.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
}

# BigQuery access, to load an upload into its landing tables and copy them
# into the internal tables
resource "google_project_iam_member" "cloudrun_load_sso_bq_job_user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
  project = local.project_id
}

resource "google_bigquery_dataset_access" "cloudrun_load_sso_landing_dataset_editor" {
  dataset_id = google_bigquery_dataset.ppdb_landing.dataset_id
  role       = "roles/bigquery.dataEditor"
  iam_member = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
  project    = local.project_id
}

resource "google_bigquery_dataset_access" "cloudrun_load_sso_internal_dataset_editor" {
  dataset_id = google_bigquery_dataset.ppdb_internal.dataset_id
  role       = "roles/bigquery.dataEditor"
  iam_member = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
  project    = local.project_id
}

# Grant the Service Account permission to invoke the Load SSO Cloud Run service
resource "google_cloud_run_v2_service_iam_member" "run_invoker_load_sso" {
  project  = local.project_id
  location = var.region
  name     = google_cloudfunctions2_function.load_sso.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
}

# Push Subscription Definition
resource "google_pubsub_subscription" "load_sso" {
  name    = "load-sso"
  project = local.project_id
  topic   = google_pubsub_topic.load_sso_topic.id

  # A load takes well under a minute. This covers two rounds of BigQuery
  # jobs at load_sso_bigquery_job_timeout_seconds each, plus startup.
  ack_deadline_seconds = 300

  push_config {
    push_endpoint = google_cloudfunctions2_function.load_sso.service_config[0].uri

    oidc_token {
      service_account_email = google_service_account.cloudrun_load_sso.email
    }
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.load_sso_dlt.id
    max_delivery_attempts = var.load_sso_pubsub_max_delivery_attempts
  }

  expiration_policy {
    ttl = ""
  }
}

# Dead-letter subscription, which keeps undeliverable messages for inspection
# and replay. A topic without a subscription discards its messages.
resource "google_pubsub_subscription" "load_sso_dlt" {
  name    = "load-sso-dlt-sub"
  project = local.project_id
  topic   = google_pubsub_topic.load_sso_dlt.id

  # 31 days, the maximum
  message_retention_duration = "2678400s"

  expiration_policy {
    ttl = ""
  }
}

# Grant the Pub/Sub service agent permission to forward undeliverable messages
resource "google_pubsub_topic_iam_member" "pubsub_agent_load_sso_dlt_publisher" {
  project = local.project_id
  topic   = google_pubsub_topic.load_sso_dlt.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${local.pubsub_service_agent}"
}

resource "google_pubsub_subscription_iam_member" "pubsub_agent_load_sso_subscriber" {
  project      = local.project_id
  subscription = google_pubsub_subscription.load_sso.id
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${local.pubsub_service_agent}"
}

# Cloud Run Functions Gen2 Definition
resource "google_cloudfunctions2_function" "load_sso" {
  name        = "load-sso"
  project     = local.project_id
  location    = var.region
  description = "Loads uploaded SSO data with BigQuery load jobs"

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
    runtime         = var.load_sso_runtime
    entry_point     = "load_sso"
    service_account = google_service_account.cloudrun_build.id

    # Placeholder source code bucket/object for initial creation
    source {
      storage_source {
        bucket = google_storage_bucket_object.placeholder_zip_load_sso.bucket
        object = google_storage_bucket_object.placeholder_zip_load_sso.name
      }
    }
  }

  service_config {
    service_account_email            = google_service_account.cloudrun_load_sso.email
    min_instance_count               = var.load_sso_cloud_run_min_instance_count
    max_instance_count               = var.load_sso_cloud_run_max_instance_count
    max_instance_request_concurrency = var.load_sso_cloud_run_concurrency

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
      LOG_LEVEL                      = var.load_sso_cloud_run_log_level
      BIGQUERY_JOB_TIMEOUT_SECONDS   = var.load_sso_bigquery_job_timeout_seconds
      BIGQUERY_RETRY_TIMEOUT_SECONDS = var.load_sso_bigquery_retry_timeout_seconds
      PROJECT_ID                     = local.project_id
      LOG_EXECUTION_ID               = var.load_sso_cloud_run_log_execution_id
      SENTRY_ENVIRONMENT             = local.sentry_environment
      PPDB_CONFIG_URI                = var.load_sso_cloud_run_ppdb_config_uri
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
data "archive_file" "dummy_source_load_sso" {
  type        = "zip"
  output_path = "${path.module}/dummy_source_load_sso.zip"

  source {
    content  = "def load_sso(event, context=None):\n    return 'OK'"
    filename = "main.py"
  }
}

# Upload the dummy zip to Cloud Storage
resource "google_storage_bucket_object" "placeholder_zip_load_sso" {
  name   = "source/placeholder-load-sso.zip"
  bucket = google_storage_bucket.config.id
  source = data.archive_file.dummy_source_load_sso.output_path
}
