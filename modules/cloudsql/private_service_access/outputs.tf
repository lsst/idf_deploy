output "address" {
  value       = module.private-service-access.address
  description = "First IP of the reserved range."
}

output "google_compute_global_address_name" {
  value       = module.private-service-access.google_compute_global_address_name
  description = "URL of the reserved range."
}

output "peering_completed" {
  value       = module.private-service-access.peering_completed
  description = "Use for enforce ordering between resource creation"
}