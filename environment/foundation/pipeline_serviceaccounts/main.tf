// QServ Dev GKE
module "qserv_dev_gke_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_dev_gke_names
  display_name = "Pipelines for Qserv Dev GKE"
  description  = "Github action pipeline service account managed by Terraform"

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

// QServ Dev Project
module "qserv_dev_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_dev_names
  display_name = "Pipelines for Qserv Dev Project"
  description  = "Github action pipeline service account managed by Terraform"

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

// Billing Account to update budgets
resource "google_billing_account_iam_member" "qserv_dev" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.admin"
  member             = "serviceAccount:${module.qserv_dev_pipeline_accounts.email}"
}

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

// QServ Int Project
module "qserv_int_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.qserv_int_names
  display_name = "Pipelines for Qserv Int Project"
  description  = "Github action pipeline service account managed by Terraform"

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

// Science Platform Dev Project
module "rsp_dev_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_dev_names
  display_name = "Pipelines for Science Platform Dev Project"
  description  = "Github action pipeline service account managed by Terraform"

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

// Science Platform Int
module "rsp_int_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_int_names
  display_name = "Pipelines for Science Platform Int Project"
  description  = "Github action pipeline service account managed by Terraform"

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





