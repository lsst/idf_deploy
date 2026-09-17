# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  backend "gcs" {}
  required_providers {
    google      = ">= 6.26"
    google-beta = ">= 6.26"
  }
}

provider "google" {
  project = local.project_id
}

provider "google-beta" {
  project = local.project_id
}