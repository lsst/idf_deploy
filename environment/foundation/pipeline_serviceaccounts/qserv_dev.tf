// QServ Dev Project
module "qserv_dev_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_dev_names
  display_name = "Pipelines for Qserv Dev Project"
  description  = "Github action pipellne service account managed by Terraform"

  project_roles = [
    "qserv-dev-3d7e=>roles/editor",
    "qserv-dev-3d7e=>roles/resourcemanager.projectIamAdmin",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "qserv_dev" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.qserv_dev_pipeline_accounts.email}"
}

variable "qserv_dev_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "qserv_dev_email" {
  description = "The service account email."
  value       = module.qserv_dev_pipeline_accounts.email
}

output "qserv_dev_iam_email" {
  description = "The service account IAM-format email."
  value       = module.qserv_dev_pipeline_accounts.iam_email
}