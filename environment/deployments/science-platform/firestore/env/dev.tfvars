# Project
environment                 = "dev"
application_name            = "science-platform"
folder_id                   = "985686879610"
budget_amount               = 1000
budget_alert_spent_percents = [0.7, 0.8, 0.9, 1.0]


# Enable Google Artifact Registry, Service Networking, Container Filesystem,
# and Cloud SQL Admin (required for the Cloud SQL Auth Proxy) in addition to
# our standard APIs.
activate_apis = [
  "stackdriver.googleapis.com",
  "storage.googleapis.com",
  "billingbudgets.googleapis.com",
]

# Increase this number to force Terraform to update the dev environment.
# Serial: 4

