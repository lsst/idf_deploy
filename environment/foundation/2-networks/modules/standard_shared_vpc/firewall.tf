
/******************************************
  Optional firewall rules
 *****************************************/

// Allow SSH via IAP when using the allow-iap-ssh tag for Linux workloads.
resource "google_compute_firewall" "allow_iap_ssh" {
  count          = var.default_fw_rules_enabled ? 1 : 0
  name           = "fw-allow-iap-ssh-tcp-22"
  network        = module.main.network_name
  project        = var.project_id
  enable_logging = true

  // Cloud IAP's TCP forwarding netblock
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-iap-ssh"]
}

// Allow RDP via IAP when using the allow-iap-rdp tag for Windows workloads.
resource "google_compute_firewall" "allow_iap_rdp" {
  count          = var.default_fw_rules_enabled ? 1 : 0
  name           = "fw-allow-iap-rdp-tcp-3389"
  network        = module.main.network_name
  project        = var.project_id
  enable_logging = true

  // Cloud IAP's TCP forwarding netblock
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  target_tags = ["allow-iap-rdp"]
}

// Allow access to kms.windows.googlecloud.com for Windows license activation
resource "google_compute_firewall" "allow_windows_activation" {
  count          = var.default_fw_rules_enabled ? 1 : 0
  name           = "fw-allow-win-activation-all-tcp-1688"
  network        = module.main.network_name
  project        = var.project_id
  direction      = "EGRESS"
  priority       = 0
  enable_logging = true

  allow {
    protocol = "tcp"
    ports    = ["1688"]
  }

  destination_ranges = ["35.190.247.13/32"]

  target_tags = ["allow-win-activation"]
}