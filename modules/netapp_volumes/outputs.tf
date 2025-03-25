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

output "mount_point" {
  description = "How to mount this volume"
  value       = netapp_volume.instance.mount_options.export_full
}
