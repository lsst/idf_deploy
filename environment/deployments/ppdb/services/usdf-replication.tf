# USDF Replication Service Account

resource "google_service_account" "usdf_replication" {
  account_id   = "usdf-replication"
  display_name = "Terraform-managed service account for USDF Replication"
  project      = local.project_id
}

resource "google_pubsub_topic_iam_member" "usdf_replication_stage_chunk_topic" {
  topic  = google_pubsub_topic.stage_chunk_topic.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.usdf_replication.email}"
  project = local.project_id
}

resource "google_project_iam_member" "usdf_replication_cloudsql_client" {
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.usdf_replication.email}"
  project = local.project_id
}

resource "google_project_iam_member" "usdf_replication_cloudsql_instance_user" {
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.usdf_replication.email}"
  project = local.project_id
}

resource "google_storage_bucket_iam_member" "usdf_replication_gcs" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.usdf_replication.email}"
}
