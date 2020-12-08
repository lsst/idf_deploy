output "id" {
  value       = google_compute_address.static_ip.id
  description = "The id of the resource"
}

output "self_link" {
  value       = google_compute_address.static_ip.self_link
  description = "The URI of the created resource"
}