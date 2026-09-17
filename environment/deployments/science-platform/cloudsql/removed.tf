removed {
  from = google_project_iam_member.ppdbtap_bigquery_data_viewer

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_member.ppdbtap_bigquery_job_user

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_member.ppdbtap_bigquery_read_session_user

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_member.bigquery_kafka_bigquery_data_viewer

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_member.bigquery_kafka_bigquery_job_user

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_member.bigquery_kafka_bigquery_read_session_user

  lifecycle {
    destroy = false
  }
}
