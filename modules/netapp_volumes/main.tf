resource "google_netapp_storage_pool" "instance" {
  project       = var.project
  name          = var.pool_name
  location      = var.location
  service_level = var.service_level
  description   = var.description
  capacity_gib  = var.capacity_gib
  network       = var.network
}

resource "google_netapp_volume" "instance" {
  location           = var.location
  capacity           = var.capacity_gib
  name               = var.name
  share_name         = var.share_name
  storage_pool       = google_netapp_storage_pool.instance.name
  protocols          = var.protocols
  deletion_policy    = var.deletion_policy
  unix_permissions   = var.unix_permissions
  labels             = var.labels
  description        = var.description
  snapshot_directory = var.snapshot_directory
  snapshot_policy    = var.snapshot_policy
  restricted_actions = var.restricted_actions
  export_policy      = var.export_policy
  restricted_actions = var.restricted_actions
  security_style     = "UNIX"
  kerberos_enabled   = false
}
