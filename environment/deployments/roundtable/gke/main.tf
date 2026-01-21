# ----------------------------------------
#   RETRIEVE PROJECT NAME BASED ON FILTERS
# ----------------------------------------
// Get project name from label filter
data "google_projects" "host_project" {
  filter = "labels.application_name=${var.application_name} labels.environment=${var.environment}"
}

// Get Network
data "google_compute_network" "network" {
  name    = var.network_name
  project = local.project_id
}

// Get Subnetwork
data "google_compute_subnetwork" "subnetwork" {
  name    = "subnet-us-central1-01"
  region  = "us-central1"
  project = local.project_id
}

# ----------------------------------------
#   GKE
# ----------------------------------------

locals {
  project_id = data.google_projects.host_project.projects[0].project_id
  network    = data.google_compute_network.network.self_link
  subnetwork = data.google_compute_subnetwork.subnetwork.name
}

module "gke" {
  source = "../../../../modules/gke"

  # Cluster
  name                   = "${var.application_name}-${var.environment}"
  project_id             = local.project_id
  network                = var.network_name
  subnetwork             = local.subnetwork
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  node_pools             = var.node_pools
  release_channel        = var.release_channel
  gce_pd_csi_driver      = var.gce_pd_csi_driver
  gcs_fuse_csi_driver    = var.gcs_fuse_csi_driver
  network_policy         = var.network_policy
  maintenance_start_time = var.maintenance_start_time
  maintenance_end_time   = var.maintenance_end_time
  maintenance_recurrence = var.maintenance_recurrence

  enable_dataplane_v2 = var.enable_dataplane_v2

  monitoring_enabled_components        = var.monitoring_enabled_components
  monitoring_enable_managed_prometheus = var.monitoring_enable_managed_prometheus

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = local.subnetwork
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }

  node_pools_taints = var.node_pools_taints

  gke_backup_agent_config = var.gke_backup_agent_config
}

module "gke-new" {
  source = "../../../../modules/gke"

  # Cluster
  name                   = "${var.application_name}-${var.environment}-new"
  project_id             = local.project_id
  network                = var.network_name
  subnetwork             = local.subnetwork
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  node_pools             = var.node_pools
  release_channel        = var.release_channel
  gce_pd_csi_driver      = var.gce_pd_csi_driver
  gcs_fuse_csi_driver    = var.gcs_fuse_csi_driver
  network_policy         = var.network_policy
  maintenance_start_time = var.maintenance_start_time
  maintenance_end_time   = var.maintenance_end_time
  maintenance_recurrence = var.maintenance_recurrence

  enable_dataplane_v2 = true

  monitoring_enabled_components        = var.monitoring_enabled_components
  monitoring_enable_managed_prometheus = var.monitoring_enable_managed_prometheus

  # Labels
  cluster_resource_labels = {
    environment      = var.environment
    project          = local.project_id
    application_name = var.application_name
    subnetwork       = local.subnetwork
  }

  # Node Pools
  node_pools_labels = {
    all = {
      environment      = var.environment
      project          = local.project_id
      application_name = var.application_name
    }
  }

  node_pools_taints = var.node_pools_taints

  gke_backup_agent_config = var.gke_backup_agent_config
}
resource "google_gke_backup_backup_plan" "complete" {
  count = var.cluster_backup_plan != null ? 1 : 0

  name = "${module.gke.name}"
  cluster = module.gke.id
  project = local.project_id
  location = "us-central1"

  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }

  # If you destroy the associated cluster, terraform will try to destroy and
  # recreate this backup plan, which will also try to destroy all of the
  # backups associated with the plan. If we are trying to intentionally rebuild
  # a cluster, we will need to destroy it first, and we don't want this backup
  # plan destroyed.
  lifecycle {
    ignore_changes = [
      cluster,
      name,
    ]
  }
}

resource "google_gke_backup_restore_plan" "complete" {
  count = var.cluster_backup_plan != null ? 1 : 0

  name = "${module.gke.name}"
  project = local.project_id
  location = "us-central1"
  backup_plan = google_gke_backup_backup_plan.complete[0].id
  cluster = module.gke.id

  restore_config {
    all_namespaces = true

    # This can't be FAIL_ON_CONFLICT, because we need to use fine-grained
    # restore, because we need to ignore specific namespaced cert-manager
    # resources, and specific kinds of namespaced resources can't be declared
    # in a restore plan :(
    #
    # This mode merges the backup and the target cluster and skips the
    # conflicting resources except volume data. If a PVC to restore already
    # exists, this mode will restore/reconnect the volume without overwriting
    # the PVC. It is similar to MERGE_SKIP_ON_CONFLICT except that it will
    # apply the volume data policy for the conflicting PVCs: -
    # RESTORE_VOLUME_DATA_FROM_BACKUP: restore data only and respect the
    # reclaim policy of the original PV; - REUSE_VOLUME_HANDLE_FROM_BACKUP:
    # reconnect and respect the reclaim policy of the original PV; -
    # NO_VOLUME_DATA_RESTORATION: new provision and respect the reclaim policy
    # of the original PV. Note that this mode could cause data loss as the
    # original PV can be retained or deleted depending on its reclaim policy.
    namespaced_resource_restore_mode = "MERGE_REPLACE_VOLUME_ON_CONFLICT"

    # We're assuming this restore plan is intended to run on a completely empty
    # new cluster, so REUSE_VOLUME_HANDLE_FROM_BACKUP won't work.
    volume_data_restore_policy = "RESTORE_VOLUME_DATA_FROM_BACKUP"

    cluster_resource_conflict_policy = "USE_EXISTING_VERSION"

    # If we don't provision restored PVs with a "Retain" reclaim policy, then
    # there is a race condition in the restore where they could get deleted
    # because they get provisioned unbound to a PVC.
    transformation_rules {
      description = "Provision all PVs with Retain reclaim policy"
      resource_filter {
        group_kinds {
          resource_kind = "PersistentVolume"
          resource_group = ""
        }
      }
      field_actions {
        op = "REPLACE"
        path = "/spec/persistentVolumeReclaimPolicy"
        value = "Retain"
      }
    }

    cluster_resource_restore_scope {

      # If we're restoring to a DataplaneV2 cluster from a non-DataplaneV2
      # backup, we don't want to restore these resources, since the Calico
      # CRDs won't exist. If we're restoring from DataplaneV2 to DataplaneV2,
      # then we shouldn't have any of these resources in the backup anyway
      # and this won't matter.
      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "BGPConfiguration"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "BGPFilter"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "BGPPeer"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "BlockAffinity"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "CalicoNodeStatus"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "ClusterInformation"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "FelixConfiguration"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "GlobalBGPConfig"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "GlobalFelixConfig"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "GlobalNetworkPolicy"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "GlobalNetworkSet"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "HostEndpoint"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "IPAMBlock"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "IPAMConfig"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "IPAMHandle"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "IPPool"
      }

      excluded_group_kinds {
        resource_group = "crd.projectcalico.org"
        resource_kind = "IPReservation"
      }

      excluded_group_kinds {
      resource_group = "crd.projectcalico.org"
        resource_kind = "KubeControllersConfiguration"
      }
    }
  }

  # If you destroy the associated cluster, terraform will try to destroy and
  # recreate this restore plan. If we are trying to intentionally rebuild a
  # cluster, we will need to destroy it first, and we don't want this restore
  # plan destroyed.
  lifecycle {
    ignore_changes = [
      cluster,
      name,
    ]
  }
}
