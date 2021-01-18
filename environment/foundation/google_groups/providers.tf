# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  backend "gcs" {
    bucket = "lsst-terraform-state"
    prefix = "foundation/google_groups"
  }
  required_providers {
    google      = "~> 3.1"
    google-beta = "~> 3.1"
  }
}