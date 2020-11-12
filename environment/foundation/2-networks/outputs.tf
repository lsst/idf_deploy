output "prod_host_project_id" {
  value       = local.prod_host_project_id
  description = "The host project ID for prod"
}

output "prod_network_name" {
  value       = module.shared_vpc_prod.network_name
  description = "The name of the VPC being created"
}

output "prod_network_self_link" {
  value       = module.shared_vpc_prod.network_self_link
  description = "The URI of the VPC being created"
}

output "prod_subnets_names" {
  value       = module.shared_vpc_prod.subnets_names
  description = "The names of the subnets being created"
}

output "prod_subnets_ips" {
  value       = module.shared_vpc_prod.subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "prod_subnets_self_links" {
  value       = module.shared_vpc_prod.subnets_self_links
  description = "The self-links of subnets being created"
}

output "prod_subnets_secondary_ranges" {
  value       = module.shared_vpc_prod.subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}