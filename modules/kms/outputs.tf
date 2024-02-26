output "keyring" {
  description = "Self link of the keyring."
  value = module.kms.keyring
}

output "keyring_name" {
  description = "Name of the keyring."
  value = module.kms.keyring_name
}

output "keyring_resource" {
  description = "Keyring resource."
  value = module.kms.keyring_resource
}

output "keys" {
  description = "Map of key name => key self link."
  value = module.kms.keys
}
