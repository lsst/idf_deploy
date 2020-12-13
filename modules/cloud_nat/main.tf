# --------------------------------------------------------------
#   SOURCES
# --------------------------------------------------------------
// Create Cloud Router
resource "google_compute_router" "default_router" {
  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = var.network
}

// Reserve External IP address
resource "google_compute_address" "external_addresses" {
  provider     = google-beta
  count        = var.address_count
  project      = var.project_id
  name         = "${var.address_name}-${count.index}"
  region       = var.region
  address_type = var.address_type
  network_tier = var.network_tier
  labels       = var.address_labels
}

// Create Cloud NAT
resource "google_compute_router_nat" "default_nat" {
  name                               = var.nat_name
  project                            = var.project_id
  router                             = google_compute_router.default_router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = google_compute_address.external_addresses.*.self_link
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  log_config {
    filter = var.log_config_filter
    enable = var.log_config_enable
  }
}