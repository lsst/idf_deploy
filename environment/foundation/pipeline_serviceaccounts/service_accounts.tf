module "qserv_gke_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_int_gke_names
  display_name = "Pipelines for Qserv Int"
  description  = "Github action pipellne service account managed by Terraform"

  project_roles = [
    "qserv-int-8069=>roles/browser",
    "qserv-int-8069=>roles/compute.admin",
    "qserv-int-8069=>roles/container.admin",
    "qserv-int-8069=>roles/container.clusteradmin",
    "qserv-int-8069=>roles/iam.serviceAccountUser",
  ]
}

variable "qserv_int_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "email" {
  description = "The service account email."
  value       = module.qserv_gke_pipeline_accounts.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.qserv_gke_pipeline_accounts.iam_email
}