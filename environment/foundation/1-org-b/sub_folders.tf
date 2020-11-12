module "sub_folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 2.0"

  parent = data.google_active_folder.sub_folder1.name
  names  = var.sub_folder_names
}