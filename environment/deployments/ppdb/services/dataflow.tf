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
