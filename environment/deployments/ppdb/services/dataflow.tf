# Dataflow Service Account

resource "google_service_account" "dataflow_stage_chunk" {
  account_id   = "dataflow-stage-chunk"
  display_name = "Terraform-managed service account for dataflow stage chunk"
  project      = local.project_id
}

resource "google_pubsub_topic_iam_member" "dataflow_track_chunk_track_chunk_topic" {
  topic  = google_pubsub_topic.track_chunk_topic.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_stage_chunks_dataflow_worker" {
  role    = "roles/dataflow.worker"
  member  = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_stage_chunks_logging_writer" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = local.project_id
}

resource "google_storage_bucket_iam_member" "dataflow_stage_chunks_ingest_object_viewer" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
}

resource "google_project_iam_member" "dataflow_stage_chunks_storage_object_admin" {
  role    = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_stage_chunks_artifact_registry_reader" {
  role    = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_stage_chunks_bigquery_job_user" {
  role    = "roles/bigquery.jobUser"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_stage_chunks_bigquery_data_editor" {
  role    = "roles/bigquery.dataEditor"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = local.project_id
}

# Dataflow Service Account for Load SSO

resource "google_service_account" "dataflow_load_sso" {
  account_id   = "dataflow-load-sso"
  display_name = "Terraform-managed service account for dataflow load sso"
  project      = local.project_id
}

resource "google_project_iam_member" "dataflow_load_sso_dataflow_worker" {
  role    = "roles/dataflow.worker"
  member  = "serviceAccount:${google_service_account.dataflow_load_sso.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_load_sso_logging_writer" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.dataflow_load_sso.email}"
  project = local.project_id
}

resource "google_storage_bucket_iam_member" "dataflow_load_sso_ingest_object_viewer" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.dataflow_load_sso.email}"
}

resource "google_project_iam_member" "dataflow_load_sso_storage_object_admin" {
  role    = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataflow_load_sso.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_load_sso_artifact_registry_reader" {
  role    = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.dataflow_load_sso.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_load_sso_bigquery_job_user" {
  role    = "roles/bigquery.jobUser"
  member = "serviceAccount:${google_service_account.dataflow_load_sso.email}"
  project = local.project_id
}

resource "google_project_iam_member" "dataflow_load_sso_bigquery_data_editor" {
  role    = "roles/bigquery.dataEditor"
  member = "serviceAccount:${google_service_account.dataflow_load_sso.email}"
  project = local.project_id
}