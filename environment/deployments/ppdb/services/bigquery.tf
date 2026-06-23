# PPDB Internal
resource "google_bigquery_dataset" "ppdb_internal" {
  dataset_id                 = "ppdb_internal"
  friendly_name              = "PPDB Internal"
  description                = "target tables for data drop (promotion); accessed via views from ppdb_public"
  project                    = local.project_id
  location                   = "US"
  max_time_travel_hours      = var.bigquery_max_time_travel_hours
  delete_contents_on_destroy = false
}

# PPDB Public
resource "google_bigquery_dataset" "ppdb_public" {
  dataset_id                 = "ppdb_public"
  friendly_name              = "PPDB Public"
  description                = "Publically accessible views on ppdb_internal, for TAP and other public services"
  project                    = local.project_id
  location                   = "US"
  max_time_travel_hours      = var.bigquery_max_time_travel_hours
  delete_contents_on_destroy = false
}

# PPDB Staging
resource "google_bigquery_dataset" "ppdb_staging" {
  dataset_id                 = "ppdb_staging"
  friendly_name              = "PPDB Staging"
  description                = "Staging tables and temp processing tables for data processing; target for Dataflow output"
  project                    = local.project_id
  location                   = "US"
  max_time_travel_hours      = var.bigquery_max_time_travel_hours
  delete_contents_on_destroy = false
}

# PPDB Backup
resource "google_bigquery_dataset" "ppdb_backup" {
  dataset_id                 = "ppdb_backup"
  friendly_name              = "PPDB Backup"
  description                = "Backups"
  project                    = local.project_id
  location                   = "US"
  max_time_travel_hours      = var.bigquery_max_time_travel_hours
  delete_contents_on_destroy = false
}
