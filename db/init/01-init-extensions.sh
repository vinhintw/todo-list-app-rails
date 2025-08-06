#!/bin/bash
set -e

# Enable required PostgreSQL extensions
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Enable pg_trgm extension for text search
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    
    -- Grant all privileges to the user
    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
EOSQL

echo "PostgreSQL database $POSTGRES_DB initialized successfully with required extensions"
