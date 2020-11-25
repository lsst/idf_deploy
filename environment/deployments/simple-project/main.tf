module "science_platform_qa_project" {
  source           = "../../../modules/project_iam_vpc"
  org_id           = var.org_id
  folder_id        = var.folder_id
  billing_account  = var.billing_account
  project_prefix   = var.project_prefix
  cost_centre      = var.cost_centre
  application_name = var.application_name
  environment      = var.environment
  group_name       = var.group_name
}

# module "gke" {
#   source = "../../../modules/gke"

#   cluster_name_suffix            = "splatform"   
#   #compute_engine_service_account = "" 
#   enable_binary_authorization    = false
#   ip_range_pods                  = ""   
#   ip_range_services              = ""   
#   network                        = module.science_platform_qa_project.network
#   project_id                     = module.science_platform_qa_project.project_id  
#   region                         = "us-central1"
#   skip_provisioners              = false
#   subnetwork                     = module.science_platform_qa_project.subnets_self_links
# }