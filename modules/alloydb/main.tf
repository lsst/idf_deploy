resource "google_alloydb_cluster" "data_preview" {
  cluster_id = var.cluster_id
  database_version = var.database_version
  location   = "us-central1"
  project = var.project_id
  network_config {
    network = var.network_id
  }
}

resource "google_alloydb_instance" "data_preview_primary" {
  cluster = google_alloydb_cluster.data_preview.name
  instance_id = "${var.cluster_id}-primary"
  instance_type = "PRIMARY"
  # Only allocate a single node for the master, instead of two across
  # multiple zones.
  # End users will only be accessing the read pool, so we don't need
  # the master to be highly available.
  availability_type = "ZONAL"
  
  machine_config {
    machine_type = "n2-highmem-2"
  }

  network_config {
    # Enabling public IP without any authorized_external_networks blocks means
    # that connections will be required to go through the AlloyDB Auth Proxy.
    enable_public_ip = var.enable_public_ip_for_primary
  }

  lifecycle {
    # Have Terraform ignore changes to the machine type, so we can tweak
    # it on the fly in Google Cloud console.
    ignore_changes = [machine_config[0].machine_type]
  }
}

resource "google_alloydb_instance" "data_preview_readpool" {
  cluster = google_alloydb_cluster.data_preview.name
  instance_id = "${var.cluster_id}-readpool"
  instance_type = "READ_POOL"

  machine_config {
    machine_type = "n2-highmem-2"
  }

  read_pool_config {
    node_count = 1
  }

  depends_on = [google_alloydb_instance.data_preview_primary]

  lifecycle {
    # Have Terraform ignore changes to the machine type and node count values.
    # This allows the sizing of the read pool to be tweaked on the fly in the
    # Google Cloud console.
    ignore_changes = [machine_config[0].machine_type, read_pool_config[0].node_count]
  }
}