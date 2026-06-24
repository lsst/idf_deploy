resource "google_artifact_registry_repository" "ppdb_repo" {
  location      = "us-central1"
  repository_id = "ppdb-repo"
  description   = "Docker repository for PPDB Container images"
  format        = "DOCKER"
  project       = local.project_id

  cleanup_policies {
    id     = "docker image cleanup"
    action = "KEEP"
    most_recent_versions {
      keep_count = var.ppdb_repo_image_keep_count
    }
  }
}
