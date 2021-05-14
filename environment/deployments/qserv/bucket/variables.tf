variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "suffix_name" {
  description = "The suffix/ending name for the bucket."
  type        = list(string)
  default     = []
}

variable "prefix_name" {
  description = "The prefix/beginning used to generate the bucket."
  type        = string
  default     = "qserv"
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

variable "labels" {
  description = "Labels to be attached to the buckets"
  type        = map
  default     = {}
}
