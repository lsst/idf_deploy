# GCS bucket for sdm_schemas CI release artifacts.
#
# The sdm_schemas GitHub Actions CI workflow will write out artifacts on every
# pull request from a ticket branch and on every tagged release.
# Repertoire is the customer for these artifacts and uses them to
# populate TAP_SCHEMA databases.
#
# Artifacts are publicly readable.

#---------------------------------------------------------------
// Artifact bucket
#---------------------------------------------------------------

module "sdm_schemas_artifacts_bucket" {
  source        = "../../../../modules/bucket"
  project_id    = "science-platform-dev-7696"
  storage_class = "STANDARD"
  location      = "US"
  prefix_name   = "rubin"
  suffix_name   = ["sdm-schemas-artifacts"]
  labels        = var.labels
}

resource "google_storage_bucket_iam_member" "public_read" {
  bucket = module.sdm_schemas_artifacts_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

#---------------------------------------------------------------
// Uploader service account
#---------------------------------------------------------------

module "sdm_schemas_uploader" {
  source = "../../../../modules/service_accounts/"

  project_id   = "science-platform-dev-7696"
  prefix       = "pipeline"
  names        = ["sdm-schemas-uploader"]
  display_name = "SDM Schemas artifact uploader"
  description  = "GitHub Actions service account for uploading sdm_schemas CI artifacts to GCS"
}

resource "google_storage_bucket_iam_member" "sdm_schemas_uploader_write" {
  bucket = module.sdm_schemas_artifacts_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.sdm_schemas_uploader.email}"
}
