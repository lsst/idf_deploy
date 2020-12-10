# ------------------------------------------------------------
#   BACKEND BLOCK
# ------------------------------------------------------------

terraform {
  backend "gcs" {
    bucket = "lsst-terraform-state"
    prefix = "qserv/dev/vpc_peer"
  }
  required_providers {
    google      = "~> 3.1"
    google-beta = "~> 3.1"
  }
}