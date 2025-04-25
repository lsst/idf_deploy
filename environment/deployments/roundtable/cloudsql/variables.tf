variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "network" {
  description = "Name of the VPC"
  type        = string
  default     = "custom-vpc"
}

variable "database_tier" {
  description = "The tier for general database"
  type        = string
  default     = "db-g1-small"
}

variable "database_version" {
  description = "The database version to use for the general database"
  type        = string
  default     = "POSTGRES_16"
}

variable "db_maintenance_window_day" {
  type        = number
  description = "The day of week (1-7) for the master instance maintenance."
  default     = 1
}

variable "db_maintenance_window_hour" {
  type        = number
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  default     = 23
}

variable "db_maintenance_window_update_track" {
  type        = string
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}

variable "backups_enabled" {
  type        = bool
  description = "True if backup configuration is enabled"
  default     = false
}

variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_string_length     = number
    record_application_tags = bool
    record_client_address   = bool
  })
  default = null
}
