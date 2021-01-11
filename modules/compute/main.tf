module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 6.0"

  region          = var.region
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  tags            = var.tags
  labels          = var.labels
  machine_type    = var.machine_type
  can_ip_forward  = var.can_ip_forward
  preemptible     = var.preemptible

  # disk
  source_image         = var.source_image
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  disk_size_gb         = var.disk_size_gb
  disk_type            = var.disk_type
  auto_delete          = var.auto_delete

  #metadata
  startup_script = var.startup_script
  metadata       = var.metadata
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "~> 6.0"

  region            = var.region
  subnetwork        = var.subnetwork
  num_instances     = var.num_instances
  hostname          = var.hostname
  instance_template = module.instance_template.self_link


  access_config = [{
    nat_ip       = var.nat_ip
    network_tier = var.network_tier
  }, ]
}