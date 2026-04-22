// Folder Variables

parent_folder                 = ""
folder_names                  = ["SQuaRE", "Science Platform", "Processing", "Scratch", "EPO", "Alert Production", "PPDB"]
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
default_service_account       = "DEPRIVILEGE"
label_environment             = "prod"

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

# Increase this number to force Terraform to update
# Serial: 1