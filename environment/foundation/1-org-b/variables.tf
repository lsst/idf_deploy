# ----------------------------------------
#   ORG POLICY VARIABLES
# ----------------------------------------

# SKIP DEFAULT NETWORK

# variable "skip_default_network_exclude_folders" {
#   description = "A folder to exclude from the skip default network policy"
#   type        = string
#   default     = "Learn"
# }

# variable "org_id" {
#   description = "The organization id for putting the policy"
# }

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

variable "label_application" {
  description = "The application label value on the infosec project."
  type = string
  default = "org-audit-logs"
}

variable "sub_folder_names" {
  description = "List out the sub folders to be created."
  type = list(string)
  default = [
    "Students",
    "Faculty"
  ]
}

variable "parent_display_name" {
  description = "The display name of the parent folder."
  type = string
  default = "Learn"
}

// Custom Role
variable "custom_role_name" {
  description = "The name of the custom role. This role is only used for Folder List."
  type        = string
  default     = "[Custom] Folder Role"
}

variable "custom_role_id" {
  description = "The role id of the custom role."
  type        = string
  default     = "CustomRoleTreeFolderViewer"
}

variable "folder_to_bind_custome_role" {
  description = "The folder to bind the custom role"
  type = string
  default = "Learn"
}

# variable "billing_account" {
#   description = "The ID of the billing account to associate this project with"
#   type        = string
# }

# variable "domain" {
#   description = "The domain name (optional)."
#   type        = string
#   default     = ""
# }

variable "skip_default_network_exclude_folders" {
  description = "Folder ID"
  type = string
}

variable "domain_restrict_sharing_exclude_folders" {
  description = "Folder ID"
  type = string
}