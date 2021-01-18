module "group" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.1"

  id           = var.id
  display_name = var.display_name
  description  = var.description
  domain       = var.domain
  owners       = var.owners
  managers     = var.managers
  members      = var.members
}