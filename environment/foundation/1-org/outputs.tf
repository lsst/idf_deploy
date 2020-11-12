# -------------------------------------------------
#   FOLDERS OUTPUTS
# -------------------------------------------------

output "ids" {
  description = "Folder ids."
  value       = module.top_folders.ids
}

output "names" {
  description = "Folder names."
  value       = module.top_folders.names
}

output "ids_list" {
  description = "List of folder ids."
  value       = module.top_folders.ids_list
}