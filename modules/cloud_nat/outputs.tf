output "reserved_ip_self_link" {
  description = "URI of the created resource"
  value       = google_compute_address.external_addresses.*.self_link
}

output "address" {
  description = "The static external IP address represented by the resource"
  value       = google_compute_address.external_addresses.*.address
}

output "address_name" {
  description = "The name of the static external IP address"
  value       = google_compute_address.external_addresses.*.name
}

output "address_type" {
  description = "The type of address to resolve."
  value       = google_compute_address.external_addresses.*.address_type
}

output "nat_id" {
  description = "Identifier for the resource"
  value       = google_compute_router_nat.default_nat.id
}

output "nat_name" {
  description = "Name for the resource"
  value       = google_compute_router_nat.default_nat.name
}

output "router_name" {
  description = "Name of the router"
  value       = google_compute_router.default_router.name
}