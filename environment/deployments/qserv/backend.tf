# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  backend "gcs" {}
  required_providers {
    google      = "~> 3.54.0"
    google-beta = "~> 3.54.0"
  }
}