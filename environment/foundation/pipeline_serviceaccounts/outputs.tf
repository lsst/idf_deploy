// Science Platform Demo GKE
output "rsp_demo_gke_email" {
  description = "The service account email."
  value       = module.rsp_demo_gke_pipeline_accounts.email
}

output "rsp_demo_gke_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_demo_gke_pipeline_accounts.iam_email
}

// Science Platform Demo Project
output "rsp_demo_email" {
  description = "The service account email."
  value       = module.rsp_demo_pipeline_accounts.email
}

output "rsp_demo_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_demo_pipeline_accounts.iam_email
}

// Science Platform Dev GKE
output "rsp_dev_gke_email" {
  description = "The service account email."
  value       = module.rsp_dev_gke_pipeline_accounts.email
}

output "rsp_dev_gke_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_dev_gke_pipeline_accounts.iam_email
}

// Science Platform Dev Project
output "rsp_dev_email" {
  description = "The service account email."
  value       = module.rsp_dev_pipeline_accounts.email
}

output "rsp_dev_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_dev_pipeline_accounts.iam_email
}

// Science Platform Int GKE
output "rsp_int_gke_email" {
  description = "The service account email."
  value       = module.rsp_int_gke_pipeline_accounts.email
}

output "rsp_int_gke_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_int_gke_pipeline_accounts.iam_email
}

// Science Platform Int
output "rsp_int_email" {
  description = "The service account email."
  value       = module.rsp_int_pipeline_accounts.email
}

output "rsp_int_iam_email" {
  description = "The service account IAM-format email."
  value       = module.rsp_int_pipeline_accounts.iam_email
}

// EPO Int
output "epo_int_email" {
  description = "The service account email."
  value       = module.epo_int_pipeline_accounts.email
}

output "epo_int_iam_email" {
  description = "The service account IAM-format email."
  value       = module.epo_int_pipeline_accounts.iam_email
}

// EPO Prod
output "epo_prod_email" {
  description = "The service account email."
  value       = module.epo_prod_pipeline_accounts.email
}

output "epo_prod_iam_email" {
  description = "The service account IAM-format email."
  value       = module.epo_prod_pipeline_accounts.iam_email
}

// ALERT DEV
output "alert_dev_email" {
  description = "The service account email."
  value       = module.alert_dev_pipeline_accounts.email
}

output "alert_dev_iam_email" {
  description = "The service account IAM-format email."
  value       = module.alert_dev_pipeline_accounts.iam_email
}
