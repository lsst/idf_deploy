module "qserv_projects_sa" {
  source  = "../../../modules/service_accounts/"

  project_id         = var.project_id
  prefix             = var.prefix
  names              = var.names
  project_roles      = var.project_roles
  grant_billing_role = var.grant_billing_role
  billing_account_id = var.billing_account_id
  grant_xpn_roles    = var.grant_xpn_roles
  org_id             = var.org_id
  generate_keys      = var.generate_keys
  display_name       = var.display_name
  description        = var.description
}

# variable "project_id" {
#   type        = string
#   description = "Project id where service account will be created."
# }

# variable "prefix" {
#   type        = string
#   description = "Prefix applied to service account names."
#   default     = "test-sa"
# }

# variable "names" {
#   type        = list(string)
#   description = "Names of the service accounts to create."
#   default     = []
# }

# variable "project_roles" {
#   type        = list(string)
#   description = "Common roles to apply to all service accounts, project=>role as elements."
#   default     = []
# }

# variable "grant_billing_role" {
#   type        = bool
#   description = "Grant billing user role."
#   default     = false
# }

# variable "billing_account_id" {
#   type        = string
#   description = "If assigning billing role, specificy a billing account (default is to assign at the organizational level)."
#   default     = ""
# }

# variable "grant_xpn_roles" {
#   type        = bool
#   description = "Grant roles for shared VPC management."
#   default     = false
# }

# variable "org_id" {
#   type        = string
#   description = "Id of the organization for org-level roles."
#   default     = ""
# }

# variable "generate_keys" {
#   type        = bool
#   description = "Generate keys for service accounts."
#   default     = false
# }

# variable "display_name" {
#   type        = string
#   description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
#   default     = "Terraform-managed service account"
# }

# variable "description" {
#   type        = string
#   description = "Descriptions of the created service accounts (defaults to no description)"
#   default     = ""
# }

output "email" {
  description = "The service account email."
  value       = module.service_accounts.service_account.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.service_accounts.iam_email
}