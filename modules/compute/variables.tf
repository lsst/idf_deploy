variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "region" {
  description = "The default region to place subnetwork"
  type        = string
  default     = "us-central1"
}

variable "subnetwork" {
  description = "The name of the subnetwork create this instance in."
  default     = ""
}

variable "hostname" {
  description = "VM hostname"
  type        = string
  default     = "instance-simple"
}

variable "num_instances" {
  description = "Number of instances to create"
  default     = 1
}

# variable "nat_ip" {
#   description = "Public ip address"
#   default     = null
# }

# variable "network_tier" {
#   description = "Network network_tier"
#   default     = "PREMIUM"
# }

variable "service_account" {
  default = ({
    email  = null,
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  })
  type = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n2-standard-4"
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "preemptible" {
  type        = bool
  description = "Allow the instance to be preempted"
  default     = false
}

#######
# disk
#######
variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = "centos-7"
}

variable "source_image_project" {
  description = "Project where the source image comes from. The default project contains images that support Shielded VMs if desired"
  default     = "gce-uefi-images"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  default     = "100"
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = "true"
}

###########
# metadata
###########

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

###########################
# Shielded VMs
###########################
variable "enable_shielded_vm" {
  default     = true
  description = "Whether to enable the Shielded VM configuration on the instance. Note that the instance image must support Shielded VMs. See https://cloud.google.com/compute/docs/images"
}

variable "shielded_instance_config" {
  description = "Not used unless enable_shielded_vm is true. Shielded VM configuration for the instance."
  type = object({
    enable_secure_boot          = bool
    enable_vtpm                 = bool
    enable_integrity_monitoring = bool
  })

  default = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

###########################
# Public IP
###########################
variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = []
}
