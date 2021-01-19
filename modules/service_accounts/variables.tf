variable "project_id" {
  type        = string
  description = "Project id where service account will be created."
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = "test-sa"
}

variable "names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

variable "project_roles" {
  type        = list(string)
  description = "Common roles to apply to all service accounts, project=>role as elements."
  default     = []
}

variable "grant_billing_role" {
  type        = bool
  description = "Grant billing user role."
  default     = false
}

variable "billing_account_id" {
  type        = string
  description = "If assigning billing role, specificy a billing account (default is to assign at the organizational level)."
  default     = ""
}

variable "grant_xpn_roles" {
  type        = bool
  description = "Grant roles for shared VPC management."
  default     = false
}

variable "org_id" {
  type        = string
  description = "Id of the organization for org-level roles."
  default     = ""
}

variable "generate_keys" {
  type        = bool
  description = "Generate keys for service accounts."
  default     = false
}

variable "display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "description" {
  type        = string
  description = "Descriptions of the created service accounts (defaults to no description)"
  default     = ""
}