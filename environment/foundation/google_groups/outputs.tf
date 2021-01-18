output "id" {
  value       = module.group.id
  description = "ID of the group. For Google-managed entities, the ID is the email address the group"
}

output "resource_name" {
  value       = module.group.resource_name
  description = "Resource name of the group in the format: groups/{group_id}, where group_id is the unique ID assigned to the group."
}