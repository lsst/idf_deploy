output "snd_load_balancer_ip" {
  value = google_compute_global_address.snd_lb_ip.address
}