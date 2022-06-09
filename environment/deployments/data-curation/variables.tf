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
    "billingbudgets.googleapis.com"
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
    "roles/container.clusterAdmin",
    "roles/container.admin",
    "roles/compute.instanceAdmin.v1",
    "roles/logging.admin",
    "roles/file.editor",
    "roles/compute.networkAdmin",
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

# FIREWALL

variable "custom_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
  }))
}

# NAT

variable "router_name" {
  description = "The name to give to the router"
  type        = string
  default     = "nat-router"
}

variable "address_count" {
  description = "The number of reserved IP addresses needed"
  type        = number
  default     = 1
}

variable "address_name" {
  description = "The name to give to the reserved IP address."
  type        = string
  default     = "nat-external-address"
}

variable "address_type" {
  description = "The type of address to attach to the NAT. Options are `EXTERNAL` or `INTERNAL`"
  type        = string
  default     = "EXTERNAL"
}

variable "address_labels" {
  description = "Labels to add to the reserved IP address"
  type        = map(string)
  default     = {}
}

variable "nat_name" {
  description = "Name of the NAT service. Name must be 1-63 characters."
  type        = string
  default     = "cloud-nat"
}

variable "log_config_enable" {
  description = ""
  type        = bool
  default     = false
}

variable "log_config_filter" {
  description = "Specified the desired filtering of logs on this NAT. Possible values are `ERRORS_ONLY`, `TRANSLATIOSN_ONLY`, `ALL`"
  type        = string
  default     = "ERRORS_ONLY"
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT."
  type        = string
  default     = ""
}

// Data Curation Prod
variable "data_curation_prod_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// HiPS
variable "hips_service_account" {
  type        = string
  description = "Service account used for HiPS Butler access"
  default     = "crawlspace-hips@science-platform-dev-7696.iam.gserviceaccount.com"
}
