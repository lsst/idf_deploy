resource "google_compute_address" "static_ip" {
  project      = var.project
  region       = var.region
  network_tier = var.network_tier
  name         = var.name
  address_type = var.address_type
  purpose      = var.purpose
  description  = var.description

}
