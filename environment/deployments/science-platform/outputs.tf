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

output "router" {
  value       = module.nat.router
  description = "The created router"
}

output "router_region" {
  value       = module.nat.router_region
  description = "The region of the created router"
}

// Filestore

output "filestore_name" {
  description = "The name of the fileshare"
  value       = module.filestore.name
}

output "filestore_id" {
  description = "An identifier for the resource"
  value       = module.filestore.id
}

output "filestore_ip_address" {
  description = "A list of IPv4 or IPv6 addresses"
  value       = module.filestore.ip_addresses
}

output "filestore_fileshares" {
  description = "File share capacity in GiB"
  value       = module.filestore.file_shares
}

// Reserved Static IP

output "static_ip" {
  description = "Reserved static IP"
  value       = google_compute_address.static.*.address
}

// Service Accounts
output "email" {
  description = "The service account email."
  value       = module.gar_sa.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.gar_sa.iam_email
}
