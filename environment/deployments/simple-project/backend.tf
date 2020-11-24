terraform {
  backend "gcs" {}
  required_providers {
    google      = "~> 3.1"
    google-beta = "~> 3.1"
  }
}