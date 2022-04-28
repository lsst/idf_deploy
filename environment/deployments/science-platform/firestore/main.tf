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
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

resource "google_service_account_iam_member" "gafaelfawr-iam-binding" {
  service_account_id = "projects/${var.gafaelfawr_project_id}/serviceAccounts/${var.gafaelfawr_sa}"
  role               = "roles/iam.datastore.user"
  member             = "serviceAccount:${var.gafaelfawr_sa}"
}
