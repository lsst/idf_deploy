# USDF Replication Service Account

resource "google_service_account" "usdf_replication" {
  account_id   = "usdf-replication"
  display_name = "Terraform-managed service account for USDF Replication"
  project      = module.project_factory.project_id
}

resource "google_pubsub_topic_iam_member" "usdf_replication_stage_chunk_topic" {
  topic  = google_pubsub_topic.stage_chunk_topic.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.usdf_replication.email}"
  project = module.project_factory.project_id
}

resource "google_project_iam_member" "usdf_replication_cloudsql_client" {
  project = module.project_factory.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.usdf_replication.email}"
}

resource "google_project_iam_member" "usdf_replication_cloudsql_instance_user" {
  project = module.project_factory.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.usdf_replication.email}"
}

resource "google_storage_bucket_iam_member" "usdf_replication_gcs" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.usdf_replication.email}"
}

# Dataflow Service Account

resource "google_service_account" "dataflow_stage_chunk" {
  account_id   = "dataflow-stage-chunk"
  display_name = "Terraform-managed service account for dataflow stage chunk"
  project      = module.project_factory.project_id
}

resource "google_pubsub_topic_iam_member" "dataflow_track_chunk_track_chunk_topic" {
  topic  = google_pubsub_topic.track_chunk_topic.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
  project = module.project_factory.project_id
}

resource "google_project_iam_member" "dataflow_stage_chunks_dataflow_worker" {
  project = module.project_factory.project_id
  role    = "roles/dataflow.worker"
  member  = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
}

resource "google_project_iam_member" "dataflow_stage_chunks_logging_writer" {
  project = module.project_factory.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
}

resource "google_storage_bucket_iam_member" "dataflow_stage_chunks_ingest_object_viewer" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.dataflow_stage_chunk.email}"
}

# Cloud Run Trigger Stage Chunk Service Account

resource "google_service_account" "cloudrun_trigger_stage_chunk" {
  account_id   = "cloudrun-trigger-stage-chunk"
  display_name = "Terraform-managed service account for cloud run trigger stage chunk"
  project      = module.project_factory.project_id
}

resource "google_project_iam_member" "cloudrun_trigger_stage_chunk_dataflow" {
  project = module.project_factory.project_id
  role    = "roles/dataflow.developer"
  member  = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
}

resource "google_pubsub_topic_iam_member" "cloudrun_trigger_stage_chunk_sa_stage_chunk_topic" {
  topic  = google_pubsub_topic.stage_chunk_topic.id
  role   = "roles/pubsub.subscriber"
  member = "serviceAccount:${google_service_account.cloudrun_trigger_stage_chunk.email}"
  project = module.project_factory.project_id
}

# Cloud Run Promote Chunks Service Account

resource "google_service_account" "cloudrun_promote_chunks" {
  account_id   = "cloudrun-promote-chunks"
  display_name = "Terraform-managed service account for Cloud Run to promote chunks"
  project      = module.project_factory.project_id
}

resource "google_storage_bucket_iam_member" "cloudrun_promote_chunks_ingest_object_viewer" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
}

resource "google_bigquery_dataset_access" "cloudrun_promote_chunks_staging_dataset_editor" {
  dataset_id = google_bigquery_dataset.ppdb_staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  iam_member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
  project = module.project_factory.project_id
}

resource "google_project_iam_member" "cloudrun_promote_chunks_bq_job_user" {
  project = module.project_factory.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
}

resource "google_project_iam_member" "cloudrun_promote_chunks_sql_client" {
  project = module.project_factory.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
}

resource "google_project_iam_member" "cloudrun_promote_chunks_sql_instance_user" {
  project = module.project_factory.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.cloudrun_promote_chunks.email}"
}

# Cloud Run Track Chunks Service Account

resource "google_service_account" "cloudrun_track_chunks" {
  account_id   = "cloudrun-track-chunks"
  display_name = "Terraform-managed service account for Cloud Run to track chunks"
  project      = module.project_factory.project_id
}

resource "google_project_iam_member" "cloudrun_track_chunks_sql_client" {
  project = module.project_factory.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_track_chunks.email}"
}

resource "google_project_iam_member" "cloudrun_track_chunks_sql_instance_user" {
  project = module.project_factory.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.cloudrun_track_chunks.email}"
}

resource "google_pubsub_topic_iam_member" "cloudrun_trigger_stage_chunk_stage_chunk_topic" {
  topic  = google_pubsub_topic.track_chunk_topic.id
  role   = "roles/pubsub.subscriber"
  member = "serviceAccount:${google_service_account.cloudrun_track_chunks.email}"
  project = module.project_factory.project_id
}