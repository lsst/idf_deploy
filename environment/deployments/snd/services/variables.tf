variable "state_bucket" {
  type        = string
  description = "The GCS bucket name for terraform state"
}

variable "application_name" {
  description = "The name of application where GCP resources relate"
  type        = string
}

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "region" {
  description = "The GCP region to run resources"
  type        = string
  default     = "us-central1"
}

variable "snd_hostname" {
  description = "SND hostname"
  type        = string
}

# Buckets

variable "snd_web_bucket_force_destroy" {
  description = "Whether it is allowed for Terraform to destroy the bucket"
  type        = bool
  default     = false
}

variable "snd_api_bucket_force_destroy" {
  description = "Whether it is allowed for Terraform to destroy the bucket"
  type        = bool
  default     = false
}


# CDN Policies

variable "web_cdn_policy" {
  description = "Cloud CDN policy for the web (frontend) backend bucket"
  type = object({
    cache_mode         = string
    client_ttl         = number
    default_ttl        = number
    max_ttl            = number
    negative_caching   = bool
    serve_while_stale  = number
    request_coalescing = bool
  })
  default = {
    cache_mode         = "CACHE_ALL_STATIC"
    client_ttl         = 3600
    default_ttl        = 3600
    max_ttl            = 86400
    negative_caching   = true
    serve_while_stale  = 86400
    request_coalescing = true
  }
}

variable "api_cdn_policy" {
  description = "Cloud CDN policy for the api (backend) backend bucket"
  type = object({
    cache_mode         = string
    client_ttl         = number
    default_ttl        = number
    max_ttl            = number
    negative_caching   = bool
    serve_while_stale  = number
    request_coalescing = bool
  })
  default = {
    cache_mode         = "CACHE_ALL_STATIC"
    client_ttl         = 300
    default_ttl        = 300
    max_ttl            = 3600
    negative_caching   = true
    serve_while_stale  = 3600
    request_coalescing = true
  }
}
