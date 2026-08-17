# USDF Replication Service Account

resource "google_service_account" "usdf_replication" {
  account_id   = "usdf-replication"
  display_name = "Terraform-managed service account for USDF Replication"
  project      = local.project_id
}

resource "google_pubsub_topic_iam_member" "usdf_replication_stage_chunk_topic" {
  topic   = google_pubsub_topic.stage_chunk_topic.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.usdf_replication.email}"
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

resource "google_storage_bucket_iam_member" "usdf_replication_gcs_config_viewer" {
  bucket = google_storage_bucket.config.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.usdf_replication.email}"
}

# IAM database user for CloudSQL
resource "google_sql_user" "usdf_replication_iam_sql_user" {
  name     = split(".gserviceaccount.com", google_service_account.usdf_replication.email)[0]
  instance = local.sql_instance_name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
  project  = local.project_id
}
