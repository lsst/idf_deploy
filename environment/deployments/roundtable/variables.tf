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
  default     = "017AD6-5564CB-B8A78F"
}

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
  default     = "roundtable"
}

variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default = [
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "storage.googleapis.com",
    "billingbudgets.googleapis.com",
    "servicenetworking.googleapis.com"
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
    "roles/monitoring.admin",
    "roles/storage.admin",
    "roles/container.clusterAdmin",
    "roles/container.admin",
    "roles/compute.instanceAdmin",
    "roles/logging.admin",
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

variable "num_static_ips" {
  description = "The total number of static IPs to reserve."
  type        = number
  default     = 1
}

variable "nats" {
  description = "NATs to deploy on this router."
  type        = any
  default     = []
  /*
  default = [{
      name = "example-nat"
  }]
  */
}

variable "router_name" {
  type        = string
  description = "Name of the router"
  default     = "cloud-router"
}

# Buckets

variable "vault_server_bucket_suffix" {
  type        = string
  description = "Suffix for bucket used for Vault server storage"
}

variable "turborepo_cache_bucket_suffix" {
  type        = string
  description = "Suffix for bucket used for Turborepo remote cache"
}

variable "prodromos_terraform_state_bucket_suffix" {
  type        = string
  description = "Suffix for bucket used for Prodromos Terraform state"
}

variable "atlantis_monitoring_admin_service_account_member" {
  type        = string
  description = "The service account that should have Google Cloud monitoring admin permissions in THIS project. This service account is probably provisioned in a different project."
}

# STATIC IP RESERVATION
variable "ingress_ip_address" {
  description = "The name and description for the static IP address attached to the cluster ingress load balancer."
  type = object({
    name = string
    description = string
  })
}

variable "kafka_bootstrap_ip_address" {
  description = "The name and description for the static IP address attached to the cluster ingress load balancer."
  type = object({
    enabled = bool
    name = string
    description = string
  })
}

variable "kafka_broker1_ip_address" {
  description = "The name and description for the static IP address attached to the cluster ingress load balancer."
  type = object({
    enabled = bool
    name = string
    description = string
  })
}

variable "kafka_broker2_ip_address" {
  description = "The name and description for the static IP address attached to the cluster ingress load balancer."
  type = object({
    enabled = bool
    name = string
    description = string
  })
}

variable "kafka_broker3_ip_address" {
  description = "The name and description for the static IP address attached to the cluster ingress load balancer."
  type = object({
    enabled = bool
    name = string
    description = string
  })
}
