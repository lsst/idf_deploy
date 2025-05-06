# A given RSP instance at the IDF may have an arbitrary number of Filestore
# volumes.
#
# This is for volumes that do not need individual quotas; Firefly workspace
# and shared read-only data are two examples.

resource "google_filestore_instance" "instance" {
  project     = var.project
  name        = var.name
  location    = var.location
  tier        = var.tier
  description = var.description
  labels      = var.labels


  file_shares {
    capacity_gb = var.capacity
    name        = var.fileshare_name
  }

  networks {
    network = var.network
    modes   = var.modes
  }
}
