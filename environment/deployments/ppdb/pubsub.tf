// stage chunk

resource "google_pubsub_topic" "stage_chunk_dlt" {
  name = "stage-chunk-dlt"
  project = module.project_factory.project_id
}

resource "google_pubsub_topic" "stage_chunk_topic" {
  name = "stage-chunk-topic"
  project = module.project_factory.project_id
}

// track chunk

resource "google_pubsub_topic" "track_chunk_dlt" {
  name = "track-chunk-dlt"
  project = module.project_factory.project_id
}

resource "google_pubsub_topic" "track_chunk_topic" {
  name = "track-chunk-topic"
  project = module.project_factory.project_id
}
