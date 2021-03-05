project_id     = "panda-dev-1a74"
network        = "panda-dev-vpc"
db_name        = "butler-registry-dev"
tier           = "db-custom-4-26624"
database_flags = [
  {name = "temp_file_limit", value = 214748362},
  {name = "max_connections", value = 3000}
]
