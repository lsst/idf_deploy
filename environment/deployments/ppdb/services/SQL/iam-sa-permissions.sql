-- USDF Replication
GRANT USAGE ON SCHEMA chunk_tracking TO "usdf-replication@ppdb-dev-5c07.iam";
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA chunk_tracking TO "usdf-replication@ppdb-dev-5c07.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA chunk_tracking
GRANT SELECT, INSERT ON TABLES TO "usdf-replication@ppdb-dev-5c07.iam";

-- Cloud Run Promote Chunks
GRANT USAGE ON SCHEMA chunk_tracking TO "cloudrun-promote-chunks@ppdb-dev-5c07.iam";
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA chunk_tracking TO "cloudrun-promote-chunks@ppdb-dev-5c07.iam";
ALTER DEFAULT PRIVILEGES IN SCHEMA chunk_tracking
GRANT SELECT, INSERT ON TABLES TO "cloudrun-promote-chunks@ppdb-dev-5c07.iam";

-- Cloud Run Stage Chunk
GRANT USAGE ON SCHEMA chunk_tracking TO "cloudrun-stage-chunk@ppdb-dev-5c07.iam";
GRANT SELECT, UPDATE ON ALL TABLES IN SCHEMA chunk_tracking TO "cloudrun-stage-chunk@ppdb-dev-5c07.iam";
