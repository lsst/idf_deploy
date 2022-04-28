variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
  default     = "288991023210"
}

variable "folder_id" {
  description = "The folder id where project will be created"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associated this project with"
  type        = string
  default     = "01122E-72D62B-0B0581"
}

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
  default     = "science_platform"
}

variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "file.googleapis.com",
    "storage.googleapis.com",
    "billingbudgets.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "skip_gcloud_download" {
  description = "Whether to skip downloading gcloud (assumes gcloud is already available outside the module)"
  default     = true
}

variable "default_service_account" {
  description = "Project default service account setting: can be one of delete, deprivilege, disable, or keep."
  default     = "keep"
}

variable "vpc_type" {
  description = "The type of VPC to attach the project to. Possible options are base or null. Default is null."
  type        = string
  default     = ""
}

variable "budget_amount" {
  description = "The amount to use for the budget"
  default     = 1000
  type        = number
}

variable "budget_alert_spent_percents" {
  description = "The list of percentages of the budget to alert on"
  type        = list(number)
  default     = [0.7, 0.8, 0.9, 1.0]
}

# IAM

variable "project_iam_permissions" {
  description = "List of permissions granted to the group"
  type        = list(string)
  default = [
    "roles/monitoring.admin",
    "roles/storage.admin",
    "roles/logging.admin",
    "roles/datastore.owner",
    "roles/appengine.appAdmin"
  ]
}

variable "gafaelfawr_project_id" {
  description = "Project ID for rsp dev project"
  type        = string
}

variable "gafaelfawr_sa" {
  description = "Service Account used for workload identity to access filestore"
  type        = string
}
