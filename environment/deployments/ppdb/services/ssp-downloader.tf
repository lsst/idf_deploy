# SSP Downloader Service Account
# Identity SSP uses to read the DiaSource Min SSP exports.
# Separate from sso-uploader, so read and upload access can each be disabled
# or rotated alone.

resource "google_service_account" "ssp_downloader" {
  account_id   = "ssp-downloader"
  display_name = "Terraform-managed service account for SSP to download DiaSource exports"
  project      = local.project_id
}

resource "google_storage_bucket_iam_member" "ssp_downloader_diasource_min_ssp_export_viewer" {
  bucket = google_storage_bucket.diasource_min_ssp_export.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.ssp_downloader.email}"
}
