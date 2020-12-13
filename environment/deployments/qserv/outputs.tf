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

output "network" {
  value       = module.project_factory.network
  description = "The name of the VPC being created"
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.project_factory.network_name
}

output "network_self_link" {
  description = "The URI of the VPC being created"
  value       = module.project_factory.network_self_link
}

output "subnets_self_links" {
  description = "The self-links of subnets being created"
  value       = module.project_factory.subnets_self_links
}

// Reserved IP
output "reserved_ip_address" {
  description = "The static external IP address represented by the resource"
  value       = module.nat.address
}

output "address_name" {
  description = "The name of the static ip address"
  value       = module.nat.address_name
}

output "nat_name" {
  description = "The name of the NAT"
  value       = module.nat.nat_name
}

output "nat_id" {
  description = "The self ID of the NAT"
  value       = module.nat.nat_id
}