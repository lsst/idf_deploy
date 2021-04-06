output "name" {
  description = "Name(s) of the instance"
  value       = google_compute_instance.default.*.name
}

output "instances_self_link" {
  description = "name of the instance"
  value       = google_compute_instance.default.*.self_link
}

output "available_zones" {
  description = "List of available zones in a region"
  value       = data.google_compute_zones.available.names
}

output "instance_zone" {
  description = "The zone the instance deployed into"
  value       = google_compute_instance.default.*.zone
}