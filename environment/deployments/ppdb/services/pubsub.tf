# Stage Chunk PubSub

resource "google_pubsub_topic" "stage_chunk_dlt" {
  name = "stage-chunk-dlt"
  project = local.project_id
}

resource "google_pubsub_topic" "stage_chunk_topic" {
  name = "stage-chunk-topic"
  project = local.project_id
}

# Track Chunk PubSub

resource "google_pubsub_topic" "track_chunk_dlt" {
  name = "track-chunk-dlt"
  project = local.project_id
}

resource "google_pubsub_topic" "track_chunk_topic" {
  name = "track-chunk-topic"
  project = local.project_id
}
