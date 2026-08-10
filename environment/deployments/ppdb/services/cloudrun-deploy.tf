# PPDB Cloud Run Deploy Service Account

resource "google_service_account" "cloudrun_deploy" {
  account_id   = "cloudrun-deploy"
  display_name = "Terraform-managed service account to deploy Cloud Run functions"
  project      = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_functions_developer" {
  role    = "roles/cloudfunctions.developer"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_run_developer" {
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_service_account_user" {
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_builds_editor" {
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_artifact_registry_writer" {
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_storage_admin" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_storage_object_admin" {
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}

resource "google_project_iam_member" "cloudrun_deploy_service_account_token_creator" {
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.cloudrun_deploy.email}"
  project = local.project_id
}
