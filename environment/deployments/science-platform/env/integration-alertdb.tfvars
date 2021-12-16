# Project
environment = "int"
project_id  = "science-platform-int-dc5d"

# In integration, only keep 4 weeks of simulated alert data.
purge_old_alerts  = true
maximum_alert_age = 28

writer_k8s_namespace           = "alert-stream-broker"
writer_k8s_serviceaccount_name = "alert-database-writer"
reader_k8s_namespace           = "alert-stream-broker"
reader_k8s_serviceaccount_name = "alert-database-reader"

# Increase this number to force Terraform to update the int environment.
# Serial: 2
