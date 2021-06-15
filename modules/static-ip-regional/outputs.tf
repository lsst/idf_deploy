output "static_address" {
  description = "The static external IP address of the resource"
  value       = google_compute_address.static.address
}

output "static_self_link" {
  description = "The URI of the created resource."
  value       = google_compute_address.static.self_link
}