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

// Reserved Static IP

output "static_ip" {
  description = "Reserved static IP"
  value       = google_compute_address.static.*.address
}

// GitHub GCP auth federation
output "github_workload_identity_provider" {
  description = "ID of the Workload Identity Provider for GCP auth in GitHub workflows. This can be used as the `workload_identity_provider` value in `google-github-actions/auth` actions"
  value       = google_iam_workload_identity_pool_provider.github.id
}

output "prodromos_github_service_account" {
  description = "ID of the service account with powers to access Prodromos resources from GitHub workflows. This can be used as the `service_account` value in `google-github-actions/auth` actions."
  value       = google_service_account.prodromos_github.email
}
