variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
  default     = "288991023210"
}

variable "folder_id" {
  description = "The folder id where project will be created"
  type        = string
  default     = "441200790164"
}

variable "billing_account" {
  description = "The ID of the billing account to associated this project with"
  type        = string
  default     = "0157B0-777456-72D737"
}

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
  default     = "ppdb"
}

variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default = [
    "bigquery.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudfunctions.googleapis.com",
    "dataproc.googleapis.com",
    "eventarc.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com"
  ]
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
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
    "roles/bigquery.admin",
    "roles/dataproc.admin",
    "roles/logging.admin",
    "roles/monitoring.admin",
    "roles/run.admin",
    "roles/storage.admin",
    "roles/compute.securityAdmin"
  ]
}

# VPC

variable "network_name" {
  description = "Name of the VPC"
  type        = string
  default     = "custom-vpc"
}

variable "routing_mode" {
  description = "Type of routing mode. Can be GLOBAL or REGIONAL"
  type        = string
  default     = "GLOBAL"
}

variable "default_region" {
  description = "The default region to place subnetwork"
  type        = string
  default     = "us-central1"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default = [{
    subnet_name   = "subnet-01"
    subnet_ip     = "10.10.10.0/24"
    subnet_region = "us-central1"
  }, ]
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default = {
    subnet-01 = [
      {
        range_name    = "subnet-01-secondary-01"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]
  }
}
