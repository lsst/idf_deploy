module "project" {
  source = "terraform-google-modules/project-factory/google"

  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  activate_apis           = var.activate_apis
  name                    = var.project_prefix
  org_id                  = var.org_id
  billing_account         = var.billing_account
  folder_id               = var.folder_id
  skip_gcloud_download    = var.skip_gcloud_download
  default_service_account = var.default_service_account

  shared_vpc         = var.vpc_type == "" ? "" : data.google_compute_network.shared_vpc[0].project
  shared_vpc_subnets = var.vpc_type == "" ? [] : data.google_compute_network.shared_vpc[0].subnetworks_self_links # Optional: To enable subnetting, to replace to "module.networking_project.subnetwork_self_link"

  labels = {
    environment      = var.environment
    application_name = var.application_name
    vpc_type         = var.vpc_type
  }
  budget_alert_spent_percents = var.budget_alert_spent_percents
  budget_amount               = var.budget_amount

}

