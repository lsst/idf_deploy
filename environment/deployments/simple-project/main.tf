module "project_factory" {
  source           = "../../../modules/project_iam_vpc"
  org_id           = var.org_id
  folder_id        = var.folder_id
  billing_account  = var.billing_account
  project_prefix   = var.project_prefix
  cost_centre      = var.cost_centre
  application_name = var.application_name
  environment      = var.environment
  group_name       = var.group_name
  activate_apis    = var.activate_apis
  budget_amount    = var.budget_amount
}

module "gke" {
  source            = "../../../modules/gke"
  network           = var.network_name
  project_id        = module.project_factory.project_id
  subnetwork        = "subnet-01"
  skip_provisioners = true
}

module "filestore" {
  source             = "../../../modules/filestore"
  fileshare_capacity = 2660
  fileshare_name     = "share1"
  modes = [
    "MODE_IPV4"
  ]
  name    = "test-instance"
  network = var.network_name
  project = module.project_factory.project_id
  tier    = "STANDARD"
  zone    = "us-central1-b"
}