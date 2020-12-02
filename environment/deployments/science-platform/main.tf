module "project_factory" {
  source           = "../../../modules/project_vpc"
  org_id           = var.org_id
  folder_id        = var.folder_id
  billing_account  = var.billing_account
  project_prefix   = "${var.application_name}-${var.environment}"
  application_name = var.application_name
  environment      = var.environment
  activate_apis    = var.activate_apis
  budget_amount    = var.budget_amount
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
  routing_mode     = var.routing_mode
}

module "iam_admin" {
  source                  = "../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

module "gke" {
  source = "../../../modules/gke"

  # Cluster
  name                   = "${var.application_name}-${var.environment}"
  network                = module.project_factory.network_name
  project_id             = module.project_factory.project_id
  subnetwork             = module.project_factory.subnets_names[0]
  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  # Node Pool
  node_pool_1_name               = var.node_pool_1_name
  node_pool_1_machine_type       = var.node_pool_1_machine_type
  node_pool_1_min_count          = var.node_pool_1_min_count
  node_pool_1_max_count          = var.node_pool_1_max_count
  node_pool_1_local_ssd_count    = var.node_pool_1_local_ssd_count
  node_pool_1_disk_size_gb       = var.node_pool_1_disk_size_gb
  node_pool_1_initial_node_count = var.node_pool_1_initial_node_count

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = module.project_factory.project_name
    application_name = var.application_name
  }

  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = module.project_factory.project_name
      application_name = var.application_name
      infrastructure   = "ok"
      jupyterlab       = "ok"
      dask             = "ok"
    }
  }
}

module "filestore" {
  source             = "../../../modules/filestore"
  fileshare_capacity = var.fileshare_capacity
  fileshare_name     = var.fileshare_name
  modes              = var.modes
  name               = "${var.name}-${var.environment}"
  network            = module.project_factory.network_name
  project            = module.project_factory.project_id
  tier               = var.tier
  zone               = var.zone

  depends_on = [module.project_factory]
}

module "nat" {
  source  = "../../../modules/nat"
  name    = var.router_name
  project = module.project_factory.project_id
  network = module.project_factory.network_name
  region  = var.default_region
  nats    = var.nats
}

module "service_account_cluster" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 2.0"
  project_id = module.project_factory.project_id
  prefix     = var.environment
  names      = ["cluster"]
  project_roles = [
    "${module.project_factory.project_id}=>roles/container.clusterAdmin",
  ]
}