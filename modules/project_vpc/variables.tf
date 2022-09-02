variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "folder_id" {
  description = "The folder id where project will be created"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associated this project with"
  type        = string
}

variable "project_prefix" {
  description = "The name of the GCP project"
  type        = string
}

variable "random_project_id" {
  description = "Append a random 4 digit number to the end of the project"
  default     = "true"
}

# variable "cost_centre" {
#   description = "The cost centre that links to the application"
#   type        = string
# }

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
}

variable "activate_apis" {
  description = "The api to activate for the GCP project"
  type        = list(string)
  default     = ["compute.googleapis.com"]
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

# VPC

variable "network_name" {
  description = "Name of the VPC"
  type        = string
  default     = "custom-vpc"
}

variable "routing_mode" {
  description = "Type of routing mode. Can be GLOBAL or REGIONAL"
  type        = string
  default     = "REGIONAL"
}

variable "default_region" {
  description = "The default region to place subnetwork"
  type        = string
  default     = "us-west1"
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
  description = "Secondary ranges that will be used in some of the subnets"
  default = {
    subnet-01 = [
      {
        range_name    = "kubernetes-pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "kubernetes-services"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}


# variable "subnet_name" {
#   description = "Name of the subnet"
#   type        = string
#   default     = "subnet-01"
# }

# variable "subnet_ip" {
#   description = "The default subnetwork"
#   type        = string
#   default     = "10.128.0.0/16"
# }

# variable "subnet_flow_logs" {
#   description = "To enable flow logs for the subnet."
#   type        = string
#   default     = "true"
# }

# variable "subnet_flow_logs_interval" {
#   description = "Time range to capture flow logs"
#   type        = string
#   default     = "INTERVAL_15_MIN"
# }

# variable "flow_logs_sampling" {
#   description = "Sampling rate"
#   type        = string
#   default     = 0.2
# }

# variable "flow_logs_metadata" {
#   description = "Include metadata with flow logs"
#   type        = string
#   default     = "INCLUDE_ALL_METADATA"
# }
