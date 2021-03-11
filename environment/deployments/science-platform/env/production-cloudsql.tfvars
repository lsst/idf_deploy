project_id  = "science-platform-stable-6994"
db_name     = "butler-registry"
tier        = "db-custom-2-13312"
require_ssl = false
database_flags = [
  {name = "temp_file_limit", value = 2147483647},
  {name = "password_encryption", value = "scram-sha-256"}
]
