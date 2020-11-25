// Qserv Folder
resource "google_folder_iam_member" "gcp_qserv_gke_cluster_admins_iam_permissions" {
  for_each = toset(var.gcp_qserv_gke_cluster_admins_iam_permissions)
  folder   = data.google_active_folder.qserv_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_qserv_gke_cluster_admins}"
}

resource "google_folder_iam_member" "gcp_qserv_gke_cluster_developer_iam_permissions" {
  for_each = toset(var.gcp_qserv_gke_cluster_developer_iam_permissions)
  folder   = data.google_active_folder.qserv_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_qserv_gke_developer}"
}


// Science Platform Folder
resource "google_folder_iam_member" "gcp_science_platform_gke_cluster_admins_iam_permissions" {
  for_each = toset(var.gcp_science_platform_gke_cluster_admins_iam_permissions)
  folder   = data.google_active_folder.splatform_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_science_platform_gke_cluster_admins}"
}

resource "google_folder_iam_member" "gcp_science_platform_gke_cluster_developer_iam_permissions" {
  for_each = toset(var.gcp_science_platform_gke_cluster_developer_iam_permissions)
  folder   = data.google_active_folder.splatform_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_science_platform_gke_developer}"
}

// Processing Folder
resource "google_folder_iam_member" "gcp_processing_gke_cluster_admins_iam_permissions" {
  for_each = toset(var.gcp_processing_gke_cluster_admins_iam_permissions)
  folder   = data.google_active_folder.processing_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_processing_gke_cluster_admins}"
}
resource "google_folder_iam_member" "gcp_processing_gke_cluster_developer_iam_permissions" {
  for_each = toset(var.gcp_processing_gke_cluster_developer_iam_permissions)
  folder   = data.google_active_folder.processing_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_processing_gke_developer}"
}

// Square Folder
resource "google_folder_iam_member" "gcp_square_gke_cluster_admins_iam_permissions" {
  for_each = toset(var.gcp_square_gke_cluster_admins_iam_permissions)
  folder   = data.google_active_folder.square_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_square_gke_cluster_admins}"
}

resource "google_folder_iam_member" "gcp_square_gke_cluster_developer_iam_permissions" {
  for_each = toset(var.gcp_square_gke_cluster_developer_iam_permissions)
  folder   = data.google_active_folder.square_sub_folder.name
  role     = each.value
  member   = "group:${module.constants.values.groups.gcp_square_gke_developer}"
}