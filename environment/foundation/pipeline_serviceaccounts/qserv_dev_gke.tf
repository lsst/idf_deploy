// QServ Dev GKE
module "qserv_dev_gke_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_dev_names
  display_name = "Pipelines for Qserv Dev GKE"
  description  = "Github action pipellne service account managed by Terraform"

  project_roles = [
    "qserv-dev-3d7e=>roles/browser",
    "qserv-dev-3d7e=>roles/compute.admin",
    "qserv-dev-3d7e=>roles/container.admin",
    "qserv-dev-3d7e=>roles/container.clusterAdmin",
    "qserv-dev-3d7e=>roles/iam.serviceAccountUser",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "qserv_dev_gke" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.qserv_dev_gke_pipeline_accounts.email}"
}

variable "qserv_dev_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "email" {
  description = "The service account email."
  value       = module.qserv_dev_gke_pipeline_accounts.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.qserv_dev_gke_pipeline_accounts.iam_email
}