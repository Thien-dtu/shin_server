#!/bin/bash
set -e

# Sử dụng biến môi trường POSTGRES_USER thay vì POSTgres_USER
# Đảm bảo database dùng chung (shared_db) được tạo bởi biến môi trường của container postgres
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE paperless_db;
    CREATE DATABASE nextcloud_db;
    -- Xóa các dòng CREATE DATABASE cho gitea, freshrss, wallabag, joplin... nếu có
EOSQL

echo "Databases paperless_db and nextcloud_db created successfully."

