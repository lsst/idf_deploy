module "group" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.3"

  id           = var.id
  customer_id  = var.customer_id
  display_name = var.display_name
  description  = var.description
  domain       = var.domain
  owners       = var.owners
  managers     = var.managers
  members      = var.members
}