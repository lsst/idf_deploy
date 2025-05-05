output "read_pool_private_ip" {
  description = "IPv4 address of the read pool's private IP address (internal to the VPC)"
  value       = google_alloydb_instance.data_preview_readpool.ip_address
}