module "project_factory" {
  source           = "../../../modules/project_vpc"
  org_id           = var.org_id
  folder_id        = var.folder_id
  billing_account  = var.billing_account
  project_prefix   = "${var.application_name}-${var.environment}"
  application_name = var.application_name
  environment      = var.environment
  activate_apis    = var.activate_apis
  budget_amount    = var.budget_amount
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
  routing_mode     = var.routing_mode
}

module "iam_admin" {
  source                  = "../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

module "filestore" {
  source             = "../../../modules/filestore"
  fileshare_capacity = var.fileshare_capacity
  fileshare_name     = var.fileshare_name
  modes              = var.modes
  name               = "${var.name}-${var.environment}"
  network            = module.project_factory.network_name
  project            = module.project_factory.project_id
  tier               = var.tier
  zone               = var.zone

  depends_on = [module.project_factory]
}

module "nat" {
  source  = "../../../modules/nat"
  name    = var.router_name
  project = module.project_factory.project_id
  network = module.project_factory.network_name
  region  = var.default_region
  nats    = var.nats
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

module "firewall_cert_manager" {
  source = "../../../modules/firewall"

  project_id = module.project_factory.project_id
  network    = module.project_factory.network_name
  custom_rules = {
    cert-manager = {
      description          = "cert manager rule"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = []
      sources              = []
      targets              = ["gke-${var.application_name}-${var.environment}"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["8443"]
        }
      ]
      extra_attributes = {}
    }

  }
}

module "reserve_static_ip" {
  source = "../../../modules/ip_reservation"

  project = module.project_factory.project_id
  region  = var.default_region
  name    = var.static_ip_name
}