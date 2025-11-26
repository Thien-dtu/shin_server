#!/bin/bash
set -e

# Sử dụng biến môi trường POSTGRES_USER thay vì POSTgres_USER
# Đảm bảo database dùng chung (shared_db) được tạo bởi biến môi trường của container postgres
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE paperless_db;
    CREATE DATABASE nextcloud_db;
    CREATE DATABASE wallabag_db;
    CREATE DATABASE gitea_db;
    GRANT ALL PRIVILEGES ON DATABASE paperless_db TO $POSTGRES_USER;
    -- Xóa các dòng CREATE DATABASE cho gitea, freshrss, wallabag, joplin... nếu có
EOSQL

echo "Databases paperless_db, nextcloud_db, wallabag_db and gitea_db created successfully."

