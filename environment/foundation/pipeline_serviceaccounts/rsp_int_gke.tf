// Science Platform Int GKE
module "rsp_int_gke_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_int_gke_names
  display_name = "Pipelines for Science Platform Int GKE"
  description  = "Github action pipeline service account managed by Terraform"

  project_roles = [
    "science-platform-int-dc5d=>roles/browser",
    "science-platform-int-dc5d=>roles/compute.admin",
    "science-platform-int-dc5d=>roles/container.admin",
    "science-platform-int-dc5d=>roles/container.clusterAdmin",
    "science-platform-int-dc5d=>roles/iam.serviceAccountUser",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_int_gke" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_int_gke_pipeline_accounts.email}"
}

variable "rsp_int_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "rsp_int_gke_email" {
  description = "The service account email."
  value       = module.rsp_int_gke_pipeline_accounts.email
}

output "rsp_int_gke_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_int_gke_pipeline_accounts.iam_email
}