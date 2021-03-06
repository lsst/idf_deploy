locals {
  parent_resource_id   = var.parent_folder != "" ? var.parent_folder : module.constants.values.org_id
  parent_resource_type = var.parent_folder != "" ? "folder" : "organization"
  all_logs_filter      = <<EOF
    logName: /logs/cloudaudit.googleapis.com%2Factivity OR
    logName: /logs/cloudaudit.googleapis.com%2Fsystem_event OR
    logName: /logs/cloudaudit.googleapis.com%2Fdata_access OR
    logName: /logs/compute.googleapis.com%2Fvpc_flows OR
    logName: /logs/compute.googleapis.com%2Ffirewall OR
    logName: /logs/cloudaudit.googleapis.com%2Faccess_transparency
EOF
}

# -------------------------------------------------
#   PUBSUB ORG LEVEL Aggregated Sink
# -------------------------------------------------

// No need for SIEM integration. Removing these steps

# resource "random_string" "suffix" {
#   length  = 4
#   upper   = false
#   special = false
# }

# module "log_export" {
#   source                 = "terraform-google-modules/log-export/google"
#   version                = "~> 5.0"
#   destination_uri        = module.destination.destination_uri
#   filter                 = local.all_logs_filter
#   log_sink_name          = "${var.log_sink_name_pubsub}_${random_string.suffix.result}"
#   parent_resource_id     = local.parent_resource_id
#   parent_resource_type   = local.parent_resource_type
#   unique_writer_identity = true
#   include_children       = var.include_children
# }

# module "destination" {
#   source                   = "terraform-google-modules/log-export/google//modules/pubsub"
#   version                  = "~> 5.0"
#   project_id               = module.org_audit_logs[0].project_id
#   topic_name               = "pubsub-org-${random_string.suffix.result}"
#   log_sink_writer_identity = module.log_export.writer_identity
#   create_subscriber        = true
# }

# -------------------------------------------------
#   Storage ORG LEVEL Aggregated Sink
# -------------------------------------------------

// Log archive storage is not necessary. Removing these steps

# resource "random_string" "storage_suffix" {
#   length  = 4
#   upper   = false
#   special = false
# }

# module "log_export_storage" {
#   source                 = "terraform-google-modules/log-export/google"
#   version                = "~> 5.0"
#   destination_uri        = module.destination_storage.destination_uri
#   filter                 = local.all_logs_filter
#   include_children       = var.include_children
#   log_sink_name          = "${var.log_sink_name_storage}_${random_string.storage_suffix.result}"
#   parent_resource_id     = local.parent_resource_id
#   parent_resource_type   = local.parent_resource_type
#   unique_writer_identity = true
# }

# module "destination_storage" {
#   source                   = "terraform-google-modules/log-export/google//modules/storage"
#   version                  = "~> 5.0"
#   project_id               = module.org_audit_logs[0].project_id
#   storage_bucket_name      = "${var.storage_archive_bucket_name}_${random_string.storage_suffix.result}"
#   storage_class            = var.storage_class
#   location                 = var.storage_location
#   log_sink_writer_identity = module.log_export_storage.writer_identity
# }

# -----------------------------------------
#  SCC Notification Setup
# -----------------------------------------

resource "google_pubsub_topic" "scc_notification_topic" {
  name    = var.scc_notification_topic
  project = module.org_audit_logs[0].project_id
}

# Uncommen if you need to enable pub/sub subscriptions

# resource "google_pubsub_subscription" "scc_notification_subscription" {
#   name    = var.scc_notification_subscription
#   topic   = google_pubsub_topic.scc_notification_topic.name
#   project = module.org_audit_logs[0].project_id
# }



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