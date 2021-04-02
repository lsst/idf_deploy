// Storage Bucket
module "storage_bucket" {
  source        = "../../../../modules/bucket"
  project_id    = var.project_id
  storage_class = var.storage_class
  location      = var.location
  prefix_name   = var.prefix_name
  suffix_name   = var.suffix_name 
  versioning    = var.versioning
  force_destroy = var.force_destroy
  labels = {
    environment = var.environment
    application = var.application_name
  }
}
