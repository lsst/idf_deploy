# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  backend "gcs" {}
  required_providers {
    google      = "~> 3.51.0"
    google-beta = "~> 3.51.0"
  }
}