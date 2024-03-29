output "project_id" {
  description = "The ID of the created project."
  value       = module.project_factory.project_id
}

output "project_name" {
  description = "The name of the created project"
  value       = module.project_factory.project_name
}

output "project_number" {
  description = "The number of the created project"
  value       = module.project_factory.project_number
}

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.project_factory.enabled_apis
}

output "budget_name" {
  description = "The name of the budget if created"
  value       = module.project_factory.main_budget_name
}
