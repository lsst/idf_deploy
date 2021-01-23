# ----------------------------------------
#   LOCAL PEER
# ----------------------------------------
data "google_projects" "local_peer_project" {
  filter = "labels.application_name=${var.application_name} labels.environment=${var.environment}"
}

// Get the self link of the VPC in remote project
data "google_compute_network" "local_network" {
  project = data.google_projects.local_peer_project.projects[0].project_id
  name    = var.network_name
}

# ----------------------------------------
#   REMOTE PEER
# ----------------------------------------
// Filter project based on the project labels of the remote project
data "google_projects" "remote_peer_project" {
  filter = "labels.application_name=${var.remote_application_name} labels.environment=${var.remote_environment}"
}

// Get the self link of the VPC in local project
data "google_compute_network" "remote_peer_project" {
  project = data.google_projects.remote_peer_project.projects[0].project_id
  name    = var.remote_network_name
}

// Filter project based on the project labels of the remote project
data "google_projects" "remote_peer_project2" {
  filter = "labels.application_name=${var.remote_application_name2} labels.environment=${var.remote_environment2}"
}

// Get the self link of the VPC in local project
data "google_compute_network" "remote_peer_project2" {
  project = data.google_projects.remote_peer_project2.projects[0].project_id
  name    = var.remote_network_name2
}

# ----------------------------------------
#   VPC PEERING
# ----------------------------------------
module "peering-1" {
  source = "../../../../modules/vpc_peering"

  local_network = data.google_compute_network.local_network.self_link
  peer_network  = data.google_compute_network.remote_peer_project.self_link

  export_local_custom_routes = true
}

module "peering-2" {
  source = "../../../../modules/vpc_peering"

  local_network = data.google_compute_network.remote_peer_project.self_link
  peer_network  = data.google_compute_network.local_network.self_link

  export_local_custom_routes = true

  module_depends_on = [module.peering-1.complete]
}
module "peering-3" {
  source = "../../../../modules/vpc_peering"

  local_network = data.google_compute_network.local_network.self_link
  peer_network  = data.google_compute_network.remote_peer_project2.self_link

  export_local_custom_routes = true
}

module "peering-4" {
  source = "../../../../modules/vpc_peering"

  local_network = data.google_compute_network.remote_peer_project2.self_link
  peer_network  = data.google_compute_network.local_network.self_link

  export_local_custom_routes = true

  module_depends_on = [module.peering-3.complete]
}
