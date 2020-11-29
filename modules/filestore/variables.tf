variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "name" {
  description = "The resource name of the instance."
  type        = string
  default     = "test-instance"
}

variable "description" {
  description = "A description of the instance."
  type        = string
  default     = "A description of the instance."
}

variable "labels" {
  description = "Labels"
  default = {
    name             = "cluster"
    application_name = "app_name"
  }
}

variable "zone" {
  description = "The name of the Filestore zone of the instance"
  type        = string
  default     = "us-central1-b"
}

variable "tier" {
  description = "The service tier of the instance. Possible values are TIER_UNSPECIFIED, STANDARD, PREMIUM, BASIC_HDD, BASIC_SSD, and HIGH_SCALE_SSD."
  type        = string
  default     = "STANDARD"
}

variable "fileshare_name" {
  description = "The name of the fileshare (16 characters or less)"
  type        = string
  default     = "share1"
}

variable "fileshare_capacity" {
  description = "File share capacity in GiB. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier."
  type        = number
  default     = 2660
}

variable "network" {
  description = "The name of the GCE VPC network to which the instance is connected."
  type        = string
  default     = "default"
}

variable "modes" {
  description = "IP versions for which the instance has IP addresses assigned. Each value may be one of ADDRESS_MODE_UNSPECIFIED, MODE_IPV4, and MODE_IPV6."
  type        = list(string)
  default     = ["MODE_IPV4"]

}