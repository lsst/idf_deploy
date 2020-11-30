module "project_factory" {
  source           = "../../../modules/project_iam_vpc"
  org_id           = var.org_id
  folder_id        = var.folder_id
  billing_account  = var.billing_account
  project_prefix   = var.project_prefix
  cost_centre      = var.cost_centre
  application_name = var.application_name
  environment      = var.environment
  activate_apis    = var.activate_apis
  budget_amount    = var.budget_amount
}

module "iam_admin" {
  source                  = "../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

module "gke" {
  source            = "../../../modules/gke"
  network           = module.project_factory.network_name
  project_id        = module.project_factory.project_id
  subnetwork        = module.project_factory.subnets_names[0]
  skip_provisioners = true
}

module "filestore" {
  source             = "../../../modules/filestore"
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