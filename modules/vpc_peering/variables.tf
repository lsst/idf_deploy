variable "prefix" {
  description = "Name prefix for the network peerings"
  type        = string
  default     = "network-peering"
}

variable "peer_name" {
  description = "(Optional) Give vpc peer a custom name."
  type        = string
  default     = ""
}

variable "local_network" {
  description = "Resource link of the network to add a peering to."
  type        = string
}

variable "peer_network" {
  description = "Resource link of the peer network."
  type        = string
}

variable "export_peer_custom_routes" {
  description = "Export custom routes to local network from peer network."
  type        = bool
  default     = false
}

variable "export_local_custom_routes" {
  description = "Export custom routes to peer network from local network."
  type        = bool
  default     = false
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}
