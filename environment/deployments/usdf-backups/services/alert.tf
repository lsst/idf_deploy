data "google_monitoring_notification_channel" "slack" {
  display_name = "USDF GCP Backups"
  type       = "slack"
}

resource "google_monitoring_alert_policy" "sts_failed_logs" {
  display_name = "STS - Transfer job errors"
  combiner     = "OR"

  conditions {
    display_name = "Any error log from storage_transfer_job"
    condition_matched_log {
      filter = <<-EOT
        resource.type="storage_transfer_job"
        severity>=ERROR
      EOT
    }
  }

  alert_strategy {
    notification_rate_limit { period = var.notification_rate_limit }
    auto_close = var.auto_close_interval
  }

  notification_channels = [data.google_monitoring_notification_channel.slack.name]
}