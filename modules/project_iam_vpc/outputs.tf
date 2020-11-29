output "project_name" {
  value = module.project.project_name
}

output "project_id" {
  value = module.project.project_id
}

output "project_number" {
  value = module.project.project_number
}

output "service_account_id" {
  value       = module.project.service_account_id
  description = "The id of the default service account"
}

output "service_account_display_name" {
  value       = module.project.service_account_display_name
  description = "The display name of the default service account"
}

output "service_account_email" {
  value       = module.project.service_account_email
  description = "The email of the default service account"
}

output "service_account_name" {
  value       = module.project.service_account_name
  description = "The fully-qualified name of the default service account"
}

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.project.enabled_apis
}

output "main_budget_name" {
  description = "The name of the budget created by the core project factory module"
  value       = module.project.budget_name
}

output "budget_amount" {
  description = "The amount to use for the budget"
  value       = var.budget_amount
}

output "budget_alert_spent_percents" {
  description = "The list of percentages of the budget to alert on"
  value       = var.budget_alert_spent_percents
}

# VPC

output "network" {
  value       = module.vpc
  description = "The created network"
}

output "subnets" {
  value       = module.vpc.subnets
  description = "A map with keys of form subnet_region/subnet_name and values being the outputs of the google_compute_subnetwork resources used to create corresponding subnets."
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "subnets_names" {
  value       = [for network in module.vpc.subnets : network.name]
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = [for network in module.vpc.subnets : network.ip_cidr_range]
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = [for network in module.vpc.subnets : network.self_link]
  description = "The self-links of subnets being created"
}

output "subnets_regions" {
  value       = [for network in module.vpc.subnets : network.region]
  description = "The region where the subnets will be created"
}

output "subnets_flow_logs" {
  value       = [for network in module.vpc.subnets : length(network.log_config) != 0 ? true : false]
  description = "Whether the subnets will have VPC flow logs enabled"
}