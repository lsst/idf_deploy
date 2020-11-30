variable "project" {
  description = "The project ID."
  type        = string
}

variable "project_iam_permissions" {
  description = "List of permissions granted to the group"
  type        = list(string)
  default = [
    "roles/monitoring.admin"
  ]
}

variable "member" {
  description = "Identities that will be granted the privilege in 'role'."
  type        = string
}