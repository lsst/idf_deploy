# Project
environment = "stable"
project_id  = "science-platform-stable-6994"

# In production, keep all alert data.
purge_old_alerts = false

writer_k8s_namespace           = "alert-stream-broker"
writer_k8s_serviceaccount_name = "alert-database-writer"
reader_k8s_namespace           = "alert-stream-broker"
reader_k8s_serviceaccount_name = "alert-database-reader"

# Increase this number to force Terraform to update the int environment.
# Serial: 2
