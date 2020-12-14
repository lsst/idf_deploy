output "name" {
  description = "The name of the fileshare"
  value       = google_filestore_instance.instance.name
}

output "id" {
  description = "An identifier for the resource"
  value       = google_filestore_instance.instance.id
}

output "file_shares" {
  description = "File share capacity in GiB"
  value       = google_filestore_instance.instance.file_shares
}

output "ip_addresses" {
  description = "A list of IPv4 or IPv6 addresses"
  value       = google_filestore_instance.instance.networks
}