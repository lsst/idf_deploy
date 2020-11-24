output "cloudbuild_project_id" {
  description = "Project where service accounts and core APIs will be enabled."
  value       = module.cloudbuild_bootstrap.project_id
}

output "gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for foundations pipelines in seed project."
  value       = google_storage_bucket.org_terraform_state.name
}

output "cloudbuild_service_account" {
  description = "The Cloud Build service account"
  value       = "${module.cloudbuild_bootstrap.project_number}@cloudbuild.gserviceaccount.com"
}

output "seed_folder_id" {
  description = "The folder id of the seed folder"
  value       = google_folder.seed.id
}