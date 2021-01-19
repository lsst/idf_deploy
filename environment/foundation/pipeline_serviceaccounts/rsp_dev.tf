// Science Platform Dev Project
module "rsp_dev_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_dev_names
  display_name = "Pipelines for Science Platform Dev GKE"
  description  = "Github action pipellne service account managed by Terraform"

  project_roles = [
    "science-platform-dev-7696=>roles/editor",
    "science-platform-dev-7696=>roles/resourcemanager.projectIamAdmin",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_dev" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_dev_pipeline_accounts.email}"
}

variable "rsp_dev_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "email" {
  description = "The service account email."
  value       = module.rsp_dev_pipeline_accounts.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_dev_pipeline_accounts.iam_email
}