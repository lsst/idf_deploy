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

variable "cost_centre" {
  description = "The cost centre that links to the application"
  type        = string
}

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

# IAM

variable "mode" {
  description = "Mode for adding the IAM policies/bindings, additive and authoritative"
  type        = string
  default     = "additive"
}

variable "group_name" {
  description = "Name of the Google Group to assign to the project."
  type        = string
}

variable "group_name_binding" {
  description = "The role to bind the Google group to. Default is Editor"
  type        = string
  default     = "roles/editor"
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