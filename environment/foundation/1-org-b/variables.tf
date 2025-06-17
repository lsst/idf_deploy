# ----------------------------------------
#   IAM FOLDER VARIABLES
# ----------------------------------------

// CLUSTER ADMINS
variable "gcp_qserv_gke_cluster_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin",
    "roles/storage.admin",
    "roles/compute.instanceAdmin",
    "roles/logging.admin",
    "roles/file.editor",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin"
  ]
}

variable "gcp_science_platform_gke_cluster_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin",
    "roles/storage.admin",
    "roles/compute.instanceAdmin",
    "roles/logging.admin",
    "roles/file.editor",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin"
  ]
}

variable "gcp_processing_gke_cluster_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin",
    "roles/storage.admin",
    "roles/compute.instanceAdmin",
    "roles/logging.admin",
    "roles/file.editor",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin"
  ]
}

variable "gcp_square_gke_cluster_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin",
    "roles/storage.admin",
    "roles/compute.instanceAdmin",
    "roles/logging.admin",
    "roles/file.editor",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin"
  ]
}

// CLUSTER DEVELOPERS
variable "gcp_qserv_gke_developer_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.clusterViewer",
    "roles/container.viewer",
    "roles/container.developer",
    "roles/logging.viewer",
    "roles/monitoring.editor",
    "roles/storage.objectViewer",
  ]
}

variable "gcp_science_platform_gke_developer_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.clusterViewer",
    "roles/container.viewer",
    "roles/container.developer",
    "roles/logging.viewer",
    "roles/monitoring.editor",
    "roles/storage.objectViewer",
  ]
}

variable "gcp_processing_gke_developer_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.clusterViewer",
    "roles/container.viewer",
    "roles/container.developer",
    "roles/logging.viewer",
    "roles/monitoring.editor",
    "roles/storage.objectViewer",
  ]
}

variable "gcp_square_gke_developer_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.clusterViewer",
    "roles/container.viewer",
    "roles/container.developer",
    "roles/logging.viewer",
    "roles/monitoring.editor",
    "roles/storage.objectViewer",
  ]
}

// GCP PROJECT ADMINISTRATORS

variable "gcp_qserv_administrators_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/resourcemanager.projectCreator",
    "roles/container.admin",
    "roles/editor"
  ]
}

variable "gcp_science_platform_administrators_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/resourcemanager.projectCreator",
    "roles/container.admin",
    "roles/editor"
  ]
}

variable "gcp_processing_administrators_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/resourcemanager.projectCreator",
    "roles/container.admin",
    "roles/editor"
  ]
}

variable "gcp_square_administrators_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/resourcemanager.projectCreator",
    "roles/container.admin",
    "roles/editor"
  ]
}

variable "gcp_org_administrators_shared_service_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/storage.admin",
    "roles/domains.admin"
  ]
}

variable "gcp_epo_administrators_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/resourcemanager.projectCreator",
    "roles/container.admin",
    "roles/editor"
  ]
}


# ----------------------------------------
#   SUB FOLDER VARIABLES
# ----------------------------------------

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

variable "qserv_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "QServ"
}

variable "splatform_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "Science Platform"
}

variable "processing_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "Processing"
}

variable "square_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "SQuaRE"
}

variable "shared_services_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "Shared Services"
}

variable "epo_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "EPO"
}

variable "alert_production_display_name" {
  description = "The display name of the parent folder."
  type        = string
  default     = "Alert Production"
}

variable "sub_folder_names" {
  description = "List out the sub folders to be created."
  type        = list(string)
  default = [
    "Dev",
    "Integration",
    "Production"
  ]
}
