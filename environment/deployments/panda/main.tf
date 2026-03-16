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

// Grant service account IAM permission
// SA was created outside of TF
resource "google_project_iam_member" "sa-gcs-access" {
  for_each = toset(var.project_iam_sa_gcs_access)
  project  = module.project_factory.project_id
  role     = each.value
  member   = "serviceAccount:gcs-access@panda-dev-1a74.iam.gserviceaccount.com"
}

module "service_account_panda" {
  source     = "terraform-google-modules/service-accounts/google"
  version = ">= 4.0"
  project_id = module.project_factory.project_id
  prefix     = var.environment
  names      = ["panda-harvester"]
  project_roles = [
    "${module.project_factory.project_id}=>roles/container.developer",
  ]
}

module "firewall_1" {
  source = "../../../modules/firewall"

  project_id   = module.project_factory.project_id
  network      = module.project_factory.network_name
  custom_rules = var.custom_rules
}

// Create fw rule to allow-ssh for PyCharm Access
module "firewall_2" {
  source = "../../../modules/firewall"

  project_id   = module.project_factory.project_id
  network      = module.project_factory.network_name
  custom_rules = var.custom_rules2
}

# 2-1-2022 by Aaron Strong
# The module nat block has been commented out because we're using new tech preview features
# that are not available to the API. This block is failing our build pipeline.

# module "nat" {
#   source = "../../../modules/cloud_nat"

#   project_id             = module.project_factory.project_id
#   region                 = var.default_region
#   network                = module.project_factory.network_name
#   router_name            = var.router_name
#   address_count          = var.address_count
#   address_name           = var.address_name
#   address_type           = var.address_type
#   nat_ip_allocate_option = var.nat_ip_allocate_option
#   min_ports_per_vm       = var.min_ports_per_vm
#   nat_name               = "${var.application_name}-${var.environment}-cloud-nat"
#   log_config_enable      = var.log_config_enable
#   log_config_filter      = var.log_config_filter
#   address_labels = {
#     application_name = var.application_name
#     environment      = var.environment
#   }
# }

data "google_compute_network" "my-network" {
  name    = "panda-dev-vpc"
  project = module.project_factory.project_id
}

data "google_compute_subnetwork" "my-subnetwork" {
  name    = "subnet-us-central1-01"
  region  = "us-central1"
  project = module.project_factory.project_id
}

resource "google_compute_address" "external_ip_address" {
  name    = "public-ip"
  region  = var.default_region
  project = module.project_factory.project_id
}


// Storage Bucket
module "storage_bucket" {
  source             = "../../../modules/bucket"
  project_id         = module.project_factory.project_id
  storage_class      = "REGIONAL"
  location           = "us-central1"
  suffix_name        = ["logging", "containers"]
  prefix_name        = "drp-us-central1"
  bucket_policy_only = var.bucket_policy_only
  versioning = {
    logging    = true
    containers = true
  }
  force_destroy = {
    logging    = false
    containers = false
  }
  labels = {
    environment = var.environment
    application = var.application_name
  }
}
