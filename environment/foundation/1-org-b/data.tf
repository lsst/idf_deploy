locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${module.constants.values.org_id}"
}

# ----------------------------------------
#   Lookup parent folder by folder name
# ----------------------------------------

data "google_active_folder" "qserv_sub_folder" {
  parent       = local.parent
  display_name = var.qserv_display_name
}

data "google_active_folder" "splatform_sub_folder" {
  parent       = local.parent
  display_name = var.splatform_display_name
}

data "google_active_folder" "processing_sub_folder" {
  parent       = local.parent
  display_name = var.processing_display_name
}

data "google_active_folder" "square_sub_folder" {
  parent       = local.parent
  display_name = var.square_display_name
}

data "google_active_folder" "shared_services_folder" {
  parent       = local.parent
  display_name = var.shared_services_display_name
}