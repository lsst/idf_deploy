# -----------------------------------------
#   Billing Logs (export configured manually)
# -----------------------------------------

resource "google_bigquery_dataset" "billing_dataset" {
  count         = var.enable_billing_project
  dataset_id    = "billing_data"
  project       = module.org_billing_logs[0].project_id
  friendly_name = "GCP Billing Data"
  location      = "US"
}