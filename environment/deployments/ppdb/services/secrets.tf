# Secret versions are populated directly in Secret Manager, outside Terraform.
resource "google_secret_manager_secret" "sentry_dsn" {
  project   = local.project_id
  secret_id = "sentry-dsn"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "sentry_dsn_accessor" {
  for_each = {
    cloudrun_track_chunks        = google_service_account.cloudrun_track_chunks.email
    cloudrun_trigger_stage_chunk = google_service_account.cloudrun_trigger_stage_chunk.email
    cloudrun_load_sso            = google_service_account.cloudrun_load_sso.email
    cloudrun_promote_chunks      = google_service_account.cloudrun_promote_chunks.email
    dataflow_stage_chunk         = google_service_account.dataflow_stage_chunk.email
    dataflow_load_sso            = google_service_account.dataflow_load_sso.email
  }

  project   = local.project_id
  secret_id = google_secret_manager_secret.sentry_dsn.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${each.value}"
}
