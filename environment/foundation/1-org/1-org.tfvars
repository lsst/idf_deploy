// Folder Variables

parent_folder                 = ""
folder_names                  = ["QServ", "SQuaRE", "Science Platform", "Processing", "Scratch", "EPO"]
seed_folder_name              = "370233560583"

// Organization Viewer IAM Roles

org_viewer_org_iam_permissions = [
  "roles/orgpolicy.policyViewer",
  "roles/iam.securityReviewer",
  "roles/iam.organizationRoleViewer",
  "roles/logging.privateLogViewer",
  "roles/bigquery.dataViewer",
  "roles/resourcemanager.folderViewer"
]

// Organization Admin IAM Roles

org_admins_org_iam_permissions = [
  "roles/billing.user",
  "roles/resourcemanager.organizationAdmin",
  "roles/resourcemanager.folderAdmin",
  "roles/resourcemanager.projectCreator",
  "roles/iam.organizationRoleAdmin",
  "roles/iam.serviceAccountAdmin",
  "roles/servicemanagement.quotaAdmin"
]

// Organization Billing Admin IAM Roles

org_billing_administrator_iam_permissions = [
  "roles/billing.admin"
]

// Org IAM Roles Monitoring

org_monitoring_viewer_iam_permissions = [
  "roles/monitoring.viewer",
  "roles/viewer",
  "roles/serviceusage.serviceUsageConsumer"
]

org_monitoring_admins_iam_permissions = [
  "roles/monitoring.admin",
  "roles/monitoring.editor",
  "roles/viewer",
  "roles/serviceusage.serviceUsageConsumer"
]

// Org IAM Roles Cloud SQL

org_cloudsql_admins_iam_permissions = [
    "roles/cloudsql.admin",
]

// Org IAM Roles Networking

org_network_admins_org_iam_permissions = [
  "roles/compute.networkAdmin",
  "roles/compute.xpnAdmin",
  "roles/resourcemanager.folderViewer",
  "roles/compute.networkUser"
]

// Org IAM Roles Security

org_security_admins_org_iam_permissions = [
  "roles/compute.securityAdmin",
  "roles/orgpolicy.policyAdmin",
  "roles/orgpolicy.policyViewer",
  "roles/iam.securityReviewer",
  "roles/iam.organizationRoleViewer",
  "roles/resourcemanager.folderIamAdmin",
  "roles/logging.privateLogViewer",
  "roles/logging.configWriter",
  "roles/bigquery.dataViewer"
]


// Log Sink

log_sink_name_pubsub    = "pubsub_org_sink"
log_sink_name_storage   = "storage_org_sink"
include_children        = "true"

// Archive Storage

storage_archive_bucket_name   = "archive_active_logs"
storage_class                 = "STANDARD"
storage_location              = "US"


// Security Command Center Notification Channel

scc_notification_subscription = "sub-scc-notification"
scc_notification_topic        = "top-scc-notification"

# ----------------------------------------
#   ORG POLICY VARIABLES
# ----------------------------------------

resource_region_location_restriction = [
  "in:us-locations"
]

# -----------------------------------------
#   PROJECT VARIABLES
# -----------------------------------------

// Global Shared Services Vars

project_prefix                = "rubin"
random_project_id             = true
auto_create_network           = false
default_service_account       = "depriviledge"
label_environment             = "prod"
skip_gcloud_download          = true

// Billing Project Variables

enable_billing_project         = 1
billing_project_name           = "billing-logs"

activate_apis_billing_project = [
  "logging.googleapis.com",
  "bigquery.googleapis.com",
  "billingbudgets.googleapis.com"
]

org_billing_logs_project_alert_pubsub_topic = ""
org_billing_logs_project_alert_spent_percents = [
  0.5,
  0.75,
  0.9,
  0.95
]
org_billing_logs_project_budget_amount     = 1000

// Data Access Project Variables

data_access_project_name       = "data-access"

activate_apis_data_access_project = [
  "sql-component.googleapis.com",
  "storage.googleapis.com",
  "logging.googleapis.com",
  "bigquery.googleapis.com",
  "stackdriver.googleapis.com",
  "pubsub.googleapis.com",
  "billingbudgets.googleapis.com"
]

org_data_access_project_alert_pubsub_topic = ""
org_data_access_project_alert_spent_percents = [
  0.5,
  0.75,
  0.9,
  0.95
]
org_data_access_project_budget_amount = 1000

// Monitoring Project Variables

enable_monitoring_project      = 1
monitoring_project_name = "monitoring"

activate_apis_monitoring_project = [
  "logging.googleapis.com",
  "monitoring.googleapis.com",
  "stackdriver.googleapis.com",
  "billingbudgets.googleapis.com"
]

org_monitoring_project_alert_pubsub_topic = ""
org_monitoring_project_alert_spent_percents = [
  0.5,
  0.75,
  0.9,
  0.95
]
org_monitoring_project_budget_amount = 1000

// Security Project Variables

audit_log_project_name         = "infosec"
enable_audit_log_project       = 1

activate_apis_audit_log_project = [
  "logging.googleapis.com",
  "bigquery.googleapis.com",
  "stackdriver.googleapis.com",
  "pubsub.googleapis.com",
  "securitycenter.googleapis.com",
  "billingbudgets.googleapis.com"
]

org_audit_log_project_alert_pubsub_topic = ""
org_audit_log_project_alert_spent_percents = [
  0.5,
  0.75,
  0.9,
  0.95
]
org_audit_log_project_budget_amount = 1000

// Shared Service Project Variables

enable_shared_services_project = 1
shared_services_project_name  = "shared-services"

activate_apis_shared_services_project = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "stackdriver.googleapis.com",
  "dns.googleapis.com",
  "servicenetworking.googleapis.com",
  "billingbudgets.googleapis.com"
]

org_shared_services_project_alert_pubsub_topic = ""
org_shared_services_project_alert_spent_percents = [
  0.5,
  0.75,
  0.9,
  0.95
]
org_shared_services_project_budget_amount = 1000

# trigger update