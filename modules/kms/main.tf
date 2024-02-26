module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = ">= 2.0"

  project_id                     = var.project_id
  location                       = var.location
  keyring                        = var.keyring
  keys                           = var.keys
  set_decrypters_for             = var.set_decrypters_for
  set_encrypters_for             = var.set_encrypters_for
  set_owners_for                 = var.set_owners_for
  decrypters                     = var.decrypters
  encrypters                     = var.encrypters
  owners                         = var.owners
  labels                         = var.labels
  key_algorithm                  = var.key_algorithm
  key_destroy_scheduled_duration = var.key_destroy_scheduled_duration
  key_protection_level           = var.key_protection_level
  key_rotation_period            = var.key_rotation_period
  prevent_destroy                = var.prevent_destroy
  purpose                        = var.purpose
}
