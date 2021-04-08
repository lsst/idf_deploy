# Project
environment      = "int"
application_name = "science-platform"
project_id       = "science-platform-int-dc5d"

# Butler database
butler_db_name = "butler-registry-int"
butler_database_flags = [
  {name = "temp_file_limit", value = 1049000000},
]

# General database
db_maintenance_window_day  = 2
db_maintenance_window_hour = 22
