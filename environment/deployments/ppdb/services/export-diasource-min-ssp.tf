# Cloud Run Export DiaSource Min SSP Service Account
resource "google_service_account" "cloudrun_export_diasource_min_ssp" {
  account_id   = "cloudrun-export-diasrc-min-ssp"
  display_name = "Terraform-managed service account for cloud run export diasource min ssp"
  project      = local.project_id
}

resource "google_project_iam_member" "cloudrun_export_diasource_min_ssp_logging_writer" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_export_diasource_min_ssp.email}"
  project = local.project_id
}

# Write the exports and their manifests
resource "google_storage_bucket_iam_member" "cloudrun_export_diasource_min_ssp_export_object_admin" {
  bucket = google_storage_bucket.diasource_min_ssp_export.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloudrun_export_diasource_min_ssp.email}"
}

# Read access to the PPDB config
resource "google_storage_bucket_iam_member" "cloudrun_export_diasource_min_ssp_storage_viewer_configs" {
  bucket = google_storage_bucket.config.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_export_diasource_min_ssp.email}"
}

# BigQuery access, to export the public DiaSource view. The view reads
# ppdb_internal, so read access is needed on both datasets, as for TAP.
resource "google_project_iam_member" "cloudrun_export_diasource_min_ssp_bq_job_user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_export_diasource_min_ssp.email}"
  project = local.project_id
}

resource "google_bigquery_dataset_iam_member" "cloudrun_export_diasource_min_ssp_public_dataset_viewer" {
  dataset_id = google_bigquery_dataset.ppdb_public.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${google_service_account.cloudrun_export_diasource_min_ssp.email}"
  project    = local.project_id
}

resource "google_bigquery_dataset_access" "cloudrun_export_diasource_min_ssp_internal_dataset_viewer" {
  dataset_id = google_bigquery_dataset.ppdb_internal.dataset_id
  role       = "roles/bigquery.dataViewer"
  iam_member = "serviceAccount:${google_service_account.cloudrun_export_diasource_min_ssp.email}"
  project    = local.project_id
}

# Grant the Service Account permission to invoke the Export DiaSource Min SSP
# Cloud Run service
resource "google_cloud_run_v2_service_iam_member" "run_invoker_export_diasource_min_ssp" {
  project  = local.project_id
  location = var.region
  name     = google_cloudfunctions2_function.export_diasource_min_ssp.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.cloudrun_export_diasource_min_ssp.email}"
}

# Push Subscription Definition
resource "google_pubsub_subscription" "export_diasource_min_ssp" {
  name    = "export-diasource-min-ssp"
  project = local.project_id
  topic   = google_pubsub_topic.promotion_succeeded.id

  # For messages sent by hand to re-run one export. A message with an
  # "export" attribute is delivered only to the export it names, as with
  # --attribute=export=diasource-min-ssp. Promotion's messages have no
  # attributes, so they reach every export. Changing the filter recreates
  # the subscription.
  filter = "NOT attributes:export OR attributes.export = \"diasource-min-ssp\""

  # Covers the export job, at
  # export_diasource_min_ssp_bigquery_job_timeout_seconds, plus the manifest
  # check, the folder delete, the manifest upload and startup. 600 seconds
  # is the maximum.
  ack_deadline_seconds = 600

  push_config {
    push_endpoint = google_cloudfunctions2_function.export_diasource_min_ssp.service_config[0].uri

    oidc_token {
      service_account_email = google_service_account.cloudrun_export_diasource_min_ssp.email
    }
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.export_diasource_min_ssp_dlt.id
    max_delivery_attempts = var.export_diasource_min_ssp_pubsub_max_delivery_attempts
  }

  expiration_policy {
    ttl = ""
  }
}

# Dead-letter subscription, which keeps undeliverable messages for inspection
# and replay. A topic without a subscription discards its messages.
resource "google_pubsub_subscription" "export_diasource_min_ssp_dlt" {
  name    = "export-diasource-min-ssp-dlt-sub"
  project = local.project_id
  topic   = google_pubsub_topic.export_diasource_min_ssp_dlt.id

  # 31 days, the maximum
  message_retention_duration = "2678400s"

  expiration_policy {
    ttl = ""
  }
}

# Grant the Pub/Sub service agent permission to forward undeliverable messages
resource "google_pubsub_topic_iam_member" "pubsub_agent_export_diasource_min_ssp_dlt_publisher" {
  project = local.project_id
  topic   = google_pubsub_topic.export_diasource_min_ssp_dlt.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${local.pubsub_service_agent}"
}

resource "google_pubsub_subscription_iam_member" "pubsub_agent_export_diasource_min_ssp_subscriber" {
  project      = local.project_id
  subscription = google_pubsub_subscription.export_diasource_min_ssp.id
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${local.pubsub_service_agent}"
}

# Cloud Run Functions Gen2 Definition
resource "google_cloudfunctions2_function" "export_diasource_min_ssp" {
  name        = "export-diasource-min-ssp"
  project     = local.project_id
  location    = var.region
  description = "Exports the DiaSource columns that SSP needs to Parquet after each promotion"

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
    runtime         = var.export_diasource_min_ssp_runtime
    entry_point     = "export_diasource_min_ssp"
    service_account = google_service_account.cloudrun_build.id

    # Placeholder source code bucket/object for initial creation
    source {
      storage_source {
        bucket = google_storage_bucket_object.placeholder_zip_export_diasource_min_ssp.bucket
        object = google_storage_bucket_object.placeholder_zip_export_diasource_min_ssp.name
      }
    }
  }

  service_config {
    service_account_email            = google_service_account.cloudrun_export_diasource_min_ssp.email
    min_instance_count               = var.export_diasource_min_ssp_cloud_run_min_instance_count
    max_instance_count               = var.export_diasource_min_ssp_cloud_run_max_instance_count
    max_instance_request_concurrency = var.export_diasource_min_ssp_cloud_run_concurrency

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
      LOG_LEVEL                      = var.export_diasource_min_ssp_cloud_run_log_level
      BIGQUERY_JOB_TIMEOUT_SECONDS   = var.export_diasource_min_ssp_bigquery_job_timeout_seconds
      BIGQUERY_RETRY_TIMEOUT_SECONDS = var.export_diasource_min_ssp_bigquery_retry_timeout_seconds
      EXPORT_BUCKET                  = google_storage_bucket.diasource_min_ssp_export.name
      EXPORT_COMPRESSION             = var.export_diasource_min_ssp_compression
      PROJECT_ID                     = local.project_id
      LOG_EXECUTION_ID               = var.export_diasource_min_ssp_cloud_run_log_execution_id
      SENTRY_ENVIRONMENT             = local.sentry_environment
      PPDB_CONFIG_URI                = var.export_diasource_min_ssp_cloud_run_ppdb_config_uri
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
data "archive_file" "dummy_source_export_diasource_min_ssp" {
  type        = "zip"
  output_path = "${path.module}/dummy_source_export_diasource_min_ssp.zip"

  source {
    content  = "def export_diasource_min_ssp(event, context=None):\n    return 'OK'"
    filename = "main.py"
  }
}

# Upload the dummy zip to Cloud Storage
resource "google_storage_bucket_object" "placeholder_zip_export_diasource_min_ssp" {
  name   = "source/placeholder-export-diasource-min-ssp.zip"
  bucket = google_storage_bucket.config.id
  source = data.archive_file.dummy_source_export_diasource_min_ssp.output_path
}
