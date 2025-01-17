# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  backend "gcs" {
  }
  required_providers {
    google      = ">= 5.0.0"
    google-beta = ">= 5.0.0"
  }
}