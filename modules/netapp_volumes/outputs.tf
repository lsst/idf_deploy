output "pool_name" {
  description = "The name of the volume pool"
  value       = netapp_storage_pool.instance.name
}

output "volume_name" {
  description = "The name of the volume"
  value       = netapp_storage_pool.volume.name
}

output "capacity_gib" {
  description = "The volume/pool capacity"
  value       = netapp_storage_pool.capacity_gib
}

output "id" {
  description = "An identifier for the resource"
  value       = netapp_storage_pool.instance.id
}

output "ip_addresses" {
  description = "A list of IPv4 or IPv6 addresses"
  value       = netapp_storage_pool.instance.networks
}
