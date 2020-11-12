locals {
  prod_host_project_id = data.google_projects.prod_host_project.projects[0].project_id
}

# ----------------------------------------
#   VPC Host Projects
# ----------------------------------------

data "google_projects" "prod_host_project" {
  filter = "labels.application_name=${var.label_application_name} labels.owner=${module.constants.values.core_projects_owner}"
}

# ----------------------------------------
#   Import Constants.
# ----------------------------------------
module "constants" {
  source = "../constants"
}

# ----------------------------------------
#   Shared VPCs
# ----------------------------------------

module "shared_vpc_prod" {
  source         = "./modules/standard_shared_vpc"
  project_id     = local.prod_host_project_id
  default_region = module.constants.values.default_region
  network_name   = var.network_name
  subnets        = "${var.subnets}"
}