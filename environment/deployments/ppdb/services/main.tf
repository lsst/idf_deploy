data "terraform_remote_state" "ppdb_project" {
  backend = "gcs"

  config = {
    prefix = "${var.application_name}/${var.environment}"
    bucket = var.state_bucket
  }
}
