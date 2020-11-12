locals {
  constants = {
    // Domain Information
    org_id          = "0123456789"
    billing_account = "000000-000000-000000"
    domain          = "example.com"
    
    // The project label used to identify `owner` on Cloud Control Plane projects
    core_projects_owner = "centralit"

    domains_to_allow = ["example.com"]

    // Google Workspace / Cloud Identity Google Groups
    groups = {
      org_admins     = "gcp_organization_admins@example.com"
      billing_admins = "gcp_billing_admins@example.com"
      network_admins = "gcp_network_admins@example.com"
      security_admins = "gcp_security_admins@example.com"
      org_viewers = "gcp_org_viewer@example.com"
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