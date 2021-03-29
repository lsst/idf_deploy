module "project_factory" {
  source                      = "../../../modules/project_vpc"
  org_id                      = var.org_id
  folder_id                   = var.folder_id
  billing_account             = var.billing_account
  project_prefix              = "${var.application_name}-${var.environment}"
  application_name            = var.application_name
  environment                 = var.environment
  activate_apis               = var.activate_apis
  budget_amount               = var.budget_amount
  budget_alert_spent_percents = var.budget_alert_spent_percents
  network_name                = var.network_name
  subnets                     = var.subnets
  secondary_ranges            = var.secondary_ranges
  routing_mode                = var.routing_mode
}

module "iam_admin" {
  source                  = "../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

module "service_account_cluster" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 2.0"
  project_id = module.project_factory.project_id
  prefix     = var.environment
  names      = ["cluster"]
  project_roles = [
    "${module.project_factory.project_id}=>roles/container.clusterAdmin",
  ]
}


module "firewall_1" {
  source = "../../../modules/firewall"

  project_id   = module.project_factory.project_id
  network      = module.project_factory.network_name
  custom_rules = var.custom_rules
}

module "nat" {
  source = "../../../modules/cloud_nat"

  project_id        = module.project_factory.project_id
  region            = var.default_region
  network           = module.project_factory.network_name
  router_name       = var.router_name
  address_count     = var.address_count
  address_name      = var.address_name
  address_type      = var.address_type
  nat_name          = "${var.application_name}-${var.environment}-cloud-nat"
  log_config_enable = var.log_config_enable
  log_config_filter = var.log_config_filter
  address_labels = {
    application_name = var.application_name
    environment      = var.environment
  }
}

data "google_compute_network" "my-network" {
  name    = "panda-dev-vpc"
  project = module.project_factory.project_id
}

data "google_compute_subnetwork" "my-subnetwork" {
  name    = "subnet-us-central1-01"
  region  = "us-central1"
  project = module.project_factory.project_id
}

// Enable Identity Aware Proxy
module "iap_tunnel" {
  source  = "../../../modules/iap"
  project = module.project_factory.project_id
  network = data.google_compute_network.my-network.self_link
  members = ["group:gcp-panda-administrators@lsst.cloud"]
  instances = [{
    name = "submit-001"
    zone = "us-central1-a"
  }]
  depends_on = [module.vm]
}

resource "google_compute_address" "ip_address" {
  name = "external-ip"
  region = var.default_region
}

locals {
  access_config = {
    nat_ip       = google_compute_address.ip_address.address
    network_tier = "PREMIUM"
  }
}

// Create a Private Instance
module "vm" {
  source     = "../../../modules/compute"
  project_id = module.project_factory.project_id
  subnetwork = data.google_compute_subnetwork.my-subnetwork.self_link
  hostname   = "submit"
  access_config = [local.access_config]

  depends_on = [
    google_compute_address.ip_address
  ]
}
