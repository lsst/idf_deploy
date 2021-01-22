variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "db_name" {
  description = "The name of the SQL Database instance"
  default     = "example-postgresql-public"
}

variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

variable "disk_size" {
  description = "The disk size for the master instance"
  type        = number
  default     = 10
}

variable "database_version" {
  description = "value"
  type        = string
  default     = "POSTGRES_9_6"
}

variable "zone" {
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
  type        = string
  default     = "us-central1-a"
}

variable "region" {
  description = "The region of the Cloud SQL resources"
  type        = string
  default     = "us-central1"
}

variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-f1-micro"
}

variable "disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD_SSD"
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = bool
    start_time                     = string
    location                       = string
    point_in_time_recovery_enabled = bool
  })
  default = {
    enabled                        = false
    start_time                     = null
    location                       = null
    point_in_time_recovery_enabled = false
  }
}

variable "assign_public_ip" {
  description = "Set to true if the master instance should also have a public IP (less secure)."
  type        = string
  default     = false
}

variable "activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "availability_type" {
  description = "The availability type for the master instance. Can be either `REGIONAL` or `null`."
  type        = string
  default     = "REGIONAL"
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "pricing_plan" {
  description = "The pricing plan for the master instance."
  type        = string
  default     = "PER_USE"
}

variable "user_labels" {
  type        = map(string)
  default     = {}
  description = "The key/value labels for the master instances."
}

variable "user_name" {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "random_instance_name" {
  type        = bool
  description = "Sets random suffix at the end of the Cloud SQL resource name"
  default     = true
}

// Private Service Access

variable "vpc_network" {
  description = "Name of the VPC network to peer."
  type        = string
}

variable "address" {
  description = "First IP address of the IP range to allocate to CLoud SQL instances and other Private Service Access services. If not set, GCP will pick a valid one for you."
  type        = string
  default     = ""
}

variable "prefix_length" {
  description = "Prefix length of the IP range reserved for Cloud SQL instances and other Private Service Access services. Defaults to /16."
  type        = number
  default     = 16
}

variable "ip_version" {
  description = "IP Version for the allocation. Can be IPV4 or IPV6."
  type        = string
  default     = ""
}

variable "labels" {
  description = "The key/value labels for the IP range allocated to the peered network."
  type        = map(string)
  default     = {}
}

// Service Account

variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = ""
}

variable "names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

variable "project_roles" {
  type        = list(string)
  description = "Common roles to apply to all service accounts, project=>role as elements."
  default     = []
}

variable "display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "description" {
  type        = string
  description = "Descriptions of the created service accounts (defaults to no description)"
  default     = "Service Account created by Terraform"
}