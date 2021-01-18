module "gke_pipeline_accounts" {
  source  = "../../../modules/service_accounts/"

  project_id         = "rubin-automation-prod"
  prefix             = "pipeline"
  #names              = ["qserv-int-gka-sa","qserv-dev-gka-sa"]
  names = var.gke_names
  display_name       = "Pipelines for Qserv Int"
  description        = "Github action pipellne service account managed by Terraform"

  project_roles = [
    "qserv-int-8069=>roles/browser",
    "qserv-int-8069=>roles/compute.admin",
    "qserv-int-8069=>roles/container.admin",
    "qserv-int-8069=>roles/container.clusteradmin",
    "qserv-int-8069=>roles/iam.serviceAccountUser",
  ]
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

variable "gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

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
  value       = module.qserv_gke_pipeline_accounts.service_account.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.qserv_gke_pipeline_accounts.iam_email
}