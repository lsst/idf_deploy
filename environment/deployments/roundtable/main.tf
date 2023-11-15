module "project_factory" {
  source                      = "../../../modules/project_vpc"
  org_id                      = var.org_id
  folder_id                   = var.folder_id
  billing_account             = var.billing_account
  project_prefix              = "${var.application_name}-${var.environment}"
  application_name            = var.application_name
  environment                 = var.environment
  activate_apis               = var.activate_apis
  budget_amount               = var.budget_amount
  budget_alert_spent_percents = var.budget_alert_spent_percents
  subnets                     = var.subnets
  secondary_ranges            = var.secondary_ranges
  routing_mode                = var.routing_mode
}

module "iam_admin" {
  source                  = "../../../modules/iam"
  project                 = module.project_factory.project_id
  project_iam_permissions = var.project_iam_permissions
  member                  = "gcp-${var.application_name}-administrators@lsst.cloud"
}

resource "google_service_account" "git_lfs_rw_sa" {
  account_id   = "git-lfs-rw"
  display_name = "Git LFS (RW)"
  description  = "Terraform-managed service account for Git LFS RW access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "git_lfs_rw_sa_wi" {
  service_account_id = google_service_account.git_lfs_rw_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-rw]"
}

# The git-lfs service accounts must be granted the ability to generate
# tokens for themselves so that they can generate signed GCS URLs
# starting from the GKE service account token without requiring an
# exported secret key for the underlying Google service account.
resource "google_service_account_iam_binding" "git-lfs-rw-gcs-binding" {
  service_account_id = google_service_account.git_lfs_rw_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-rw]"
  ]
}

resource "google_service_account" "git_lfs_ro_sa" {
  account_id   = "git-lfs-ro"
  display_name = "Git LFS (RO)"
  description  = "Terraform-managed service account for Git LFS RO access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "git_lfs_ro_sa_wi" {
  service_account_id = google_service_account.git_lfs_ro_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-ro]"
}

resource "google_service_account_iam_binding" "git-lfs-ro-gcs-binding" {
  service_account_id = google_service_account.git_lfs_ro_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${module.project_factory.project_id}.svc.id.goog[giftless/git-lfs-ro]"
  ]
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

module "firewall_cert_manager" {
  source = "../../../modules/firewall"

  project_id   = module.project_factory.project_id
  network      = module.project_factory.network_name
  custom_rules = var.custom_rules
}

// Reserve a public IP for ingress
resource "google_compute_address" "external_ip_address" {
  name    = "public-ip"
  region  = var.default_region
  project = module.project_factory.project_id
}

// Reserve a static ip for Cloud NAT
resource "google_compute_address" "static" {
  count        = var.num_static_ips
  project      = module.project_factory.project_id
  name         = "${var.application_name}-${var.environment}-nat-${count.index}"
  description  = "Reserved static IP ${count.index} addresses managed by Terraform."
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.default_region
}

module "nat" {
  source  = "../../../modules/nat"
  name    = var.router_name
  project = module.project_factory.project_id
  network = module.project_factory.network_name
  region  = var.default_region
  #nats    = var.nats
  nats = [{
    name    = "cloud-nat",
    nat_ips = google_compute_address.static.*.name
  }]
}
