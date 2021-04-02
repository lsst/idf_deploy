variable "project_id" {
  description = "Bucket project id "
  type        = string
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
  default     = "panda"
}

variable "storage_class" {
  description = "Bucket storage class. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  type        = string
  default     = "REGIONAL"
}

variable "location" {
  description = "Bucket location."
  type        = string
  default     = "us-central1"
}

variable "prefix_name" {
  description = "The prefix/beginning used to generate the bucket."
  type        = string
  default     = "unique-suffix"
}

variable "suffix_name" {
  description = "The suffix/ending name for the bucket."
  type        = list(string)
  default     = []
}

variable "versioning" {
  description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
  type        = map
  default     = {}
}

variable "force_destroy" {
  description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
  type        = map
  default     = {}
}
