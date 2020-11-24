// Qserv Folder
resource "google_folder_iam_member" "gcp_qserv_clustername_admins_iam_permissions" {
  for_each = toset(var.gcp_qserv_clustername_admins_iam_permissions)
  folder   = data.google_active_folder.qserv_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_qserv_clustername_admins}"
}

resource "google_folder_iam_member" "gcp_qserv_clustername_developer_iam_permissions" {
  for_each = toset(var.gcp_qserv_clustername_admins_iam_permissions)
  folder   = data.google_active_folder.qserv_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_qserv_clustername_developer}"
}


// Science Platform Folder
resource "google_folder_iam_member" "gcp_science_platform_clustername_admins_iam_permissions" {
  for_each = toset(var.gcp_science_platform_clustername_admins_iam_permissions)
  folder   = data.google_active_folder.splatform_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_science_platform_clustername_admins}"
}

resource "google_folder_iam_member" "gcp_science_platform_clustername_developer_iam_permissions" {
  for_each = toset(var.gcp_science_platform_clustername_developer_iam_permissions)
  folder   = data.google_active_folder.splatform_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_science_platform_clustername_developer}"
}

// Processing Folder
resource "google_folder_iam_member" "gcp_processing_clustername_admins_iam_permissions" {
  for_each = toset(var.gcp_processing_clustername_admins_iam_permissions)
  folder   = data.google_active_folder.processing_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_processing_clustername_admins}"
}
resource "google_folder_iam_member" "gcp_processing_clustername_developer_iam_permissions" {
  for_each = toset(var.gcp_processing_clustername_developer_iam_permissions)
  folder   = data.google_active_folder.processing_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_processing_clustername_developer}"
}

// Square Folder
resource "google_folder_iam_member" "gcp_square_clustername_admins_iam_permissions" {
  for_each = toset(var.gcp_square_clustername_admins_iam_permissions)
  folder   = data.google_active_folder.square_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_square_clutername_admins}"
}

resource "google_folder_iam_member" "gcp_square_clustername_developer_iam_permissions" {
  for_each = toset(var.gcp_square_clustername_developer_iam_permissions)
  folder   = data.google_active_folder.square_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.gcp_square_clustername_developer}"
}