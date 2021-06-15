terraform {
  required_version = ">= 0.12.29"
}

# ---------------------------------------------------------------------
# Reserve a regional static ip address
# ---------------------------------------------------------------------

resource "google_compute_address" "static" {
  provider     = google-beta
  name         = var.static_name
  address      = var.address
  address_type = var.address_type
  description  = var.description
  network_tier = var.network_tier
  labels       = var.labels
  region       = var.region
  project      = var.project_id
}