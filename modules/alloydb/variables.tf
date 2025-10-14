variable "cluster_id" {
  description = "Name of the AlloyDB cluster"
  type        = string
}

variable "network_id" {
  description = "ID of the VPC that the database will exist in"
  type        = string
}

variable "location" {
  description = "Google data center location where the database will be created"
  type        = string
}

variable "project_id" {
  description = "ID of the Google Cloud Platform project that will contain these resources"
  type        = string
}

variable "database_version" {
  description = "AlloyDB version identifier for this database (e.g. 'POSTGRES_16')"
  type = string
}

variable "enable_public_ip_for_primary" {
  description = "Enable a public IP address for the primary database instance, to allow external connections using the AlloyDB Auth Proxy."
  type = bool
  default = false
}