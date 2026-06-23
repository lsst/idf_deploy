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
