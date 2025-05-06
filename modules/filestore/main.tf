resource "google_filestore_instance" "instance" {
  provider = google-beta

  project     = var.project
  name        = var.name
  location    = var.zone
  tier        = var.tier
  description = var.description
  labels      = var.labels


  file_shares {
    capacity_gb = var.fileshare_capacity
    name        = var.fileshare_name
  }

  networks {
    network = var.network
    modes   = var.modes
  }
}
