# ----------------------------------------
#   IAM FOLDER VARIABLES
# ----------------------------------------

// CLUSTER ADMINS
variable "gcp_qserv_clustername_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin"
  ]
}

variable "gcp_science_platform_clustername_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin"
  ]
}

variable "gcp_processing_clustername_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin"
  ]
}

variable "gcp_square_clustername_admins_iam_permissions" {
  description = "List of permissions granted to the group."
  type        = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/logging.admin",
    "roles/resourcemanager.projectCreator",
    "roles/monitoring.admin"
  ]
}

// CLUSTER DEVELOPERS
variable "gcp_qserv_clustername_developer_iam_permissions" {
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

variable "gcp_science_platform_clustername_developer_iam_permissions" {
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

variable "gcp_processing_clustername_developer_iam_permissions" {
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

variable "gcp_square_clustername_developer_iam_permissions" {
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

variable "sub_folder_names" {
  description = "List out the sub folders to be created."
  type        = list(string)
  default = [
    "QA",
    "Test",
    "Prod"
  ]
}