
module "compute_dashboard" {
    source                    = "../../../modules/monitoring/compute"
    project                   = var.project
    compute_dashboard_enable  = var.compute_dashboard_enable
    compute_dashboard_name    = var.compute_dashboard_name
}

module "cloud_storage_dashboard" {
    source                          = "../../../modules/monitoring/gcs"
    project                         = var.project
    gcs_dashboard_enable            = var.gcs_dashboard_enable
    gcs_dashboard_name              = var.gcs_dashboard_name
}

module "cloudsql_dashboard" {
    source                          = "../../../modules/monitoring/cloudsql"
    project                         = var.project
    cloudsql_dashboard_enable       = var.cloudsql_dashboard_enable
    cloudsql_dashboard_name         = var.cloudsql_dashboard_name
}

module "https_lb_dashboard" {
    source                          = "../../../modules/monitoring/https_lb"
    project                         = var.project
    https_lb_dashboard_enable       = var.https_lb_dashboard_enable
    https_lb_dashboard_name         = var.https_lb_dashboard_name  
}

module "gke_dashboard" {
    source                          = "../../../modules/monitoring/gke"
    project                         = var.project
    gke_dashboard_enable            = var.gke_dashboard_enable
    gke_dashboard_filter            = var.gke_dashboard_filter
    gke_dashboard_name              = var.gke_dashboard_name  
}

module "network_tcp_lb_dashboard" {
    source                           = "../../../modules/monitoring/network_tcp_lb"
    project                          = var.project
    network_tcp_lb_dashboard_enable  = var.network_tcp_lb_dashboard_enable
    network_tcp_lb_dashboard_name    = var.network_tcp_lb_dashboard_name  
}

module "postgres_dashboard" {
    source                           = "../../../modules/monitoring/postgres"
    project                          = var.project
    postgres_dashboard_enable        = var.postgres_dashboard_enable
    postgres_dashboard_name          = var.postgres_dashboard_name
}