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
    "servicenetworking.googleapis.com",
    "netapp.googleapis.com"
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
    "roles/file.editor",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/netapp.admin"
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



# FileStore

variable "filestore_definitions" {
  description = "A list of Filestore definitions"
  type = list(object({
    name        = string                     # Filestore instance name
    share_name  = optional(string, "share1") # 16 chars max
    location    = optional(string, "us-central1-b")
    capacity    = optional(number, 2660)
    tier        = optional(string, "BASIC_SSD")
    description = optional(string, "Instance description")
    modes       = optional(list(string), ["MODE_IPV4"])
  }))
}

# LEGACY Filestore, to be removed once new volumes are created and contents
# have been copied.

variable "name" {
  description = "The resource name of the instance."
  type        = string
  default     = "fshare-instance"
}

variable "zone" {
  description = "The name of the Filestore zone of the instance"
  type        = string
  default     = "us-central1-b"
}

variable "fileshare_name" {
  description = "The name of the fileshare (16 characters or less)"
  type        = string
  default     = "share1"
}

variable "fileshare_capacity" {
  description = "File share capacity in GiB. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier."
  type        = number
  default     = 2600
}

variable "tier" {
  description = "The service tier of the instance. Possible values are TIER_UNSPECIFIED, STANDARD, PREMIUM, BASIC_HDD, BASIC_SSD, and HIGH_SCALE_SSD."
  type        = string
  default     = "BASIC_SSD"
}

variable "modes" {
  description = "IP versions for which the instance has IP addresses assigned. Each value may be one of ADDRESS_MODE_UNSPECIFIED, MODE_IPV4, and MODE_IPV6."
  type        = list(string)
  default     = ["MODE_IPV4"]
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

# NETAPP CLOUD VOLUMES

variable "location" {
  description = "The name of the location of the Netapp instance (synonym for region)"
  type        = string
  default     = "us-central1"
}

variable "netapp_definitions" {
  description = "A list of NetApp Cloud Volume definitions"
  type = list(object({
    name                   = string                   # Volume name
    service_level          = string                   # PREMIUM, EXTREME, STANDARD, FLEX
    capacity_gib           = number                   # At least 2048
    unix_permissions       = optional(string, "0770") # Unix permission for mount point
    snapshot_directory     = optional(bool, false)
    backups_enabled        = optional(bool, false)
    has_root_access        = optional(bool, false)
    allow_auto_tiering     = optional(bool, false)
    cooling_threshold_days = optional(number, 31)
    access_type            = optional(string, "READ_ONLY") # READ_ONLY, READ_WRITE, READ_NONE
    default_user_quota_mib = optional(number)
    override_user_quotas = optional(list(object({
      username       = string
      uid            = number
      disk_limit_mib = number
    })), [])
  }))
}

# STATIC IP RESERVATION

variable "static_ip_name" {
  description = "Name to give to the static ip"
  type        = string
  default     = "load-balancer"
}
