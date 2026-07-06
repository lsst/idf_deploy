# PPDB GitHub CI Tests

resource "google_service_account" "gh_ci" {
  for_each = var.create_gh_ci_sa ? { "enabled" = true } : {}
  account_id   = "github-ci"
  display_name = "Terraform-managed service account for GitHub CI tests"
  project      = local.project_id
}

resource "google_project_iam_member" "github_ci_bigquery_data_editor" {
  for_each = var.create_gh_ci_sa ? { "enabled" = true } : {}
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.gh_ci["enabled"].email}"
  project = local.project_id
}

resource "google_project_iam_member" "github_ci_storage_admin" {
  for_each = var.create_gh_ci_sa ? { "enabled" = true } : {}
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gh_ci["enabled"].email}"
  project = local.project_id
}