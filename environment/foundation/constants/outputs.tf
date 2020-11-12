locals {
  deploy_at_root       = lookup(local.constants, "parent_folder", "") != "" ? false : true
  parent = local.deploy_at_root ? "organizations/${local.constants.org_id}" : "folders/${local.constants.parent_folder}"

}

output "values" {
  description = "Constant configuration values which apply across layers and environments."
  value       = local.constants
}

output "deploy_at_root" {
  description = "Whether to deploy at the root of the organization or in a folder."
  value       = local.deploy_at_root
}

output "parent" {
  description = "The parent being deployed into, either the org or a folder."
  value = local.parent
}