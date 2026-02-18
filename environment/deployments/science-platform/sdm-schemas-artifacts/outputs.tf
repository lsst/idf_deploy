output "bucket_name" {
  description = "Name of the GCS bucket holding sdm_schemas CI artifacts."
  value       = module.sdm_schemas_artifacts_bucket.name
}

output "uploader_service_account_email" {
  description = "Email of the uploader service account to be used in the lsst/sdm_schemas GitHub repository."
  value       = module.sdm_schemas_uploader.email
}
