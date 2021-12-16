output "reader_service_account_email" {
  description = "Email of a service account that can read bucket data"
  value = module.bucket_reader_account.email
}

output "writer_service_account_email" {
  description = "Email of a service account that can write bucket data"
  value = module.bucket_writer_account.email
}

output "packet_bucket_name" {
  description = "Name of a bucket that stores alert packet data"
  value = module.alert_packet_bucket.name
}

output "schema_bucket_name" {
  description = "Name of a bucket that stores alert schema data"
  value = module.alert_schema_bucket.name
}
