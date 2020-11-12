# ----------------------------------------
#   Network Variables
# ----------------------------------------

variable "label_application_name" {
  description = "Project label for the `application_name`. Used by the search filter"
  type        = string
  default     = "org-shared-vpc-prod"
}

variable "network_name" {
  description = "Name of the VPC"
  type        = string
  default     = "shared-vpc-prod"
}

variable "subnets" {
  description = "Subnetwork information"
  default = [
    {
      subnet_name               = "us-central1-prod-1"
      subnet_ip                 = "10.230.0.0/15"
      subnet_region             = "us-central1"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      description               = "Prod subnet."
      subnet_flow_logs_interval = "INTERVAL_15_MIN"
      subnet_flow_logs_sampling = 0.3
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
  ]
}