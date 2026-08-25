# SSO Uploader Service Account
# Publisher identity for whatever pipeline runs SSOUploader (analogous to usdf-replication)

resource "google_service_account" "sso_uploader" {
  account_id   = "sso-uploader"
  display_name = "Terraform-managed service account for uploading SSO data"
  project      = local.project_id
}

resource "google_pubsub_topic_iam_member" "sso_uploader_load_sso_topic" {
  topic   = google_pubsub_topic.load_sso_topic.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.sso_uploader.email}"
  project = local.project_id
}

resource "google_storage_bucket_iam_member" "sso_uploader_ingest_gcs" {
  bucket = google_storage_bucket.ingest.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.sso_uploader.email}"
}
