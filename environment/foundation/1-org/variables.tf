# ----------------------------------------
#   FOLDER Variables
# ----------------------------------------

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

variable "folder_names" {
  type        = list(string)
  description = "Folder names."
  default = [
    "Sensitive",
    "Learn",
    "Researchers"
  ]
}

variable "seed_folder_name" {
  description = "Folder ID that contains the `Cloud Control Plane` projects."
  default     = "" # Change during deployment to match Core/Administration folder ID
}

# ----------------------------------------
#   IAM Variables
# ----------------------------------------

variable "org_admins_org_iam_permissions" {
  description = "List of permissions granted to the group supplied in group_org_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/billing.user",
    "roles/resourcemanager.organizationAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/iam.organizationRoleAdmin",
    "roles/iam.serviceAccountAdmin"
  ]
}

variable "org_network_admins_org_iam_permissions" {
  description = "List of permissions granted to the group supplied in group_org_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/resourcemanager.folderViewer",
    "roles/compute.networkUser"
  ]
}

variable "org_security_admins_org_iam_permissions" {
  description = "List of permissions granted to the group supplied in group_org_admins variable across the GCP organization."
  type        = list(string)
  default = [
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
}

variable "org_viewer_org_iam_permissions" {
  description = "List of permissions granted to the group supplied in group_org_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/orgpolicy.policyViewer",
    "roles/iam.securityReviewer",
    "roles/iam.organizationRoleViewer",
    "roles/logging.privateLogViewer",
    "roles/bigquery.dataViewer",
    "roles/resourcemanager.folderViewer"
  ]
}

variable "org_billing_administrator_iam_permissions" {
  description = "List of permissions granted to the group supplied in billing_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/billing.admin",
  ]
}

variable "org_monitoring_admins_iam_permissions" {
  description = "List of permissions granted to the group supplied in monitoring_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/monitoring.admin",
    "roles/monitoring.editor",
    "roles/viewer",
    "roles/serviceusage.serviceUsageConsumer"
  ]
}

variable "org_monitoring_viewer_iam_permissions" {
  description = "List of permissions granted to the group supplied in monitoring_viewer variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/monitoring.viewer",
    "roles/viewer",
    "roles/serviceusage.serviceUsageConsumer"
  ]
}

variable "org_cloudsql_admins_iam_permissions" {
  description = "List of permissions granted to the group supplied in cloudsql_admins variable across the GCP organization."
  type        = list(string)
  default = [
    "roles/cloudsql.admin"
  ]
}

# ----------------------------------------
#   ORG POLICY VARIABLES
# ----------------------------------------

variable "resource_region_location_restriction" {
  description = "The location to restrict where resources can be created from."
  type        = list(string)
  default     = ["in:us-locations"]
}

# -----------------------------------------
#   PROJECT VARIABLES
# -----------------------------------------
// GLOBAL SHARED SERVICES VARS
variable "project_prefix" {
  description = "Adds a prefix to the core projects."
  default     = "core"
}

variable "random_project_id" {
  description = "Adds a suffix of 4 random characters to the `project_id`"
  type        = bool
  default     = true
}

variable "auto_create_network" {
  description = "Create the default network"
  type        = bool
  default     = false
}

variable "default_service_account" {
  description = "Project default service account setting: can be one of delete, depriviledge, or keep."
  default     = "depriviledge"
}

variable "label_environment" {
  description = "Project label for the environment"
  type        = string
  default     = "prod"
}

// SHARED SERVICE PROJECT VARS
variable "enable_shared_services_project" {
  description = "Option to enable or disable the creation of the project for: Shared Host Project"
  type        = number
  default     = 1
}

variable "shared_services_project_name" {
  description = "The name to append to the var.project_prefix value."
  type        = string
  default     = "shared-services"
}

variable "activate_apis_shared_services_project" {
  description = "What APIs to activate for this project."
  type        = list(string)
  default     = ["compute.googleapis.com", "container.googleapis.com", "stackdriver.googleapis.com", "dns.googleapis.com", "servicenetworking.googleapis.com", "billingbudgets.googleapis.com"]
}

variable "org_shared_services_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "org_shared_services_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project."
  type        = string
  default     = null
}

variable "org_shared_services_project_budget_amount" {
  description = "The amount to use as the budget for the org billing logs project."
  type        = number
  default     = 1000
}

// BILLING PROJECT VARS
variable "enable_billing_project" {
  description = "Option to enable or disable the creation of the project for: Billing Project."
  type        = number
  default     = 1
}

variable "billing_project_name" {
  description = "The name to append to the var.project_prefix value."
  type        = string
  default     = "billing-logs"
}

variable "activate_apis_billing_project" {
  description = "What APIs to activate for this project."
  type        = list(string)
  default     = ["logging.googleapis.com", "bigquery.googleapis.com", "billingbudgets.googleapis.com"]
}

variable "org_billing_logs_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "org_billing_logs_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project."
  type        = string
  default     = null
}

variable "org_billing_logs_project_budget_amount" {
  description = "The amount to use as the budget for the org billing logs project."
  type        = number
  default     = 1000
}