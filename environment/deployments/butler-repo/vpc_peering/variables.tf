variable "remote_application_name" {
  description = "The remote 'application_name' label value."
  type        = string
  default     = "science-platform"
}

variable "remote_environment" {
  description = "The remote `environment` label value."
  type        = string
  default     = "dev"
}

variable "remote_network_name" {
  description = "The VPC name in the remote project to peer to"
  type        = string
  default     = "custom-vpc"
}

variable "remote_application_name2" {
  description = "The second remote 'application_name' label value."
  type        = string
  default     = "science-platform"
}

variable "remote_environment2" {
  description = "The second remote `environment` label value."
  type        = string
  default     = "dev"
}

variable "remote_network_name2" {
  description = "The VPC name in the second remote project to peer to"
  type        = string
  default     = "custom-vpc"
}

variable "application_name" {
  description = "The local 'application_name' label value."
  type        = string
}

variable "environment" {
  description = "The local 'environment' label value"
  type        = string
}

variable "network_name" {
  description = "The VPC name in the local project."
  type        = string
}
