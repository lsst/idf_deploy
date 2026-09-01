data "terraform_remote_state" "usdf_backups_project" {
  backend = "gcs"

  config = {
    prefix = "${var.application_name}/${var.environment}"
    bucket = var.state_bucket
  }
}
