output "gateway_name" {
  description = "VPN gateway name."
  value       = module.vpn_ha.name
}

output "tunnel_names" {
  description = "VPN tunnel names."
  value       = module.vpn_ha.tunnel_names
}

output "tunnel_self_links" {
  description = "VPN tunnel self links."
  value       = module.vpn_ha.tunnel_self_links
}

output "tunnels" {
  description = "VPN tunnel resources."
  value       = module.vpn_ha.tunnels
}