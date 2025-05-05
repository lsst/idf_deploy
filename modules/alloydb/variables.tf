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