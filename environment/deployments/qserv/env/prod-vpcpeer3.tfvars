application_name = "qserv"
environment      = "prod"
network_name     = "qserv-prod-vpc"

remote_application_name = "science-platform"
remote_environment      = "int"
remote_network_name     = "custom-vpc"

# Increase this number to force Terraform to update the vpc peer.
# Serial: 1