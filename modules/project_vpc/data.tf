data "google_projects" "projects" {
  count  = var.vpc_type == "" ? 0 : 1
  filter = "labels.application_name:org-shared-vpc-${var.environment}"
}

data "google_compute_network" "shared_vpc" {
  count   = var.vpc_type == "" ? 0 : 1
  name    = "shared-vpc-${var.environment}"
  project = data.google_projects.projects[0].projects[0].project_id
}