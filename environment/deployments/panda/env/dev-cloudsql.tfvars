project_id     = "panda-dev-1a74"
network        = "panda-dev-vpc"
db_name        = "butler-registry-dev"
tier           = "db-custom-8-53248"
require_ssl    = false
database_flags = [
  {name = "temp_file_limit", value = 2147483647},
  {name = "max_connections", value = 3000},
  {name = "work_mem", value = 2000000},
  {name = "maintenance_work_mem", value = 1000000 },
  {name = "effective_cache_size", value = 3250000 },
  {name = "password_encryption", value = "scram-sha-256"}
]
backups_enabled = true
db_name_2      = "panda-idds-dev"


// DATABASE INSIGHTS
insights_config = ({
    query_string_length     = 1024
    record_application_tags = false
    record_client_address   = true
  })

  #