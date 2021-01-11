module "iap_tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "~> 2.10.0"

  project          = var.project
  host_project     = var.host_project
  network          = var.network
  service_accounts = var.service_accounts
  network_tags     = var.network_tags
  instances        = var.instances
  members          = var.members
  additional_ports = var.additional_ports

  depends_on = [google_project_service.project]
}

// Enable IAP API

resource "google_project_service" "project" {
  project = var.project
  service = "iap.googleapis.com"

  disable_on_destroy = true
}