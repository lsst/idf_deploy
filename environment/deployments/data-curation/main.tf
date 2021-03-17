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


// Storage Bucket
module "storage_bucket" {
  source      = "../../../modules/bucket"
  project_id  = module.project_factory.project_id
  storage_class = "REGIONAL"
  location   = "us-central1"
  suffix_name = ["desc-dc2-dr6", "desc-dc2-run22i"]
  prefix_name = "curation"
  versioning = {
    desc-dc2-dr6  = true
    desc-dc2-run22i = true
  }
  force_destroy = {
    desc-dc2-dr6  = true
    desc-dc2-run22i = true
  }
  labels = {
    environment = var.environment
    application = var.application_name
  }
}

// Storage Bucket
module "storage_bucket_2" {
  source      = "../../../modules/bucket"
  project_id  = module.project_factory.project_id
  storage_class = "REGIONAL"
  location   = "us-central1"
  suffix_name = ["dp01-dev", "dp01-int", "dp01", "panda-dev", "dp01-desc-dr6"]
  prefix_name = "butler"
  versioning = {
    dp01-dev  = true
    dp01-int  = true
    dp01      = true
    dp01-desc-dr6 = true
  }
  force_destroy = {
    dp01-dev  = true
    dp01-int  = true
    dp01      = true
    dp01-desc-dr6 = true
  }
  labels = {
    environment = var.environment
    application = var.application_name
  }
}

module "data_curation_admin_group" {
  source = "../../../modules/google_groups"

  id           = var.id
  display_name = var.display_name
  description  = var.description
  domain       = var.domain
}
