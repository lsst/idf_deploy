module "storage_bucket" {
  source        = "../../../../modules/bucket"
  project_id    = var.project_id
  storage_class = "REGIONAL"
  location      = "us-central1"
  suffix_name   = var.suffix_name
  prefix_name   = var.prefix_name
  versioning    = var.versioning
  force_destroy = var.force_destroy
  labels        = var.labels
}

module "bucket_service_account" {
  source = "../../../../modules/service_accounts/"

  project_id   = var.project_id
  prefix       = var.prefix_name
  names        = ["argo-artifact"]
  display_name = "GCS Service account for qserv-dev"
  description  = "GCS access service account managed by Terraform"
  project_roles = []
}

// RW storage access to the argo artifact bucket
resource "google_storage_bucket_iam_member" "qserv_dev_rw_argo_artifact" {
  bucket = "qserv-us-central1-argo-artifact"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.bucket_service_account.email}"
}
