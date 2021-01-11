output "bucket" {
  description = "Bucket resource (for single use)."
  value       = module.gcs_bucket.bucket
}

output "name" {
  description = "Bucket name (for single use)."
  value       = module.gcs_bucket.name
}

output "url" {
  description = "Bucket URL (for single use)."
  value       = module.gcs_bucket.url
}

output "buckets" {
  description = "Bucket resources as list."
  value       = module.gcs_bucket.buckets
}

# output "buckets_map" {
#   description = "Bucket resources by name."
#   value       = module.gcs_bucket.buckets_map
# }

# output "names" {
#   description = "Bucket names."
#   value = { for name, bucket in module.gcs_bucket.buckets_map :
#     name => bucket.name
#   }
# }

# output "urls" {
#   description = "Bucket URLs."
#   value = { for name, bucket in module.gcs_bucket.buckets_map :
#     name => bucket.url
#   }
# }

output "names_list" {
  description = "List of bucket names."
  value       = module.gcs_bucket.names_list
}

output "urls_list" {
  description = "List of bucket URLs."
  value       = module.gcs_bucket.urls_list
}