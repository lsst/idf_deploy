module "project_factory" {
  source                      = "../../../modules/project_vpc"
  org_id                      = var.org_id
  folder_id                   = var.folder_id
  billing_account             = var.billing_account
  project_prefix              = "${var.application_name}-${var.environment}"
  application_name            = var.application_name
  environment                 = var.environment
  activate_apis               = var.activate_apis
  budget_amount               = var.budget_amount
  budget_alert_spent_percents = var.budget_alert_spent_percents
  subnets                     = var.subnets
  secondary_ranges            = var.secondary_ranges
  routing_mode                = var.routing_mode
}

module "iam_admin" {
  source                  = "../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

// Role with read/write permissions to log-based alerts and metrics
resource "google_project_iam_custom_role" "logging_monitoring_admin" {
  project     = module.project_factory.project_id
  role_id     = "loggingMonitoringAdmin"
  title       = "Logging Monitoring Admin"
  description = "Read write permissions on Logging notifications and metrics"
  permissions = [
    "logging.notificationRules.create",
    "logging.notificationRules.delete",
    "logging.notificationRules.get",
    "logging.notificationRules.list",
    "logging.notificationRules.update",
    "logging.logMetrics.list",
    "logging.logMetrics.create",
    "logging.logMetrics.get",
    "logging.logMetrics.update",
    "logging.logMetrics.delete",
  ]
}

// Allow the active Atlantis instance service account to have read/write powers
// on Google Cloud monitoring in this project
resource "google_project_iam_member" "atlantis_monitoring_admin" {
  project = module.project_factory.project_id
  role    = "roles/monitoring.admin"
  member  = var.atlantis_monitoring_admin_service_account_member
}

// Allow the active Atlantis instance service account to have read/write powers
// on Google Cloud Logging notifications in this project
resource "google_project_iam_member" "atlantis_logging_notifcation_admin" {
  project = module.project_factory.project_id
  role    = google_project_iam_custom_role.logging_monitoring_admin.id
  member  = var.atlantis_monitoring_admin_service_account_member
}
