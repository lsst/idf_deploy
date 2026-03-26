locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${module.constants.values.org_id}"
}

# ---------------------------------
#  TOP level folders
# ---------------------------------

module "top_folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 5.1"

  parent = local.parent
  names  = var.folder_names

  depends_on = [module.org_shared_services]
}
