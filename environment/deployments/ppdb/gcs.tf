resource "google_storage_bucket" "config" {
  name          = "ppdb-${var.environment}-config"
  project       = module.project_factory.project_id
  location      = "US-CENTRAL1"
  storage_class = var.config_gcs_storage_class
  versioning {
    enabled = var.config_gcs_versioning
  }
}

resource "google_storage_bucket" "dataflow" {
  name          = "ppdb-${var.environment}-dataflow"
  project       = module.project_factory.project_id
  location      = "US-CENTRAL1"
  storage_class = var.dataflow_gcs_storage_class
  versioning {
    enabled = var.dataflow_gcs_versioning
  }
}

resource "google_storage_bucket" "export" {
  name          = "ppdb-${var.environment}-export"
  project       = module.project_factory.project_id
  location      = "US-CENTRAL1"
  storage_class = var.export_gcs_storage_class
  versioning {
    enabled = var.export_gcs_versioning
  }
}

resource "google_storage_bucket" "ingest" {
  name          = "ppdb-${var.environment}-ingest"
  project       = module.project_factory.project_id
  location      = "US-CENTRAL1"
  storage_class = var.ingest_gcs_storage_class
  versioning {
    enabled = var.ingest_gcs_versioning
  }
}

