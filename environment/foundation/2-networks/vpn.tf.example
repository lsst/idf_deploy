module "vpn_ha" {
    source = "./modules/ha_vpn"

    project_id = local.prod_host_project_id
    network = var.network_name
    name = "mynet-to-onprem"
}