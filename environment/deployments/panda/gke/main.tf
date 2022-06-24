# ----------------------------------------
#   RETRIEVE PROJECT NAME BASED ON FILTERS
# ----------------------------------------

data "google_projects" "host_project" {
  filter = "labels.application_name=${var.application_name} labels.environment=${var.environment}"
}

data "google_compute_network" "network" {
  name    = var.network_name
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork" {
  name    = "subnet-us-central1-01"
  region  = "us-central1"
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork_2" {
  name    = "subnet-us-central1-02"
  region  = "us-central1"
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork_3" {
  name    = "subnet-us-central1-03"
  region  = "us-central1"
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork_4" {
  name    = "subnet-us-central1-04"
  region  = "us-central1"
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork_5" {
  name    = "subnet-us-central1-05"
  region  = "us-central1"
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork_6" {
  name    = "subnet-us-central1-06"
  region  = "us-central1"
  project = local.project_id
}

data "google_compute_subnetwork" "subnetwork_7" {
  name    = "subnet-us-central1-07"
  region  = "us-central1"
  project = local.project_id
}

# ----------------------------------------
#   GKE
# ----------------------------------------

locals {
  project_id   = data.google_projects.host_project.projects[0].project_id
  network      = data.google_compute_network.network.name
  subnetwork   = data.google_compute_subnetwork.subnetwork.name
  subnetwork_2 = data.google_compute_subnetwork.subnetwork_2.name
  subnetwork_3 = data.google_compute_subnetwork.subnetwork_3.name
  subnetwork_4 = data.google_compute_subnetwork.subnetwork_4.name
}

#moderatemem
module "gke" {
  # This cluster has a different release channel than others
  source = "../../../../modules/gke"

  # Cluster
  name                      = "moderatemem"
  project_id                = local.project_id
  network                   = var.network_name
  subnetwork                = local.subnetwork
  master_ipv4_cidr_block    = var.master_ipv4_cidr_block
  release_channel           = "REGULAR"
  node_pools                = var.node_pools_moderatemem
  network_policy            = var.network_policy
  gce_pd_csi_driver         = false
  cluster_telemetry_type    = var.cluster_telemetry_type
  cluster_autoscaling       = var.cluster_autoscaling_1
  default_max_pods_per_node = 15
  maintenance_start_time    = var.maintenance_start_time_weekly
  maintenance_end_time      = var.maintenance_end_time_weekly
  maintenance_recurrence    = var.maintenance_recurrence_weekly
  identity_namespace        = null
  node_metadata             = "UNSPECIFIED"
  dns_cache                 = true
  http_load_balancing       = false

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = local.subnetwork
    cluster_name     = "moderatemem"
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}

# highmem
module "gke_2" {
  source = "../../../../modules/gke"

  # Cluster
  name                      = "highmem"
  project_id                = local.project_id
  network                   = var.network_name
  subnetwork                = local.subnetwork_2
  master_ipv4_cidr_block    = var.master_ipv4_cidr_block_2
  release_channel           = "REGULAR"
  node_pools                = var.node_pools_highmem
  network_policy            = var.network_policy
  gce_pd_csi_driver         = false
  cluster_telemetry_type    = var.cluster_telemetry_type
  zones                     = var.zones
  cluster_autoscaling       = var.cluster_autoscaling_2
  default_max_pods_per_node = var.max_pods_per_node
  maintenance_start_time    = var.maintenance_start_time_weekly
  maintenance_end_time      = var.maintenance_end_time_weekly
  maintenance_recurrence    = var.maintenance_recurrence_weekly
  identity_namespace        = null
  node_metadata             = "UNSPECIFIED"
  dns_cache                 = true
  http_load_balancing       = false

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = local.subnetwork_2
    cluster_name     = "highmem"
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}

# highmem non preempt
module "gke_non_preemtible" {
  # This cluster has a different release channel than others
  source = "../../../../modules/gke"

  # Cluster
  name                      = "highmem-non-preempt"
  project_id                = local.project_id
  network                   = var.network_name
  subnetwork                = "subnet-us-central1-04"
  master_ipv4_cidr_block    = var.master_ipv4_cidr_block_4
  release_channel           = "REGULAR"
  node_pools                = var.node_pools_highmem_non_preempt
  network_policy            = var.network_policy
  gce_pd_csi_driver         = false
  cluster_telemetry_type    = var.cluster_telemetry_type
  zones                     = var.zones
  cluster_autoscaling       = var.cluster_autoscaling_3
  default_max_pods_per_node = var.max_pods_per_node
  maintenance_start_time    = var.maintenance_start_time_weekly
  maintenance_end_time      = var.maintenance_end_time_weekly
  maintenance_recurrence    = var.maintenance_recurrence_weekly
  identity_namespace        = null
  node_metadata             = "UNSPECIFIED"
  dns_cache                 = true
  http_load_balancing       = false

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = "subnet-us-central1-04"
    cluster_name     = "highmem-non-preempt"
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}

#merge
module "gke_merge" {
  source = "../../../../modules/gke"

  # Cluster
  name                      = "merge"
  project_id                = local.project_id
  network                   = var.network_name
  subnetwork                = "subnet-us-central1-05"
  master_ipv4_cidr_block    = var.master_ipv4_cidr_block_5
  release_channel           = "REGULAR"
  node_pools                = var.node_pools_merge
  network_policy            = var.network_policy
  gce_pd_csi_driver         = false
  cluster_telemetry_type    = var.cluster_telemetry_type
  zones                     = var.zones
  cluster_autoscaling       = var.cluster_autoscaling_4
  default_max_pods_per_node = var.max_pods_per_node
  maintenance_start_time    = var.maintenance_start_time_weekly
  maintenance_end_time      = var.maintenance_end_time_weekly
  maintenance_recurrence    = var.maintenance_recurrence_weekly
  identity_namespace        = null
  node_metadata             = "UNSPECIFIED"
  dns_cache                 = true
  http_load_balancing       = false

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = "subnet-us-central1-05"
    cluster_name     = "merge"
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}

#development
module "gke_dev" {
  source = "../../../../modules/gke"

  # Cluster
  name                   = "developmentcluster"
  project_id             = local.project_id
  network                = var.network_name
  subnetwork             = "subnet-us-central1-03"
  master_ipv4_cidr_block = var.master_ipv4_cidr_block_3
  release_channel        = "REGULAR"
  node_pools             = var.node_pools_dev
  network_policy         = var.network_policy
  gce_pd_csi_driver      = false
  cluster_telemetry_type = var.cluster_telemetry_type
  zones                  = var.zones
  maintenance_start_time = var.maintenance_start_time_weekly
  maintenance_end_time   = var.maintenance_end_time_weekly
  maintenance_recurrence = var.maintenance_recurrence_weekly
  identity_namespace     = null
  node_metadata          = "UNSPECIFIED"
  dns_cache              = true
  http_load_balancing    = false

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = "subnet-us-central1-03"
    cluster_name     = "developmentcluster"
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}

#extra highmem
module "gke_extra_large" {
  source = "../../../../modules/gke"

  # Cluster
  name                      = "extra-highmem"
  project_id                = local.project_id
  network                   = var.network_name
  subnetwork                = "subnet-us-central1-06"
  master_ipv4_cidr_block    = var.master_ipv4_cidr_block_6
  release_channel           = "REGULAR"
  node_pools                = var.node_pool_extra_mem
  network_policy            = var.network_policy
  gce_pd_csi_driver         = false
  cluster_telemetry_type    = var.cluster_telemetry_type
  zones                     = var.zones
  cluster_autoscaling       = var.cluster_autoscaling_5
  default_max_pods_per_node = var.max_pods_per_node
  maintenance_start_time    = var.maintenance_start_time_weekly
  maintenance_end_time      = var.maintenance_end_time_weekly
  maintenance_recurrence    = var.maintenance_recurrence_weekly
  identity_namespace        = null
  node_metadata             = "UNSPECIFIED"
  dns_cache                 = true
  http_load_balancing       = false

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = "subnet-us-central1-06"
    cluster_name     = "extra-highmem"
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}

#extra highmem nonpreempt
module "gke_extra_large_non_preempt" {
  source = "../../../../modules/gke"

  # Cluster
  name                      = "extra-highmem-non-preempt"
  project_id                = local.project_id
  network                   = var.network_name
  subnetwork                = "subnet-us-central1-07"
  master_ipv4_cidr_block    = var.master_ipv4_cidr_block_7
  release_channel           = "REGULAR"
  node_pools                = var.node_pool_extra_mem_non_preempt
  network_policy            = var.network_policy
  gce_pd_csi_driver         = false
  cluster_telemetry_type    = var.cluster_telemetry_type
  zones                     = var.zones
  cluster_autoscaling       = var.cluster_autoscaling_7
  default_max_pods_per_node = var.max_pods_per_node
  maintenance_start_time    = var.maintenance_start_time_weekly
  maintenance_end_time      = var.maintenance_end_time_weekly
  maintenance_recurrence    = var.maintenance_recurrence_weekly
  identity_namespace        = null
  node_metadata             = "UNSPECIFIED"
  dns_cache                 = true
  http_load_balancing       = false

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = "subnet-us-central1-07"
    cluster_name     = "extra-highmem-non-preempt"
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }
}
