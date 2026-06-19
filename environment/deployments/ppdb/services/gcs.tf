# Config GCS Bucket
resource "google_storage_bucket" "config" {
  name          = "ppdb-${var.environment}-config"
  project       = local.project_id
  location      = "US-CENTRAL1"
  storage_class = var.config_gcs_storage_class
  versioning {
    enabled = var.config_gcs_versioning
  }
}

# Dataflow GCS Bucket
resource "google_storage_bucket" "dataflow" {
  name          = "ppdb-${var.environment}-dataflow"
  project       = local.project_id
  location      = "US-CENTRAL1"
  storage_class = var.dataflow_gcs_storage_class
  versioning {
    enabled = var.dataflow_gcs_versioning
  }
}

# Export GCS Bucket
resource "google_storage_bucket" "export" {
  name          = "ppdb-${var.environment}-export"
  project       = local.project_id
  location      = "US-CENTRAL1"
  storage_class = var.export_gcs_storage_class
  versioning {
    enabled = var.export_gcs_versioning
  }
}

# Ingest GCS Bucket
resource "google_storage_bucket" "ingest" {
  name          = "ppdb-${var.environment}-ingest"
  project       = local.project_id
  location      = "US-CENTRAL1"
  storage_class = var.ingest_gcs_storage_class
  versioning {
    enabled = var.ingest_gcs_versioning
  }
}
