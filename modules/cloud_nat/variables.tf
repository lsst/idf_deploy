// CLOUD ROUTER
variable "project_id" {
  description = "The project id to attach the resource to"
  type        = string
}

variable "router_name" {
  description = "The name to give to the router"
  type        = string
  default     = "default-router"
}

variable "region" {
  description = "The region to place the resource"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "The network name to attach the resource to"
  type        = string
  default     = "default"
}


// EXTERNAL IP
variable "address_count" {
  description = "The number of reserved IP addresses needed"
  type        = number
  default     = 1
}
variable "address_name" {
  description = "The name to give to the reserved IP address."
  type        = string
  default     = "nat-external-address"
}

variable "address_type" {
  description = "The type of address to attach to the NAT. Options are `EXTERNAL` or `INTERNAL`"
  type        = string
  default     = "EXTERNAL"
}

variable "network_tier" {
  description = "The tier of network to use. Options are 'PREMIUM' or 'STANDARD'"
  type        = string
  default     = "PREMIUM"
}

variable "address_labels" {
  description = "Labels to add to the reserved IP address"
  type        = map(string)
  default     = {}
}

// NAT
variable "nat_name" {
  description = "Name of the NAT service. Name must be 1-63 characters."
  type        = string
  default     = "cloud-nat"
}

variable "nat_ip_allocate_option" {
  description = "How external IPs should be allocated for this NAT. Valid values are `AUTO_ONLY` or `MANUAL_ONLY`"
  type        = string
  default     = "MANUAL_ONLY"
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT."
  type        = string
  default     = ""
}

variable "enable_endpoint_independent_mapping" {
  description = "Enables endpoint independent mapping"
  type        = bool
  default     = true
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "How NAT should be configured per subnetwork.Possible values are `ALL_SUBNETWORKS_ALL_IP_RANGES`, `ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGE`S, and `LIST_OF_SUBNETWORKS`"
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "log_config_enable" {
  description = ""
  type        = bool
  default     = false
}

variable "log_config_filter" {
  description = "Specified the desired filtering of logs on this NAT. Possible values are `ERRORS_ONLY`, `TRANSLATIOSN_ONLY`, `ALL`"
  type        = string
  default     = "ERRORS_ONLY"
}
