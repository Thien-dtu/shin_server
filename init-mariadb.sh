#!/bin/bash
set -e

# This script is executed within the MariaDB container on startup.
# It creates the specified databases if they do not already exist.

# List of databases to create
DATABASES=(
  
  
)

# Loop through the array and create each database
for db in "${DATABASES[@]}"; do
  mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS `$db` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';"
done

