# variable "name" {
#     description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long."
#     default = "test-firewall"
# }

variable "network" {
  description = "Name of the network this set of firewall rules applies to."
  default = "default"
}

variable "project_id" {
  description = "Project id of the project that holds the network."
}

variable "custom_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
  }))
}