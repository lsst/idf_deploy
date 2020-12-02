variable "name" {
  type        = string
  description = "Name of the router"
  default     = "example-router"
}

variable "network" {
  type        = string
  description = "A reference to the network to which this router belongs"
  default     = "default"
}

variable "project" {
  type        = string
  description = "The project ID to deploy to"
}

variable "region" {
  type        = string
  description = "Region where the router resides"
  default     = "us-central1"
}

variable "nats" {
  description = "NATs to deploy on this router."
  type        = any
  default     = []
  /*
  default = [{
      name = "example-nat"
  }]
  */
}