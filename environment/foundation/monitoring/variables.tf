variable "project" {
  type = string
}

variable "compute_dashboard_enable" {
  type = bool
}

variable "compute_dashboard_name" {
  type = string
}

variable "gcs_dashboard_enable" {
  type = bool
}

variable "gcs_dashboard_name" {
  type = string
}

variable "cloudsql_dashboard_enable" {
  type = bool
}

variable "cloudsql_dashboard_name" {
  type = string
}

variable "https_lb_dashboard_enable" {
  type = bool
}

variable "https_lb_dashboard_name" {
  type = string
}

variable "network_tcp_lb_dashboard_enable" {
  type = bool
}

variable "network_tcp_lb_dashboard_name" {
  type = string
}

variable "postgres_dashboard_enable" {
  type = bool
}

variable "postgres_dashboard_name" {
  type = string
}