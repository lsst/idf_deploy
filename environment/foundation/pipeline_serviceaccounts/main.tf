#---------------------------------------------------------------
// Science Platform Demo GKE
#---------------------------------------------------------------
module "rsp_demo_gke_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_demo_gke_names
  display_name = "Pipelines for Science Platform Demo GKE"
  description  = "Github action pipeline service account managed by Terraform"

  project_roles = [
    "science-platform-demo-9e05=>roles/browser",
    "science-platform-demo-9e05=>roles/compute.admin",
    "science-platform-demo-9e05=>roles/container.admin",
    "science-platform-demo-9e05=>roles/container.clusterAdmin",
    "science-platform-demo-9e05=>roles/iam.serviceAccountUser",
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_demo_gke" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_demo_gke_pipeline_accounts.email}"
}

#---------------------------------------------------------------
// Science Platform Demo Project
#---------------------------------------------------------------
module "rsp_demo_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.rsp_demo_names
  display_name = "Pipelines for Science Platform Demo Project"
  description  = "Github action pipeline service account managed by Terraform"

  project_roles = [
    "science-platform-demo-9e05=>roles/editor",
    "science-platform-demo-9e05=>roles/resourcemanager.projectIamAdmin",
    "science-platform-demo-9e05=>roles/iam.serviceAccountAdmin"
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_demo" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_demo_pipeline_accounts.email}"
}

// Billing Account to update budgets
# I (Dan) don't think we need these GitHub actions workflow accounts to have billing.admin
# resource "google_billing_account_iam_member" "rsp_demo" {
#   billing_account_id = var.billing_account_id
#   role               = "roles/billing.admin"
#   member             = "serviceAccount:${module.rsp_demo_pipeline_accounts.email}"
# }

#---------------------------------------------------------------
// Science Platform Dev GKE
#---------------------------------------------------------------
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

#---------------------------------------------------------------
// Science Platform Dev Project
#---------------------------------------------------------------
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
    "science-platform-dev-7696=>roles/iam.serviceAccountAdmin"
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_dev" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_dev_pipeline_accounts.email}"
}

// Billing Account to update budgets
# resource "google_billing_account_iam_member" "rsp_dev" {
#   billing_account_id = var.billing_account_id
#   role               = "roles/billing.admin"
#   member             = "serviceAccount:${module.rsp_dev_pipeline_accounts.email}"
# }

#---------------------------------------------------------------
// Science Platform Int GKE
#---------------------------------------------------------------
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

#---------------------------------------------------------------
// Science Platform Int
#---------------------------------------------------------------
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
    "science-platform-int-dc5d=>roles/iam.serviceAccountAdmin"
  ]
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "rsp_int" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.rsp_int_pipeline_accounts.email}"
}

// Billing Account to update budgets
# resource "google_billing_account_iam_member" "rsp_int" {
#   billing_account_id = var.billing_account_id
#   role               = "roles/billing.admin"
#   member             = "serviceAccount:${module.rsp_int_pipeline_accounts.email}"
# }

#---------------------------------------------------------------
# EPO INT Project
#---------------------------------------------------------------
module "epo_int_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.epo_int_names
  display_name = "Pipelines for EPO INT Project"
  description  = "Github action pipeline service account managed by Terraform"
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "epo_int" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.epo_int_pipeline_accounts.email}"
}

// Billing Account to update budgets
# resource "google_billing_account_iam_member" "epo_int" {
#   billing_account_id = var.billing_account_id
#   role               = "roles/billing.admin"
#   member             = "serviceAccount:${module.epo_int_pipeline_accounts.email}"
# }

#---------------------------------------------------------------
# EPO PROD Project
#---------------------------------------------------------------
module "epo_prod_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.epo_prod_names
  display_name = "Pipelines for EPO PROD Project"
  description  = "Github action pipeline service account managed by Terraform"
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "epo_prod" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.epo_prod_pipeline_accounts.email}"
}

// Billing Account to update budgets
# resource "google_billing_account_iam_member" "epo_prod" {
#   billing_account_id = var.billing_account_id
#   role               = "roles/billing.admin"
#   member             = "serviceAccount:${module.epo_prod_pipeline_accounts.email}"
# }

#---------------------------------------------------------------
# Alert Dev Project
#---------------------------------------------------------------
module "alert_dev_pipeline_accounts" {
  source = "../../../modules/service_accounts/"

  project_id   = "rubin-automation-prod"
  prefix       = "pipeline"
  names        = var.alert_dev_names
  display_name = "Pipelines for Alert DEV Project"
  description  = "Github action pipeline service account managed by Terraform"
}
// Storage access to read tfstate
resource "google_storage_bucket_iam_member" "alert_dev" {
  bucket = "lsst-terraform-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.alert_dev_pipeline_accounts.email}"
}

// Billing Account to update budgets
# resource "google_billing_account_iam_member" "alert_dev" {
#   billing_account_id = var.billing_account_id
#   role               = "roles/billing.admin"
#   member             = "serviceAccount:${module.alert_dev_pipeline_accounts.email}"
# }
