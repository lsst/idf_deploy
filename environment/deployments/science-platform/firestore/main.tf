module "project_factory" {
  source                      = "../../../../modules/project_vpc"
  org_id                      = var.org_id
  folder_id                   = var.folder_id
  billing_account             = var.billing_account
  project_prefix              = "rsp-firestore-${var.environment}"
  application_name            = var.application_name
  environment                 = var.environment
  activate_apis               = var.activate_apis
  budget_amount               = var.budget_amount
  budget_alert_spent_percents = var.budget_alert_spent_percents
}

module "iam_admin" {
  source                  = "../../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-science-platform-administrators@lsst.cloud"
}

resource "google_project_iam_member" "gafaelfawr-iam-binding" {
  project = module.project_factory.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${var.gafaelfawr_sa}"
}

resource "google_app_engine_application" "app" {
  project       = module.project_factory.project_id
  location_id   = "us-central"
  database_type = "CLOUD_FIRESTORE"
}
