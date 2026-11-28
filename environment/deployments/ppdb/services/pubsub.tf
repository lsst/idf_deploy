# Stage Chunk PubSub

resource "google_pubsub_topic" "stage_chunk_dlt" {
  name = "stage-chunk-dlt"
  project = local.project_id
}

resource "google_pubsub_topic" "stage_chunk_topic" {
  name = "stage-chunk-topic"
  project = local.project_id
}

# Load SSO PubSub

resource "google_pubsub_topic" "load_sso_dlt" {
  name = "load-sso-dlt"
  project = local.project_id
}

resource "google_pubsub_topic" "load_sso_topic" {
  name = "load-sso-topic"
  project = local.project_id
}

# Result of each SSO load, published by load-sso and read by
# ppdb-cli upload-sso-data, which waits for it
resource "google_pubsub_topic" "load_sso_result" {
  name    = "load-sso-result"
  project = local.project_id
}

resource "google_pubsub_subscription" "load_sso_result" {
  name    = "load-sso-result-sub"
  project = local.project_id
  topic   = google_pubsub_topic.load_sso_result.id

  # Results are read within minutes, so old ones aren't kept.
  message_retention_duration = "3600s"

  expiration_policy {
    ttl = ""
  }
}

# Promotion PubSub

# Published by the promote-chunks job after each successful promotion. Each
# export has its own subscription.
resource "google_pubsub_topic" "promotion_succeeded" {
  name    = "promotion-succeeded"
  project = local.project_id
}

# Export DiaSource Min SSP PubSub

resource "google_pubsub_topic" "export_diasource_min_ssp_dlt" {
  name    = "export-diasource-min-ssp-dlt"
  project = local.project_id
}
