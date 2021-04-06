locals {
  hostname      = var.hostname == "" ? "default" : var.hostname
  num_instances = length(var.static_ips) == 0 ? var.num_instances : length(var.static_ips)
  # local.static_ips is the same as var.static_ips with a dummy element appended
  # at the end of the list to work around "list does not have any elements so cannot
  # determine type" error when var.static_ips is empty
  static_ips = concat(var.static_ips, ["NOT_AN_IP"])

  # NOTE: Even if all the shielded_instance_config values are false, if the
  # config block exists and an unsupported image is chosen, the apply will fail
  # so we use a single-value array with the default value to initialize the block
  # only if it is enabled.
  shielded_vm_configs = var.enable_shielded_vm ? [true] : []
}

###############
# Data Sources
###############
# data "google_compute_image" "image_family" {
#   project = var.source_image_family != "" ? var.source_image_project : "centos-cloud"
#   family  = var.source_image_family != "" ? var.source_image_family : "centos-7"
# }

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
  status  = "UP"
}

resource "google_compute_instance" "default" {
  count                   = var.num_instances
  name                    = "${local.hostname}-${format("%03d", count.index + 1)}"
  machine_type            = var.machine_type
  zone                    = data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)]
  project                 = var.project
  metadata                = var.metadata
  metadata_startup_script = var.startup_script
  can_ip_forward          = var.can_ip_forward
  tags                    = var.tags
  labels                  = var.labels
  scheduling {
    preemptible       = var.preemptible
    automatic_restart = ! var.preemptible
  }

  boot_disk {
    initialize_params {
      #image = data.google_compute_image.image_family.self_link
      image = var.image
      size  = var.size
      type  = var.type
    }
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = length(var.static_ips) == 0 ? "" : element(local.static_ips, count.index)
    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }

  dynamic "shielded_instance_config" {
    for_each = local.shielded_vm_configs
    content {
      enable_secure_boot          = lookup(var.shielded_instance_config, "enable_secure_boot", shielded_instance_config.value)
      enable_vtpm                 = lookup(var.shielded_instance_config, "enable_vtpm", shielded_instance_config.value)
      enable_integrity_monitoring = lookup(var.shielded_instance_config, "enable_integrity_monitoring", shielded_instance_config.value)
    }
  }
}
