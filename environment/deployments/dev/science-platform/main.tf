module "project_factory" {
  source           = "../../../../modules/project_vpc"
  org_id           = var.org_id
  folder_id        = var.folder_id
  billing_account  = var.billing_account
  project_prefix   = "${var.application_name}-${var.environment}"
  cost_centre      = var.cost_centre
  application_name = var.application_name
  environment      = var.environment
  activate_apis    = var.activate_apis
  budget_amount    = var.budget_amount
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
  routing_mode     = var.routing_mode
}

module "iam_admin" {
  source                  = "../../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

module "gke" {
  source     = "../../../../modules/gke"
  name       = "${var.application_name}-${var.environment}"
  network    = module.project_factory.network_name
  project_id = module.project_factory.project_id
  subnetwork = module.project_factory.subnets_names[0]
  cluster_resource_labels = {
    ower             = var.owner
    environment      = var.environment
    project          = module.project_factory.project_name
    application_name = var.application_name
  }

  node_pools_labels = {
    all = {
      ower             = var.owner
      environment      = var.environment
      project          = module.project_factory.project_name
      application_name = var.application_name
    }
  }
}

module "filestore" {
  source             = "../../../../modules/filestore"
  fileshare_capacity = var.fileshare_capacity
  fileshare_name     = var.fileshare_name
  modes              = var.modes
  name               = var.name
  network            = module.project_factory.network_name
  project            = module.project_factory.project_id
  tier               = var.tier
  zone               = var.zone

  depends_on = [module.project_factory]
}

module "service_account_info_sec" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "~> 3.0"
  project_id   = module.project_factory.project_id
  prefix       = "${var.application_name}-${var.environment}"
  display_name = "Service Account for Kubernetes Cluster"
  description  = "A service account used for Cluster"
  names        = ["cluster-account"]
  project_roles = [
    "${module.project_factory.project_id}=>roles/container.clusterAdmin",
  ]
}