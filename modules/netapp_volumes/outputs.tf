# locals {
#   vol_names = flatten([
#     for vdef in var.definitions : [
#       vdef.name
#     ]
#   ])
# }
    
# output "mount_points" {
#   description = "How to mount this volume"
#   for_each    = local.vol_names
#   value       = netapp_volume.mount_options.export_full
# }
