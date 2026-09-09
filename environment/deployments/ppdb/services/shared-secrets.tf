resource "google_secret_manager_secret" "ppdb_shared" {
  secret_id = "ppdb-shared"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "ppdb_shared" {
  secret      = google_secret_manager_secret.ppdb_shared.name
  secret_data = "PLACEHOLDER: change this manually"
}
