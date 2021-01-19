// QServ Int Project
module "qserv_int_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_int_names
  display_name = "Pipelines for Qserv Int Project"
  description  = "Github action pipellne service account managed by Terraform"

  project_roles = [
    "qserv-int-8069=>roles/editor",
    "qserv-int-8069=>roles/resourcemanager.projectIamAdmin",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "qserv_int" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.qserv_int_pipeline_accounts.email}"
}

variable "qserv_int_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "email" {
  description = "The service account email."
  value       = module.qserv_int_pipeline_accounts.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.qserv_int_pipeline_accounts.iam_email
}