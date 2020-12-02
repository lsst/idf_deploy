output "router" {
  value       = module.cloud_router.router
  description = "The created router"
}

output "router_region" {
  value       = module.cloud_router.router.region
  description = "The region of the created router"
}