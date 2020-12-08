variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}


variable "region" {
  description = " The Region in which the created address should reside."
  type        = string
  default     = "us-central1"
}


variable "network_tier" {
  description = "The networking tier used for configuring this address. If this field is not specified, it is assumed to be PREMIUM. Possible values are PREMIUM and STANDARD"
  type        = string
  default     = "PREMIUM"
}


# variable "project" {
#   description = ""
#   type = string
#   default = 
# }


variable "name" {
  description = " Name of the resource."
  type        = string
  default     = "ip_reservation"
}


variable "address_type" {
  description = "The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL"
  type        = string
  default     = "EXTERNAL"
}


variable "purpose" {
  description = "The purpose of this resource, which can be one of the following values:GCE_ENDPOINT or SHARED_LOADBALANCER_VIP "
  type        = string
  default     = "GCE_ENDPOINT"
}

variable "description" {
  description = "An optional description of this resource"
  type        = string
  default     = "Reserved static ip address."
}