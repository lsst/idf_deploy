output "local_network_peering" {
  description = "Network peering resource."
  value       = google_compute_network_peering.local_network_peering
}

output "peer_network_peering" {
  description = "Peer network peering resource."
  value       = google_compute_network_peering.peer_network_peering
}

output "complete" {
  description = "Output to be used as a module dependency."
  value       = null_resource.complete.id
}