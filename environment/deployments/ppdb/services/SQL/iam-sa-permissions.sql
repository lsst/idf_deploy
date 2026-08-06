-- USDF Replication
GRANT USAGE ON SCHEMA ppdb_dev TO "usdf-replication@ppdb-dev-5c07.iam";
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA ppdb_dev TO "usdf-replication@ppdb-dev-5c07.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA ppdb_dev
GRANT SELECT, INSERT ON TABLES TO "usdf-replication@ppdb-dev-5c07.iam";

-- Cloud Run Promote Chunks
GRANT USAGE ON SCHEMA ppdb_dev TO "cloudrun-promote-chunks@ppdb-dev-5c07.iam";
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA ppdb_dev TO "cloudrun-promote-chunks@ppdb-dev-5c07.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA ppdb_dev
GRANT SELECT, INSERT ON TABLES TO "cloudrun-promote-chunks@ppdb-dev-5c07.iam";

-- Cloud Run Track Chunks
GRANT USAGE ON SCHEMA ppdb_dev TO "cloudrun-track-chunks@ppdb-dev-5c07.iam";
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA ppdb_dev TO "cloudrun-track-chunks@ppdb-dev-5c07.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA ppdb_dev
GRANT SELECT, INSERT ON TABLES TO "cloudrun-track-chunks@ppdb-dev-5c07.iam";