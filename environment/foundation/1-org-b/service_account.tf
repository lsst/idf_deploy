locals {
  project_id = data.google_projects.prod_host_project.projects[0].project_id
}

# -------------------------------------------------
#   Service Account Creation
#   Project must exist before SA can be created
#   There's a soft dependency that the module doesn't know about.
# -------------------------------------------------

module "service_account_info_sec" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "~> 3.0"
  project_id   = local.project_id
  prefix       = "infosec-sa"
  display_name = "Service Account for SIEM"
  description  = "A service account used for SIEM to get logs"
  names        = ["siem"]
  project_roles = [
    "${local.project_id}=>roles/pubsub.subscriber",
    "${local.project_id}=>roles/pubsub.viewer",
  ]
}