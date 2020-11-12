
module "vpn_ha" {
  source     = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version    = "~> 1.4"
  project_id = var.project_id
  region     = var.region
  network    = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/${var.network}"
  name       = var.name
  peer_external_gateway = {
    redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
    interfaces = [{
      id         = 0
      ip_address = "8.8.8.8" # on-prem router ip address

    }]
  }
  router_asn = var.router_asn
  router_name = var.router_name
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = "mySecret"
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = 0
      shared_secret                   = "mySecret"
    }
  }
}