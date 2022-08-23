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
data "google_projects" "remote2_peer_project" {
  filter = "labels.application_name=${var.remote2_application_name} labels.environment=${var.remote2_environment}"
}

// Get the self link of the VPC in local project
data "google_compute_network" "remote2_peer_project" {
  project = data.google_projects.remote2_peer_project.projects[0].project_id
  name    = var.remote2_network_name
}

# ----------------------------------------
#   VPC PEERING
# ----------------------------------------

module "peering-3" {
  # qserv-int <-> rsp-dev
  source = "../../../../modules/vpc_peering"

  local_network = data.google_compute_network.local_network.self_link
  peer_network  = data.google_compute_network.remote2_peer_project.self_link
  peer_name     = "vpc-peer-qserv-int-to-rsp-dev"

  export_local_custom_routes = true
}

module "peering-4" {
  # rsp-dev <-> qserv-int
  source = "../../../../modules/vpc_peering"

  local_network = data.google_compute_network.remote2_peer_project.self_link
  peer_network  = data.google_compute_network.local_network.self_link
  peer_name     = "vpc-peer-rsp-dev-to-qserv-int"

  export_local_custom_routes = true

  module_depends_on = [module.peering-3.complete]
}