module "project-test-1" {
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