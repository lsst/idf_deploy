# Frontend GCS Bucket
resource "google_storage_bucket" "web" {
  name                        = "snd-web-${var.environment}"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Backend GCS Bucket
resource "google_storage_bucket" "snd_api" {
  name                        = "snd-api-${var.environment}"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
}

# Public read access
resource "google_storage_bucket_iam_member" "web_public" {
  bucket = google_storage_bucket.web.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "api_public" {
  bucket = google_storage_bucket.api.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Backend buckets with Cloud CDN
resource "google_compute_backend_bucket" "web" {
  name        = "snd-web-origin"
  bucket_name = google_storage_bucket.web.name
  enable_cdn  = true

  cdn_policy {
    cache_mode         = var.web_cdn_policy.cache_mode
    client_ttl         = var.web_cdn_policy.client_ttl
    default_ttl        = var.web_cdn_policy.default_ttl
    max_ttl            = var.web_cdn_policy.max_ttl
    negative_caching   = var.web_cdn_policy.negative_caching
    serve_while_stale  = var.web_cdn_policy.serve_while_stale
    request_coalescing = var.web_cdn_policy.request_coalescing
  }
}

resource "google_compute_backend_bucket" "api" {
  name        = "snd-api-origin"
  bucket_name = google_storage_bucket.api.name
  enable_cdn  = true

  cdn_policy {
    cache_mode         = var.api_cdn_policy.cache_mode
    client_ttl         = var.api_cdn_policy.client_ttl
    default_ttl        = var.api_cdn_policy.default_ttl
    max_ttl            = var.api_cdn_policy.max_ttl
    negative_caching   = var.api_cdn_policy.negative_caching
    serve_while_stale  = var.api_cdn_policy.serve_while_stale
    request_coalescing = var.api_cdn_policy.request_coalescing
  }
}

# Global Static IP
resource "google_compute_global_address" "lb_ip" {
  name = "lb-ip"
}

# URL Maps and Path Based Routing
resource "google_compute_url_map" "snd" {
  name            = "snd-url-map"
  default_service = google_compute_backend_bucket.web.id

  host_rule {
    hosts        = [local.domain]
    path_matcher = "main"
  }

  path_matcher {
    name            = "main"
    default_service = google_compute_backend_bucket.web.id

    path_rule {
      paths   = ["/api", "/api/*"]
      service = google_compute_backend_bucket.api.id
    }
  }
}

# Managed Certificate
resource "google_compute_managed_ssl_certificate" "snd" {
  name = "snd-cert"
  managed {
    domains = [local.domain]
  }
}

# HTTPS target proxy and forwarding rule

resource "google_compute_target_https_proxy" "snd_https" {
  name             = "sdn-https-proxy"
  url_map          = google_compute_url_map.snd.id
  ssl_certificates = [google_compute_managed_ssl_certificate.snd.id]
}

resource "google_compute_global_forwarding_rule" "snd_https" {
  name       = "snd-https-fr"
  target     = google_compute_target_https_proxy.snd_https.id
  port_range = "443"
  ip_address = google_compute_global_address.snd_lb_ip.address
}

# HTTP > HTTPS redirect

resource "google_compute_url_map" "snd_http_redirect" {
  name = "snd-http-redirect"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "snd_http" {
  name    = "snd-http-proxy"
  url_map = google_compute_url_map.snd_http_redirect.id
}

resource "google_compute_global_forwarding_rule" "snd_http" {
  name       = "snd-http-fr"
  target     = google_compute_target_http_proxy.snd_http.id
  port_range = "80"
  ip_address = google_compute_global_address.snd_lb_ip.address
}
