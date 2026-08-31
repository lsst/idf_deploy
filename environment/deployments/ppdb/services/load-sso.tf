# Cloud Run Load SSO Service Account
resource "google_service_account" "cloudrun_load_sso" {
  account_id   = "cloudrun-load-sso"
  display_name = "Terraform-managed service account for cloud run load sso"
  project      = local.project_id
}

resource "google_project_iam_member" "cloudrun_load_sso_dataflow" {
  role    = "roles/dataflow.developer"
  member  = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
  project = local.project_id
}

resource "google_storage_bucket_iam_member" "cloudrun_load_sso_dataflow_gcs_folder_viewer" {
  bucket = google_storage_bucket.dataflow.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
}

resource "google_service_account_iam_member" "cloudrun_load_sso_dataflow_sa_impersonation" {
  service_account_id = google_service_account.dataflow_load_sso.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.cloudrun_load_sso.email}"
}

# Dedicated Service Account for Eventarc
resource "google_service_account" "eventarc_sa_load_sso" {
  account_id   = "eventarc-load-sso-sa"
  display_name = "Eventarc Trigger Service Account for Load SSO"
  project      = local.project_id
}

# Grant the Event Arc Service Account permission to receive and route events
resource "google_project_iam_member" "event_receiver_load_sso" {
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc_sa_load_sso.email}"
  project = local.project_id
}

# Grant the Service Account permission to invoke the Load SSO Cloud Run service
resource "google_project_iam_member" "run_invoker_load_sso" {
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.eventarc_sa_load_sso.email}"
  project = local.project_id
}

# Event Arc Definition
resource "google_eventarc_trigger" "pubsub_trigger_load_sso" {
  name     = "load-sso"
  project  = local.project_id
  location = var.region

  service_account = google_service_account.eventarc_sa_load_sso.email

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.load_sso_topic.id
    }
  }

  destination {
    cloud_run_service {
      service = google_cloudfunctions2_function.load_sso.name
      region  = var.region
    }
  }
}

# Cloud Run Functions Gen2 Definition
resource "google_cloudfunctions2_function" "load_sso" {
  name        = "load-sso"
  project     = local.project_id
  location    = var.region
  description = "Loads SSO data via Dataflow"

  depends_on = [
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

    environment_variables = {
      DATAFLOW_TEMPLATE_PATH  = var.load_sso_cloud_run_dataflow_template_path
      LOG_LEVEL               = var.load_sso_cloud_run_log_level
      PROJECT_ID              = local.project_id
      REGION                  = var.region
      GOOGLE_CLOUD_SUBNETWORK = "https://www.googleapis.com/compute/v1/${local.subnet}"
      SERVICE_ACCOUNT_EMAIL   = google_service_account.dataflow_load_sso.email
      TEMP_LOCATION           = var.load_sso_cloud_run_temp_location
      LOG_EXECUTION_ID        = var.load_sso_cloud_run_log_execution_id
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
