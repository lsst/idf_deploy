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
    "roles/iam.organizationRoleAdmin"
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

# ----------------------------------------
#   LOG SINK
# ----------------------------------------

// Pub/Sub Topics and Subscriptions
variable "log_sink_name_pubsub" {
  description = "Name of the pub/sub log sink"
  default     = "pubsub_org_sink"
}

variable "log_sink_name_storage" {
  description = "Name of the storage log sink"
  default     = "storage_org_sink"
}

variable "include_children" {
  description = "To include all child objects in sink."
  type        = string
  default     = "true"
}

// Archive Storage
variable "storage_archive_bucket_name" {
  description = "The name for the bucket that will store archive of admin activity logs"
  default     = "archive_active_logs"
}

variable "storage_class" {
  description = "Storage class"
  type        = string
  default     = "STANDARD"
}

variable "storage_location" {
  description = "Region to put archive"
  type        = string
  default     = "US"
}

// SCC NotificationChannel
variable "scc_notification_topic" {
  description = "Name of the pub/sub SCC notification topic"
  type        = string
  default     = "top-scc-notification"
}

variable "scc_notification_subscription" {
  description = "Name of the pub/sub SCC notification subscription"
  type        = string
  default     = "sub-scc-notification"
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

variable "skip_gcloud_download" {
  description = "Whether to skip downloading gcloud (assumes gcloud is already available outside the module)"
  type        = bool
  default     = true
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

/***************************
  Project specific vars
***************************/
// DATA ACCESS PROJECT VARS
variable "data_access_project_name" {
  description = "The name to append to the var.project_prefix value."
  type        = string
  default     = "data-access"
}

variable "activate_apis_data_access_project" {
  description = "What APIs to activate for this project."
  type        = list(string)
  default     = ["sql-component.googleapis.com","storage.googleapis.com","logging.googleapis.com", "bigquery.googleapis.com", "stackdriver.googleapis.com", "pubsub.googleapis.com", "billingbudgets.googleapis.com"]
}

variable "org_data_access_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "org_data_access_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project."
  type        = string
  default     = null
}

variable "org_data_access_project_budget_amount" {
  description = "The amount to use as the budget for the org billing logs project."
  type        = number
  default     = 1000
}

// AUDIT LOG PROJECT VARS
variable "enable_audit_log_project" {
  description = "Option to enable or disable the creation of the project for: Shared Host Project"
  type        = number
  default     = 1
}

variable "audit_log_project_name" {
  description = "The name to append to the var.project_prefix value."
  type        = string
  default     = "infosec"
}

variable "activate_apis_audit_log_project" {
  description = "What APIs to activate for this project."
  type        = list(string)
  default     = ["logging.googleapis.com", "bigquery.googleapis.com", "stackdriver.googleapis.com", "pubsub.googleapis.com", "securitycenter.googleapis.com", "billingbudgets.googleapis.com"]
}

variable "org_audit_log_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "org_audit_log_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project."
  type        = string
  default     = null
}

variable "org_audit_log_project_budget_amount" {
  description = "The amount to use as the budget for the org billing logs project."
  type        = number
  default     = 1000
}


// SHARED VPC HOST PROJECT VARS
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





// MONITORING PROJECT VARS
variable "enable_monitoring_project" {
  description = "Option to enable or disable the creation of the project for: Monitoring Project."
  type        = number
  default     = 1
}

variable "monitoring_project_name" {
  description = "The name to append to the var.project_prefix value."
  type        = string
  default     = "monitoring"
}

variable "activate_apis_monitoring_project" {
  description = "What APIs to activate for this project."
  type        = list(string)
  default     = ["logging.googleapis.com", "monitoring.googleapis.com", "stackdriver.googleapis.com", "billingbudgets.googleapis.com"]
}

variable "org_monitoring_project_alert_spent_percents" {
  description = "A list of percentages of the budget to alert on when threshold is exceeded for the org billing logs project."
  type        = list(number)
  default     = [0.5, 0.75, 0.9, 0.95]
}

variable "org_monitoring_project_alert_pubsub_topic" {
  description = "The name of the Cloud Pub/Sub topic where budget related messages will be published, in the form of `projects/{project_id}/topics/{topic_id}` for the org billing logs project."
  type        = string
  default     = null
}

variable "org_monitoring_project_budget_amount" {
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