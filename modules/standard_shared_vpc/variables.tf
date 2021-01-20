
variable "project_id" {
  type        = string
  description = "Project ID for Shared VPC."
}

variable "network_name" {
  type        = string
  description = "Name for VPC."
}

variable "default_region" {
  type        = string
  description = "Default subnet region standard_shared_vpc currently only configures one region."
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default     = []
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

# variable "private_service_cidr" {
#   type        = string
#   description = "CIDR range for private service networking. Used for Cloud SQL and other managed services."
# }

variable "bgp_asn" {
  type        = string
  description = "BGP ASN for default cloud router."
  default     = 64513
}

variable "dns_enable_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for VPC DNS."
  default     = true
}

variable "dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = true
}

variable "nat_num_addresses" {
  type        = number
  description = "Number of external IPs to reserve for Cloud NAT."
  default     = 2
}

variable "default_fw_rules_enabled" {
  type        = bool
  description = "Toggle creation of default firewall rules."
  default     = true
}

variable "fwd_name" {
  description = "Zone name, must be unique within the project."
  type        = string
  default     = "corp-example-com"
}

variable "fwd_domain" {
  description = "Zone domain, must end with a period."
  type        = string
  default     = "corp.example."
}

variable "target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  default     = ["8.8.8.8", "8.8.4.4"]
  type        = list(string)
}

variable "authoritative_name" {
  description = "Zone name, must be unique within the project."
  type        = string
  default     = "gcp-example-com"
}

variable "authoritative_domain" {
  description = "Zone domain, must end with a period."
  type        = string
  default     = "gcp.example.com."
}