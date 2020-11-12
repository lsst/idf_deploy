# -------------------------------
#   PROJECT for Monitoring
# -------------------------------

module "org_monitoring" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-monitoring"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = ["logging.googleapis.com", "monitoring.googleapis.com", "stackdriver.googleapis.com"]
  auto_create_network     = var.auto_create_network
  skip_gcloud_download    = var.skip_gcloud_download
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain
  labels = {
    owner            = module.constants.values.core_projects_owner
    environment      = var.label_environment
    service     = "org-monitoring"
    application = "org-monitoring"
  }
}

# -------------------------------
#   PROJECT for InfoSec/logging
# -------------------------------

module "org_audit_logs" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-infosec"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = ["logging.googleapis.com", "bigquery.googleapis.com", "stackdriver.googleapis.com", "pubsub.googleapis.com", "securitycenter.googleapis.com"]
  auto_create_network     = var.auto_create_network
  skip_gcloud_download    = var.skip_gcloud_download
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain
  labels = {
    owner            = module.constants.values.core_projects_owner
    environment      = var.label_environment
    service     = "org-audit-logs"
    application = "org-audit-logs"
  }
}

# -------------------------------
#   PROJECT for Shared VPC
# -------------------------------

module "org_shared_vpc" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-shared-vpc"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = ["compute.googleapis.com", "container.googleapis.com", "stackdriver.googleapis.com", "dns.googleapis.com", "servicenetworking.googleapis.com"]
  auto_create_network     = var.auto_create_network
  skip_gcloud_download    = var.skip_gcloud_download
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain

  labels = {
    owner            = module.constants.values.core_projects_owner
    environment      = var.label_environment
    application      = "org-shared-vpc-prod"
    service          = "org-shared-vpc-prod"
    application_name = "org-shared-vpc-prod" # Do not change. Used in 2-network as a lookup variable
  }
}
