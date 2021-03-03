variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "network" {
  description = "Name of the VPC"
  type        = string
  default     = "custom-vpc"
}

variable "db_name" {
  description = "The name of the SQL Database instance"
  default     = "example-postgresql-public"
}

variable "database_version" {
  description = "value"
  type        = string
  default     = "POSTGRES_13"
}

variable "tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-f1-micro"
}

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
