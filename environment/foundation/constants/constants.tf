locals {
  constants = {
    // Domain Information
    org_id          = "288991023210"
    billing_account = "01122E-72D62B-0B0581"
    domain          = "lsst.cloud"

    // The project label used to identify `owner` on Cloud Control Plane projects
    core_projects_owner = "rubin"

    domains_to_allow = ["lsst.cloud"]

    // Google Workspace / Cloud Identity Google Groups
    groups = {
      org_admins        = "gcp-organization-administrators@lsst.cloud"
      billing_admins    = "gcp-billing-administrators@lsst.cloud"
      network_admins    = "gcp-network-administrators@lsst.cloud"
      security_admins   = "gcp-security-administrators@lsst.cloud"
      org_viewers       = "gcp-organization-viewer@lsst.cloud"
      monitoring_admins = "gcp-monitoring-admins@lsst.cloud"
      monitoring_viewer = "gcp-monitoring-viewer@lsst.cloud"
      cloudsql_admins   = "gcp-cloudsql-admins@lsst.cloud"

      gcp_qserv_administrators            = "gcp-qserv-administrators@lsst.cloud"
      gcp_science_platform_administrators = "gcp-science-platform-administrators@lsst.cloud"
      gcp_processing_administrators       = "gcp-processing-administrators@lsst.cloud"
      gcp_square_administrators           = "gcp-square-administrators@lsst.cloud"
      gcp_epo_administrators              = "gcp-epo-administrators@lsst.cloud"

      gcp_qserv_gke_cluster_admins            = "gcp-qserv-gke-cluster-admins@lsst.cloud"
      gcp_science_platform_gke_cluster_admins = "gcp-science-platform-gke-cluster-admins@lsst.cloud"
      gcp_processing_gke_cluster_admins       = "gcp-processing-gke-cluster-admins@lsst.cloud"
      gcp_square_gke_cluster_admins           = "gcp-square-gke-cluster-admins@lsst.cloud"

      gcp_square_gke_developer           = "gcp-square-gke-developer@lsst.cloud"
      gcp_processing_gke_developer       = "gcp-processing-gke-developer@lsst.cloud"
      gcp_science_platform_gke_developer = "gcp-science-platform-gke-developer@lsst.cloud"
      gcp_qserv_gke_developer            = "gcp-qserv-gke-developer@lsst.cloud"
    }

    // Shared VPC
    default_region = "us-central1"

    //Optional - for development.  Will place all resources under a specific folder instead of org root
    parent_folder = ""

    // Optional bootstrap configurations
    # bootstrap = {
    #   org_project_creators = []
    # }
  }
}