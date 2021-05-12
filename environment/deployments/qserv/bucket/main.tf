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
