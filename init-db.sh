#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE paperless_db;
    CREATE DATABASE nextcloud_db;
    CREATE DATABASE ${NPM_DB_NAME:-npm_db};
EOSQL
