# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  backend "gcs" {
  }
  required_providers {
    google      = "~> 6.26.0"
    google-beta = "~> 6.26.0"
  }
}
