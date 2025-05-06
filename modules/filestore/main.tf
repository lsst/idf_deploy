resource "google_filestore_instance" "instance" {
  project     = var.project
  name        = var.name
  location    = var.location
  tier        = var.tier
  description = var.description
  labels      = var.labels

  file_shares {
    capacity_gb = var.capacity
    name        = var.share_name
  }

  networks {
    network = var.network
    modes   = var.modes
  }
}
