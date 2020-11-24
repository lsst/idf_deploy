// Build Sub Folders for QServ
module "sub_folders_qserv" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = data.google_active_folder.qserv_sub_folder.name
  names  = var.sub_folder_names
}

// Build Sub Folders for Science Platform
module "sub_folders_science_platform" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = data.google_active_folder.splatform_sub_folder.name
  names  = var.sub_folder_names
}

// Build Sub Folders for Processing
module "sub_folders_processing" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = data.google_active_folder.processing_sub_folder.name
  names  = var.sub_folder_names
}

// Build Sub Folders for Square
module "sub_folders_square" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = data.google_active_folder.square_sub_folder.name
  names  = var.sub_folder_names
}