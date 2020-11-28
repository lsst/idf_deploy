module "science_platform_qa_project" {
  source           = "../../../modules/project_iam_vpc"
  org_id           = var.org_id
  folder_id        = var.folder_id
  billing_account  = var.billing_account
  project_prefix   = var.project_prefix
  cost_centre      = var.cost_centre
  application_name = var.application_name
  environment      = var.environment
  group_name       = var.group_name
}

# module "gke" {
#   source = "./gke"

#   project_id = module.science_platform_qa_project.project_id
#   network    = var.network_name
#   subnetwork = "subnet-01"
# }