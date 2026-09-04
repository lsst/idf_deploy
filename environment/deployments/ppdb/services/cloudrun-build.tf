# Track Chunks Build Account
resource "google_service_account" "cloudrun_build" {
  account_id   = "cloud-run-build"
  display_name = "Terraform-managed service account for Cloud Run builds"
  project      = local.project_id
}

resource "google_project_iam_member" "cloudrun_build_build_object_viewer" {
  project = local.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cloudrun_build.email}"
}

resource "google_project_iam_member" "cloudrun_build_artifact_registry_writer" {
  project = local.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloudrun_build.email}"
}

resource "google_project_iam_member" "cloudrun_build_logs_writer" {
  project = local.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_build.email}"
}

