module "gcs_bucket" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 1.7.0"

  project_id           = var.project_id
  names                = var.suffix_name
  prefix               = var.prefix_name
  set_admin_roles      = var.set_admin_roles
  admins               = var.admins
  versioning           = var.versioning
  bucket_policy_only   = var.bucket_policy_only
  bucket_admins        = var.bucket_admins
  bucket_creators      = var.bucket_creators
  bucket_viewers       = var.bucket_viewers
  creators             = var.creators
  encryption_key_names = var.encryption_key_names
  folders              = var.folders
  force_destroy        = var.force_destroy
  labels               = var.labels
  location             = var.location
  set_creator_roles    = var.set_creator_roles
  set_viewer_roles     = var.set_viewer_roles
  storage_class        = var.storage_class
  viewers              = var.viewers
}