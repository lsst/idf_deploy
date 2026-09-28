resource "google_service_account" "snd_transfer" {
  account_id   = "snd-transfer"
  display_name = "Service account to transfer SND files to GCS"
  project      = local.project_id
}

resource "google_storage_bucket_iam_member" "snd_transfer_web_storage_user" {
  bucket = google_storage_bucket.snd_web.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.snd_transfer.email}"
}

resource "google_storage_bucket_iam_member" "snd_transfer_api_storage_user" {
  bucket = google_storage_bucket.snd_api.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.snd_transfer.email}"
}
