# -------------------------------
#   PROJECT for Monitoring
# -------------------------------

module "org_monitoring" {
  count                   = var.enable_monitoring_project
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-${var.monitoring_project_name}"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = var.activate_apis_monitoring_project
  auto_create_network     = var.auto_create_network
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain
  labels = {
    owner       = module.constants.values.core_projects_owner
    environment = var.label_environment
    service     = "org-monitoring"
    application = "org-monitoring"
  }
  budget_alert_pubsub_topic   = var.org_monitoring_project_alert_pubsub_topic
  budget_alert_spent_percents = var.org_monitoring_project_alert_spent_percents
  budget_amount               = var.org_monitoring_project_budget_amount
}

# -------------------------------
#   PROJECT for Monitoring
# -------------------------------

module "org_data_access" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-${var.data_access_project_name}"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = var.activate_apis_data_access_project
  auto_create_network     = var.auto_create_network
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain
  labels = {
    owner       = module.constants.values.core_projects_owner
    environment = var.label_environment
    service     = "org-data-access"
    application = "org-data-access"
  }
  budget_alert_pubsub_topic   = var.org_data_access_project_alert_pubsub_topic
  budget_alert_spent_percents = var.org_data_access_project_alert_spent_percents
  budget_amount               = var.org_data_access_project_budget_amount
}

# -------------------------------
#   PROJECT for InfoSec/logging
# -------------------------------

module "org_audit_logs" {
  count                   = var.enable_audit_log_project
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-${var.audit_log_project_name}"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = var.activate_apis_audit_log_project
  auto_create_network     = var.auto_create_network
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain
  labels = {
    owner       = module.constants.values.core_projects_owner
    environment = var.label_environment
    service     = "org-audit-logs"
    application = "org-audit-logs"
  }
  budget_alert_pubsub_topic   = var.org_audit_log_project_alert_pubsub_topic
  budget_alert_spent_percents = var.org_audit_log_project_alert_spent_percents
  budget_amount               = var.org_audit_log_project_budget_amount
}

# -------------------------------
#   PROJECT for Billing Logs
# -------------------------------

module "org_billing_logs" {
  count                   = var.enable_billing_project
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-${var.billing_project_name}"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = var.activate_apis_billing_project
  auto_create_network     = var.auto_create_network
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain
  labels = {
    owner       = module.constants.values.core_projects_owner
    environment = var.label_environment
    service     = "org-billing-logs"
    application = "org-billing-logs"
  }
  budget_alert_pubsub_topic   = var.org_billing_logs_project_alert_pubsub_topic
  budget_alert_spent_percents = var.org_billing_logs_project_alert_spent_percents
  budget_amount               = var.org_billing_logs_project_budget_amount
}

# -------------------------------
#   PROJECT for Shared VPC
# -------------------------------

module "org_shared_services" {
  count                   = var.enable_shared_services_project
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 9.0"
  random_project_id       = var.random_project_id
  name                    = "${var.project_prefix}-${var.shared_services_project_name}"
  org_id                  = module.constants.values.org_id
  billing_account         = module.constants.values.billing_account
  folder_id               = var.seed_folder_name
  activate_apis           = var.activate_apis_shared_services_project
  auto_create_network     = var.auto_create_network
  default_service_account = var.default_service_account
  domain                  = module.constants.values.domain

  labels = {
    owner            = module.constants.values.core_projects_owner
    environment      = var.label_environment
    application      = "org-${var.shared_services_project_name}-${var.label_environment}"
    service          = "org-${var.shared_services_project_name}-${var.label_environment}"
    application_name = "org-${var.shared_services_project_name}-${var.label_environment}" # Do not change. Used in 2-network as a lookup variable
  }
  budget_alert_pubsub_topic   = var.org_shared_services_project_alert_pubsub_topic
  budget_alert_spent_percents = var.org_shared_services_project_alert_spent_percents
  budget_amount               = var.org_shared_services_project_budget_amount
}
