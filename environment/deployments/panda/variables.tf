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
    "roles/container.clusterAdmin",
    "roles/container.admin",
    "roles/compute.instanceAdmin.v1",
    "roles/logging.admin",
    "roles/file.editor",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountCreator",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/iap.tunnelResourceAccessor",
    "roles/artifactregistry.admin"
  ]
}

# Service Account GCS IAM

variable "project_iam_sa_gcs_access" {
  description = "List of permissions granted to the group"
  type        = list(string)
  default     = []
}

variable "cross_project_service_accounts" {
  description = "Service account granted database access"
  type        = list(string)
  default     = [
    "serviceAccount:sqlproxy-butler-int@science-platform-dev-7696.iam.gserviceaccount.com",
    "serviceAccount:sqlproxy-butler-int@science-platform-demo-9e05.iam.gserviceaccount.com"
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

variable "custom_rules2" {
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

# 2-1-2022 by Aaron Strong
# The module nat block has been commented out because we're using new tech preview features
# that are not available to the API. This block is failing our build pipeline.

# NAT

# 2-1-2022 by Aaron Strong
# The module nat block has been commented out because we're using new tech preview features

# variable "router_name" {
#   description = "The name to give to the router"
#   type        = string
#   default     = "nat-router"
# }

# variable "address_count" {
#   description = "The number of reserved IP addresses needed"
#   type        = number
#   default     = 1
# }

# variable "address_name" {
#   description = "The name to give to the reserved IP address."
#   type        = string
#   default     = "nat-external-address"
# }

# variable "address_type" {
#   description = "The type of address to attach to the NAT. Options are `EXTERNAL` or `INTERNAL`"
#   type        = string
#   default     = "EXTERNAL"
# }

# variable "address_labels" {
#   description = "Labels to add to the reserved IP address"
#   type        = map(string)
#   default     = {}
# }

# variable "nat_name" {
#   description = "Name of the NAT service. Name must be 1-63 characters."
#   type        = string
#   default     = "cloud-nat"
# }

# variable "nat_ip_allocate_option" {
#   description = "How external IPs should be allocated for this NAT. Valid values are `AUTO_ONLY` or `MANUAL_ONLY`"
#   type        = string
#   default     = "AUTO_ONLY"
# }

# variable "min_ports_per_vm" {
#   description = "Minimum number of ports allocated to a VM from this NAT."
#   type        = string
#   default     = ""
# }

# variable "log_config_enable" {
#   description = ""
#   type        = bool
#   default     = false
# }

# variable "log_config_filter" {
#   description = "Specified the desired filtering of logs on this NAT. Possible values are `ERRORS_ONLY`, `TRANSLATIOSN_ONLY`, `ALL`"
#   type        = string
#   default     = "ERRORS_ONLY"
# }

# IAP
variable "members" {
  description = "List of IAM resources to allow using the IAP tunnel."
  type        = list(string)
}

# INSTANCE
variable "machine_type" {
  description = "The machine type to create"
  type        = string
  default     = "e2-medium"
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  default     = "1"
}

variable "size" {
  description = "The size of the image in gigabytes."
  type        = number
  default     = 50
}

variable "image" {
  description = "The image from which to initialize this disk."
  type        = string
}

variable "tags" {
  description = "A list of network tags to attach to the instance"
  type        = list(string)
  default     = []
}

variable "type" {
  description = "The GCE disk type. Maybe `pd-standard`,`pd-balanced`, `pd-ssd`"
  type        = string
  default     = "pd-standard"
}

# BUCKET

variable "bucket_policy_only" {
  description = "Disable ad-hoc ACLs on specified buckets. Defaults to true. Map of lowercase unprefixed name => boolean"
  type        = map
  default     = {}
}
