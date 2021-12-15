variable "project_id" {
  description = "Bucket project id "
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
  default     = "unique-suffix"
}

variable "set_admin_roles" {
  description = "Grant roles/storage.objectAdmin role to admins and bucket_admins."
  type        = bool
  default     = false
}

variable "admins" {
  description = "IAM-style members who will be granted role/storage.objectAdmins for all buckets."
  type        = list(string)
  default     = []
}

variable "bucket_policy_only" {
  description = "Disable ad-hoc ACLs on specified buckets. Defaults to true. Map of lowercase unprefixed name => boolean"
  type        = map
  default     = {}
}

variable "versioning" {
  description = "Optional map of lowercase unprefixed name => boolean, defaults to false."
  type        = map
  default     = {}
}

variable "bucket_admins" {
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style bucket admins."
  type        = map
  default     = {}
}

variable "bucket_creators" {
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style bucket creators."
  type        = map
  default     = {}
}

variable "bucket_viewers" {
  description = "Map of lowercase unprefixed name => comma-delimited IAM-style bucket viewers."
  type        = map
  default     = {}
}

variable "creators" {
  description = "IAM-style members who will be granted roles/storage.objectCreators on all buckets."
  type        = list(string)
  default     = []
}

variable "encryption_key_names" {
  description = "Optional map of lowercase unprefixed name => string, empty strings are ignored."
  type        = map
  default     = {}
}

variable "folders" {
  description = "Map of lowercase unprefixed name => list of top level folder objects."
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

variable "location" {
  description = "Bucket location."
  type        = string
  default     = "US"
}

variable "set_creator_roles" {
  description = "Grant roles/storage.objectCreator role to creators and bucket_creators."
  type        = bool
  default     = false
}

variable "set_viewer_roles" {
  description = "Grant roles/storage.objectViewer role to viewers and bucket_viewers."
  type        = bool
  default     = false
}

variable "storage_class" {
  description = "Bucket storage class. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  type        = string
  default     = "MULTI_REGIONAL"
}

variable "viewers" {
  description = "IAM-style members who will be granted roles/storage.objectViewer on all buckets."
  type        = list(string)
  default     = []
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules to configure. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches_storage_class should be a comma delimited string."
  default = []
  type = set(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values:
    #       Delete and SetStorageClass.
    #
    # - storage_class - (Required if action type is SetStorageClass) The target
    #       Storage Class of objects affected by this Lifecycle Rule.
    action = map(string)

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    #
    # - created_before - (Optional) Creation date of an object in RFC 3339
    #       (e.g. 2017-06-13) to satisfy this condition.
    #
    # - with_state - (Optional) Match to live and/or archived objects.
    #       Supported values include: "LIVE", "ARCHIVED", "ANY".
    #
    # - matches_storage_class - (Optional) Comma delimited string for storage
    #      class of objects to satisfy this condition. Supported values
    #      include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD,
    #      DURABLE_REDUCED_AVAILABILITY.
    #
    # - num_newer_versions - (Optional) Relevant only for versioned objects.
    #       The number of newer versions of an object to satisfy this condition.
    #
    # - custom_time_before - (Optional) A date in the RFC 3339 format
    #       YYYY-MM-DD. This condition is satisfied when the customTime
    #       metadata for the object is set to an earlier date than the date
    #       used in this lifecycle condition.
    #
    # - days_since_custom_time - (Optional) The number of days from the
    #       Custom-Time metadata attribute after which this condition becomes
    #       true.
    #
    # - days_since_noncurrent_time - (Optional) Relevant only for versioned
    #       objects. Number of days elapsed since the noncurrent timestamp of
    #       an object.
    #
    # - noncurrent_time_before - (Optional) Relevant only for versioned
    #       objects. The date in RFC 3339 (e.g. 2017-06-13) when the object
    #       became nonconcurrent.
    condition = map(string)
  }))
}
