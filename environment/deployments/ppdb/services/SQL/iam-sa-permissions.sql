-- USDF Replication
GRANT USAGE ON SCHEMA ppdb_chunk_tracking TO "usdf-replication@ppdb-int-6c62.iam";
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA ppdb_chunk_tracking TO "usdf-replication@ppdb-int-6c62.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA ppdb_chunk_tracking
GRANT SELECT, INSERT ON TABLES TO "usdf-replication@ppdb-int-6c62.iam";

-- Cloud Run Promote Chunks
GRANT USAGE ON SCHEMA ppdb_chunk_tracking TO "cloudrun-promote-chunks@ppdb-int-6c62.iam";
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA ppdb_chunk_tracking TO "cloudrun-promote-chunks@ppdb-int-6c62.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA ppdb_chunk_tracking
GRANT SELECT, INSERT ON TABLES TO "cloudrun-promote-chunks@ppdb-int-6c62.iam";

-- Cloud Run Track Chunks
GRANT USAGE ON SCHEMA ppdb_chunk_tracking TO "cloudrun-track-chunks@ppdb-int-6c62.iam";
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA ppdb_chunk_tracking TO "cloudrun-track-chunks@ppdb-int-6c62.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA ppdb_chunk_tracking
GRANT SELECT, INSERT ON TABLES TO "cloudrun-track-chunks@ppdb-int-6c62.iam";
