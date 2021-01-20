// Folder Variables
parent_folder                = ""

sub_folder_names = [
  "Dev",
  "Integration",
  "Production"
]

// Shared Services

shared_services_display_name = "Shared Services"

gcp_org_administrators_shared_service_iam_permissions = [
  "roles/storage.admin"
]

// Processing

processing_display_name      = "Processing"

gcp_processing_administrators_iam_permissions = [        
  "roles/resourcemanager.projectCreator",
  "roles/container.admin",
  "roles/editor"
]
gcp_processing_gke_cluster_admins_iam_permissions = [    
  "roles/container.admin",
  "roles/container.clusterAdmin",
  "roles/logging.admin",
  "roles/resourcemanager.projectCreator",
  "roles/monitoring.admin",
  "roles/storage.admin",
  "roles/compute.instanceAdmin",
  "roles/logging.admin",
  "roles/file.editor",
  "roles/compute.networkAdmin",
  "roles/compute.securityAdmin"
]
gcp_processing_gke_developer_iam_permissions = [
  "roles/container.clusterViewer",
  "roles/container.viewer",
  "roles/container.developer",
  "roles/logging.viewer",
  "roles/monitoring.editor",
  "roles/storage.objectViewer"
]

// QServ IAM Roles

qserv_display_name           = "QServ"

gcp_qserv_administrators_iam_permissions = [
  "roles/resourcemanager.projectCreator",
  "roles/container.admin",
  "roles/editor"
]
gcp_qserv_gke_cluster_admins_iam_permissions = [
  "roles/container.admin",
  "roles/container.clusterAdmin",
  "roles/logging.admin",
  "roles/resourcemanager.projectCreator",
  "roles/monitoring.admin",
  "roles/storage.admin",
  "roles/compute.instanceAdmin",
  "roles/logging.admin",
  "roles/file.editor",
  "roles/compute.networkAdmin",
  "roles/compute.securityAdmin"
]
gcp_qserv_gke_developer_iam_permissions = [
  "roles/container.clusterViewer",
  "roles/container.viewer",
  "roles/container.developer",
  "roles/logging.viewer",
  "roles/monitoring.editor",
  "roles/storage.objectViewer"
]

// Science Platform IAM Roles

splatform_display_name       = "Science Platform"

gcp_science_platform_administrators_iam_permissions = [
  "roles/resourcemanager.projectCreator",
  "roles/container.admin",
  "roles/editor"
]
gcp_science_platform_gke_cluster_admins_iam_permissions = [
  "roles/container.admin",
  "roles/container.clusterAdmin",
  "roles/logging.admin",
  "roles/resourcemanager.projectCreator",
  "roles/monitoring.admin",
  "roles/storage.admin",
  "roles/compute.instanceAdmin",
  "roles/logging.admin",
  "roles/file.editor",
  "roles/compute.networkAdmin",
  "roles/compute.securityAdmin"
]
gcp_science_platform_gke_developer_iam_permissions = [
  "roles/container.clusterViewer",
  "roles/container.viewer",
  "roles/container.developer",
  "roles/logging.viewer",
  "roles/monitoring.editor",
  "roles/storage.objectViewer"
]

// SQaRE

square_display_name          = "SQuaRE"

gcp_square_administrators_iam_permissions = [
  "roles/resourcemanager.projectCreator",
  "roles/container.admin",
  "roles/editor"
]
gcp_square_gke_cluster_admins_iam_permissions = [
  "roles/container.admin",
  "roles/container.clusterAdmin",
  "roles/logging.admin",
  "roles/resourcemanager.projectCreator",
  "roles/monitoring.admin",
  "roles/storage.admin",
  "roles/compute.instanceAdmin",
  "roles/logging.admin",
  "roles/file.editor",
  "roles/compute.networkAdmin",
  "roles/compute.securityAdmin"
]
gcp_square_gke_developer_iam_permissions = [
  "roles/container.clusterViewer",
  "roles/container.viewer",
  "roles/container.developer",
  "roles/logging.viewer",
  "roles/monitoring.editor",
  "roles/storage.objectViewer"
]