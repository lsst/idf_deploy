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

resource "google_service_account" "datalinker_sa" {
  account_id   = "datalinker"
  display_name = "datalinker web service"
  description  = "Terraform-managed service account for GCS access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "datalinker_sa_wi" {
  service_account_id = google_service_account.datalinker_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[datalinker/datalinker]"
}

resource "google_service_account" "filestore_tool_sa" {
  account_id   = "filestore-tool"
  display_name = "filestore tool account"
  description  = "Terraform-managed service account for Filestore access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "filestore_tool_sa_wi" {
  service_account_id = google_service_account.filestore_tool_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[filestore-backup/filestore-backup]"
}

resource "google_project_iam_member" "filestore_tool_sa_file" {
  role               = "roles/file.editor"
  member             = "serviceAccount:${google_service_account.filestore_tool_sa.email}"
  project            = module.project_factory.project_id
}

# Analogous to Filestore, but Netapp Cloud Volumes

resource "google_service_account" "netapp_admin_sa" {
  account_id   = "netapp-admin"
  display_name = "Netapp Cloud Volume admin service account"
  description  = "Terraform-managed service account for Netapp Cloud Volume access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "netapp_admin_sa_wi" {
  service_account_id = google_service_account.netapp_admin_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[netapp-backup/netapp-backup]"
}

resource "google_project_iam_member" "netapp_admin_sa_file" {
  role               = "roles/netapp.admin"
  member             = "serviceAccount:${google_service_account.netapp_admin_sa.email}"
  project            = module.project_factory.project_id
}


resource "google_service_account" "gar_sa" {
  account_id   = "cachemachine-wi"
  display_name = "Created by Terraform"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "gar_sa_wi" {
  service_account_id = google_service_account.gar_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[cachemachine/cachemachine]"
}

resource "google_service_account" "nublado_gar_sa" {
  account_id   = "nublado-controller"
  display_name = "Terraform-managed service account for GAR access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "nublado_gar_sa_wi" {
  service_account_id = google_service_account.nublado_gar_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[nublado/nublado-controller]"
}

resource "google_service_account" "dns_validator_sa" {
  account_id   = "dns-validator-wi"
  display_name = "Created by Terraform"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "dns_validator_sa_wi" {
  service_account_id = google_service_account.dns_validator_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[linters/linters]"
}

resource "google_project_iam_member" "dns_validator_sa_dns" {
  role               = "roles/compute.viewer"
  member             = "serviceAccount:${google_service_account.dns_validator_sa.email}"
  project            = module.project_factory.project_id
}

resource "google_service_account" "hips_sa" {
  account_id   = "crawlspace-hips"
  display_name = "HiPS web service"
  description  = "Terraform-managed service account for GCS access"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "hips_sa_wi" {
  service_account_id = google_service_account.hips_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[hips/hips]"
}

resource "google_service_account" "sqlproxy_butler_int_sa" {
  count        = var.environment != "stable" ? 1 : 0
  account_id   = "sqlproxy-butler-int"
  display_name = "Created by Terraform"
  project      = module.project_factory.project_id
}

resource "google_service_account_iam_member" "sqlproxy_butler_int_sa" {
  count              = var.environment != "stable" ? 1 : 0
  service_account_id = google_service_account.sqlproxy_butler_int_sa[count.index].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${module.project_factory.project_id}.svc.id.goog[sqlproxy-cross-project/sqlproxy-butler-int]"
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
  labels = {
    project          = module.project_factory.project_id
    environment      = var.environment
    application_name = var.application_name
  }

  depends_on = [module.project_factory]
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

module "netapp-volumes" {
  source             = "../../../modules/netapp_volumes"
  network            = module.project_factory.network_name
  project            = module.project_factory.project_id
  location           = var.location
  labels             = var.labels
  definitions        = var.netapp_definitions

  depends_on = [module.project_factory]
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
