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

# Chunk Ingest GCS Bucket, where replica chunks are uploaded for staging
resource "google_storage_bucket" "chunk_ingest" {
  name          = "ppdb-${var.environment}-chunk-ingest"
  project       = local.project_id
  location      = "US-CENTRAL1"
  storage_class = var.chunk_ingest_gcs_storage_class
  versioning {
    enabled = var.chunk_ingest_gcs_versioning
  }
}

# SSO Ingest GCS Bucket
resource "google_storage_bucket" "sso_ingest" {
  name          = "ppdb-${var.environment}-sso-ingest"
  project       = local.project_id
  location      = "US-CENTRAL1"
  storage_class = var.sso_ingest_gcs_storage_class
  versioning {
    enabled = var.sso_ingest_gcs_versioning
  }

  # Set the retention on uploaded SSO files to 30 days.
  lifecycle_rule {
    condition {
      age = var.sso_ingest_gcs_retention_days
    }
    action {
      type = "Delete"
    }
  }
}

# DiaSource Min SSP Export GCS Bucket, where the export-diasource-min-ssp
# function writes the DiaSource columns that SSP needs after each promotion
resource "google_storage_bucket" "diasource_min_ssp_export" {
  name          = "ppdb-${var.environment}-diasource-min-ssp-export"
  project       = local.project_id
  location      = "US-CENTRAL1"
  storage_class = var.diasource_min_ssp_export_gcs_storage_class
  versioning {
    enabled = var.diasource_min_ssp_export_gcs_versioning
  }

  # Each export is the whole table, so old exports aren't kept.
  lifecycle_rule {
    condition {
      age = var.diasource_min_ssp_export_gcs_retention_days
    }
    action {
      type = "Delete"
    }
  }
}
