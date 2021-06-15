variable "static_name" {
  description = "The name of the resource"
  type        = string
  default     = "ipv4-external-address"
}

variable "address" {
  description = "The static external IP address represented by this resource. Only IPv4 is supported."
  type        = string
  default     = ""
}

variable "address_type" {
  description = "The type of address to reserve. Default value is `EXTERNAL`. Possible values are `INTERNAL` and `EXTERNAL`."
  type        = string
  default     = "EXTERNAL"
}

variable "description" {
  description = "An optional description of this resource."
  type        = string
  default     = "Created by Terraform."
}

variable "network_tier" {
  description = "The networking tier used for configuring this address.Possible values are `PREMIUM` and `STANDARD`."
  type        = string
  default     = "PREMIUM"
}

variable "labels" {
  description = "Labels to apply to this address."
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "The Region in which the created address should reside."
  type        = string
  default     = "us-central1"
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}