
/******************************************
  Shared VPC configuration
 *****************************************/

module "main" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 2.0"
  project_id                             = var.project_id
  network_name                           = var.network_name
  shared_vpc_host                        = "true"
  delete_default_internet_gateway_routes = "false"

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  routes = [
    {
      name              = "private-google-access"
      description       = "Route through IGW to allow private google api access."
      destination_range = "199.36.153.8/30"
      next_hop_internet = "true"
    },
    
  ]
}

/*****************************************
  Default Cloud Router & NAT config
 *****************************************/

resource "google_compute_router" "default_router" {
  name    = "default-router"
  project = var.project_id
  region  = var.default_region
  network = module.main.network_self_link

  # Uncomment if needed
  # bgp {
  #   asn = var.bgp_asn
  #   advertise_mode = "CUSTOM"
  #   advertised_groups = ["ALL_SUBNETS"]
  #   advertised_ip_ranges {
  #     range = "35.199.192.0/19"  # Range used by Google for DNS
  #     description = "Range used for Google DNS"
  #   }
  # }
}

// Commenting out the below. NAT is not required at this time.

# -----------------------------------------
# Reserve static external IPs that will be
# assigned to Cloud NAT
# -----------------------------------------

# resource "google_compute_address" "nat_external_addresses" {
#   count   = var.nat_num_addresses
#   project = var.project_id
#   name    = "nat-external-address-${count.index}"
#   region  = var.default_region
# }

# -----------------------------------------
# `nat_ip_allocation_option` is set to MANUAL
# this will assign the IPs we reserved in the
# `google_compute_address` block
# -----------------------------------------

# resource "google_compute_router_nat" "default_nat" {
#   name                               = "nat-config"
#   project                            = var.project_id
#   router                             = google_compute_router.default_router.name
#   region                             = var.default_region
#   nat_ip_allocate_option             = "MANUAL_ONLY"
#   nat_ips                            = google_compute_address.nat_external_addresses.*.self_link
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

#   log_config {
#     filter = "TRANSLATIONS_ONLY"
#     enable = true
#   }
# }