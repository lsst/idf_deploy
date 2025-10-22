output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke.endpoint
}

# output "client_token" {
#   sensitive = true
#   value     = base64encode(data.google_client_config.default.access_token)
# }

output "ca_certificate" {
  value = module.gke.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "id" {
  description = "Cluster ID"
  value       = module.gke.cluster_id
}

output "location" {
  description = "Cluster location (region if regional cluster zone if zonal cluster)"
  value       = module.gke.location
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.gke.master_version
}

output "region" {
  description = "Cluster region"
  value       = module.gke.region
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke.zones
}
