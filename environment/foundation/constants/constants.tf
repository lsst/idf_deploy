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
      org_admins      = "gcp-organization-administrators@lsst.cloud"
      billing_admins  = "gcp-billing-administrators@lsst.cloud"
      network_admins  = "gcp-network-administrators@lsst.cloud"
      security_admins = "gcp-security-administrators@lsst.cloud"
      org_viewers     = "gcp-organization-viewer@lsst.cloud"

      gcp_qserv_administrators            = "gcp-qserv-administrators@lsst.cloud"
      gcp_science_platform_administrators = "gcp-science-platform-administrators@lsst.cloud"
      gcp_processing_administrators       = "gcp-processing-administrators@lsst.cloud"
      gcp_square_administrators           = "gcp-square-administrators@lsst.cloud"

      gcp_qserv_clustername_admins            = "gcp-qserv-clustername-admins@lsst.cloud"
      gcp_science_platform_clustername_admins = "gcp-science-platform-clustername-admins@lsst.cloud"
      gcp_processing_clustername_admins       = "gcp-processing-clustername-admins@lsst.cloud"
      gcp_square_clutername_admins            = "gcp-square-clutername-admins@lsst.cloud"

      gcp_square_clustername_developer           = "gcp-square-clustername-developer@lsst.cloud"
      gcp_processing_clustername_developer       = "gcp-processing-clustername-developer@lsst.cloud"
      gcp_science_platform_clustername_developer = "gcp-science-platform-clustername-developer@lsst.cloud"
      gcp_qserv_clustername_developer            = "gcp-qserv-clustername-developer@lsst.cloud"
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