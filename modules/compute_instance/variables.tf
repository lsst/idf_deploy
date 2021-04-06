variable "hostname" {
  description = "Hostname of instances"
  default     = ""
}

variable "project" {
  description = "The project id"
  type        = string
}

variable "machine_type" {
  description = "The machine type to create"
  type        = string
  default     = "e2-medium"
}

variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  default     = "1"
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "region" {
  description = "The region to deploy the instance."
  type        = string
}

variable "zone" {
  description = "The zone that the machine should be created in"
  type        = string
  default     = "us-central1-a"
}

variable "tags" {
  description = "A list of network tags to attach to the instance"
  type        = list(string)
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "preemptible" {
  type        = bool
  description = "Allow the instance to be preempted"
  default     = false
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  default     = ""
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  default     = ""
}

variable "subnetwork_project" {
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used."
  default     = ""
}

variable "network_ip" {
  description = "The private IP address to assign to the instance. If emtpy, the address will be automatically assigned."
  type        = string
  default     = ""
}

variable "static_ips" {
  type        = list(string)
  description = "List of static IPs for VM instances"
  default     = []
}

variable "network_tier" {
  description = "The networking tier for the instance. Can take `PREMIUM` or `STANDARD`."
  type        = string
  default     = "PREMIUM"
}

variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = []
}

variable "size" {
  description = "The size of the image in gigabytes."
  type        = number
  default     = 50
}

variable "image" {
  description = "The image from which to initialize this disk."
  type        = string
}

variable "type" {
  description = "The GCE disk type. Maybe `pd-standard`,`pd-balanced`, `pd-ssd`"
  type        = string
  default     = "pd-standard"
}

variable "service_account" {
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
  default     = null
}

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