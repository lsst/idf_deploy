output "load_balancer_ip" {
  value = google_compute_global_address.lb_ip.address
}