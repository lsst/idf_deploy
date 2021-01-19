// QServ Int GKE
module "qserv_int_gke_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_int_gke_names
  display_name = "Pipelines for Qserv Int GKE"
  description  = "Github action pipeline service account managed by Terraform"

  project_roles = [
    "qserv-int-8069=>roles/browser",
    "qserv-int-8069=>roles/compute.admin",
    "qserv-int-8069=>roles/container.admin",
    "qserv-int-8069=>roles/container.clusterAdmin",
    "qserv-int-8069=>roles/iam.serviceAccountUser",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "qserv_int_gke" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.qserv_int_gke_pipeline_accounts.email}"
}

variable "qserv_int_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

output "qserv_int_email" {
  description = "The service account email."
  value       = module.qserv_int_gke_pipeline_accounts.email
}

output "qserv_int_iam_email" {
  description = "The service account IAM-format email."
  value       = module.qserv_int_gke_pipeline_accounts.iam_email
}