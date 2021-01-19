// Science Platform Int
module "rsp_int_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_int_names
  display_name = "Pipelines for Science Platform int GKE"
  description  = "Github action pipellne service account managed by Terraform"

  project_roles = [
    "science-platform-int-dc5d=>roles/editor",
    "science-platform-int-dc5d=>roles/resourcemanager.projectIamAdmin",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_int" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_int_pipeline_accounts.email}"
}

variable "rsp_int_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "email" {
  description = "The service account email."
  value       = module.rsp_int_pipeline_accounts.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_int_pipeline_accounts.iam_email
}