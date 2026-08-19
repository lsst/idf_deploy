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
  iam_member = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
  project    = local.project_id
}

resource "google_project_iam_member" "cloudrun_promote_chunks_bq_job_user" {
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_promote_chunks_bq_data_editor" {
  role    = "roles/bigquery.dataEditor"
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

# IAM database user for CloudSQL
resource "google_sql_user" "cloudrun_promote_chunks_iam_sql_user" {
  name     = split(".gserviceaccount.com", google_service_account.cloudrun_promote_chunks.email)[0]
  instance = local.sql_instance_name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
  project  = local.project_id
}

# Workflow Service Account
resource "google_service_account" "promote_chunks_workflow" {
  account_id   = "promote-chunks-workflow-runner"
  display_name = "Service Account for Promote Chunks Cloud Workflow"
  project       = local.project_id
}

resource "google_project_iam_member" "promote_chunks_workflow_cloudrun_developer" {
  project = local.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.promote_chunks_workflow.email}"
}

resource "google_project_iam_member" "promote_chunks_workflow_token_creator" {
  project = local.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.promote_chunks_workflow.email}"
}


# Workflow Definition
resource "google_workflows_workflow" "promote_chunks_run_job_workflow" {
  name            = "trigger-promote-chunks-cloudrun-job-workflow"
  region          = var.region
  description     = "Workflow that executes the promote chunks Cloud Run Job"
  service_account = google_service_account.promote_chunks_workflow.id
  project         = local.project_id

  source_contents = <<EOF
main:
  steps:
    - init:
        assign:
          - project_id: $${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
          - job_name: "${google_cloud_run_v2_job.promote_chunks.name}"
          - location: "${google_cloud_run_v2_job.promote_chunks.location}"
    - run_cloud_run_job:
        call: googleapis.run.v2.projects.locations.jobs.run
        args:
          name: $${"projects/" + project_id + "/locations/" + location + "/jobs/" + job_name}
        result: job_execution    
    - finish:
        return: $${job_execution}
EOF
}

# Cloud Scheduler

resource "google_service_account" "promote_chunks_scheduler" {
  account_id   = "promote-chunks-cloud-scheduler"
  display_name = "Promote Chunks Cloud Scheduler Workflow Invoker SA"
  project      = local.project_id
}

resource "google_project_iam_member" "promote_chunks_scheduler_workflow_invoker" {
  project = local.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.promote_chunks_scheduler.email}"
}

resource "google_cloud_scheduler_job" "promote_chunks_workflow_scheduler" {
  name             = "schedule-promote-chunks-workflow-job"
  description      = "Triggers the Promote Chunks Cloud Workflow every day"
  schedule         = var.promote_chunks_schedule
  time_zone        = var.promote_chunks_scheduler_timezone
  region           = var.region
  attempt_deadline = var.promote_chunks_scheduler_attempt_deadline
  project          = local.project_id

  http_target {
    http_method = "POST"
    # End point to trigger a workflow execution
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.promote_chunks_run_job_workflow.id}/executions"

    # Empty arguments body needed to for POST to run the workflow.
    body = base64encode(
                        <<-EOF
                            {"argument":"{}","callLogLevel":"LOG_ALL_CALLS"} 
                        EOF
                       )

    headers = {
      "content-type" = "application/octet-stream"
    }

    oauth_token {
      service_account_email = google_service_account.promote_chunks_scheduler.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}

# Cloud Run Job Definition
resource "google_cloud_run_v2_job" "promote_chunks" {
  name        = "promote-chunks"
  location    = var.region
  project     = local.project_id

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

  template{
    template{
      service_account       = google_service_account.cloudrun_promote_chunks.email
      execution_environment = var.promote_chunks_cloud_run_execution_environment
      timeout               = var.promote_chunks_timeout
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello-job:latest"

        env {
          name  = "PPDB_CONFIG_URI"
          value = var.promote_chunks_cloud_run_ppdb_config_uri
        }
        env {
          name  = "PPDB_USE_SECRET_MANAGER"
          value = var.promote_chunks_cloud_run_ppdb_use_secret_manager
        }
        env {
          name  = "CLOUDSQL_ENABLED"
          value = "true"
        }
        env {
          name  = "CLOUDSQL_IP_TYPE"
          value = "private"
        }
        env {
          name  = "CLOUDSQL_INSTANCE_CONNECTION_NAME"
          value = "${local.project_id}:${var.region}:${local.sql_instance_name}"
        }
        env {
          name  = "CLOUDSQL_USER"
          value = "${google_service_account.cloudrun_promote_chunks.account_id}@${local.project_id}.iam"
        }
        env {
          name  = "CLOUDSQL_DB_NAME"
          value = var.promote_chunks_db_name
        }
        resources {

          limits = {
            cpu    = var.promote_chunks_cloud_run_cpu_limit
            memory = var.promote_chunks_cloud_run_memory_limit
          }
        }
      }
      vpc_access {
        egress = "PRIVATE_RANGES_ONLY"
        
        network_interfaces {
          network    = local.network
          subnetwork = local.subnet
        }
      }
    }
  }

  # Lifecycle policy to ignore changes to the container image.  The deploy action in the ppdb-cloud-functions repo updates the image.
  lifecycle {
    ignore_changes = [
      template[0].template[0].containers[0].image,
      template[0].labels,
      client,
      client_version
    ]
  }
}