/*************************************************
  Import Constants.
*************************************************/
module "constants" {
  source = "../constants"
}

locals {
  parent_resource_id   = var.parent_folder != "" ? var.parent_folder : module.constants.values.org_id
  parent_resource_type = var.parent_folder != "" ? "folder" : "organization"
}
