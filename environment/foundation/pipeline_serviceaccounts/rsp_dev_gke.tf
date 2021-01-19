// Science Platform Dev GKE
module "rsp_dev_gke_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_dev_gke_names
  display_name = "Pipelines for Science Platform Dev GKE"
  description  = "Github action pipeline service account managed by Terraform"

  project_roles = [
    "science-platform-dev-7696=>roles/browser",
    "science-platform-dev-7696=>roles/compute.admin",
    "science-platform-dev-7696=>roles/container.admin",
    "science-platform-dev-7696=>roles/container.clusterAdmin",
    "science-platform-dev-7696=>roles/iam.serviceAccountUser",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_dev_gke" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_dev_gke_pipeline_accounts.email}"
}

variable "rsp_dev_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "rsp_dev_gke_email" {
  description = "The service account email."
  value       = module.rsp_dev_gke_pipeline_accounts.email
}

output "rsp_dev_gke_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_dev_gke_pipeline_accounts.iam_email
}