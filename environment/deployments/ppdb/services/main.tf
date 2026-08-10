data "terraform_remote_state" "ppdb_project" {
  backend = "gcs"

  config = {
    prefix = "${var.application_name}/${var.environment}"
    bucket = var.state_bucket
  }
}

data "terraform_remote_state" "ppdb_cloud_sql" {
  backend = "gcs"

  config = {
    prefix = "${var.application_name}/${var.environment}/cloudsql"
    bucket = var.state_bucket
  }
}

data "terraform_remote_state" "science_platform_cloudsql" {
  backend = "gcs"

  config = {
    prefix = "science-platform/${var.environment}/cloudsql"
    bucket = var.state_bucket
  }
}
