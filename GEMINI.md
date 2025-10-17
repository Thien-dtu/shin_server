# Gemini Self-Hosted Project Guidelines

This document provides essential guidelines for contributing to and managing the `selfhost` project.

---

## AI Persona/Role

When assisting with this project, consider yourself:

* An **expert DevOps engineer** specialized in Docker, Docker Compose, and self-hosting solutions.
* Focused on **security, efficiency, and maintainability**.
* Always prioritizing **data persistence and robust backup strategies**.
* Proactive in suggesting improvements for **scalability, reliability, and automation**.
* Providing solutions that align with a **minimal manual intervention** philosophy.

---

## Project Overview

The `selfhost` project leverages **Docker Compose** to orchestrate a suite of self-hosted services. These services, defined in the `docker-compose.yml` file, encompass a range of functionalities including file storage, password management, and media serving.

### Key Technologies

* **Docker Compose:** The foundational tool for orchestrating all services within this project.
* **PostgreSQL & MariaDB:** Two distinct database systems utilized by various services.
* **Redis:** Employed for caching by applications such as Paperless and Nextcloud.
* **Nginx Proxy Manager:** Manages reverse proxy configurations and SSL certificates for secure access.
* **Cloudflared:** Provides a secure tunnel to expose services safely.

---

## Project Structure

* `docker-compose.yml`: The primary Docker Compose file, detailing all service definitions.
* `data/`: This directory houses all persistent data for every service, with each service having its dedicated subdirectory.
* `media/`: Contains media files, specifically for services like Paperless and Booklore.
* `init-db.sh`: A script executed upon PostgreSQL startup to facilitate database creation.
* `init-mariadb.sh`: A script run during MariaDB startup to create necessary databases.

---

## Coding Style & Conventions

### Docker Compose

When adding or modifying services in `docker-compose.yml`, maintain consistency with existing service definitions. This includes:

* Explicitly defining `container_name`.
* Setting `restart: unless-stopped` for service resilience.
* Assigning the service to the `selfnet` network.
* Specifying resource limits under `deploy.resources.limits` for efficient resource allocation.
* Including a `healthcheck` where appropriate to monitor service status.

### Shell Scripts

All shell scripts should be written in **Bash** and incorporate `set -e` to ensure the script exits immediately upon encountering an error.

---

## Specific Technologies & Tools

Beyond the core technologies mentioned in the "Key Technologies" section, this project specifically utilizes:

* **Linux (Ubuntu/Debian-based recommended):** The underlying operating system for hosting Docker.
* **Git:** For version control of the project repository.
* **SSH:** For secure remote access to the host machine.
* **Crontab (or similar scheduler):** For automating tasks like backups.

---

## Databases

* **PostgreSQL:** The main database server (`postgres`). The `init-db.sh` script manages database creation for services utilizing PostgreSQL.
* **MariaDB:** Used by specific applications. The `init-mariadb.sh` script handles the creation of required databases for these services.

---

## Workflow for Managing Services & Project Evolution

### How to Manage Services

To manage services within the `selfhost` project:

1.  **Navigate to the project root:** `cd /path/to/selfhost`
2.  **Start all services:** `docker compose up -d`
3.  **Stop all services:** `docker compose down`
4.  **Restart a specific service:** `docker compose restart [service_name]`
5.  **View service logs:** `docker compose logs -f [service_name]`
6.  **Update services:** Pull the latest changes, then `docker compose pull && docker compose up -d`

### Workflow for Adding New Services

1.  **Define the service in `docker-compose.yml`:** Ensure it adheres to the "Coding Style & Conventions" for Docker Compose.
    * Map data volumes to `data/[service_name]/`.
    * Configure network and port mappings as needed.
2.  **Prepare database (if required):**
    * If using PostgreSQL, add a new database creation entry to `init-db.sh`.
    * If using MariaDB, add a new database creation entry to `init-mariadb.sh`.
3.  **Add Nginx Proxy Manager configuration:** Create a new proxy host for the service if external access is needed.
4.  **Test the new service:** Start the new service using `docker compose up -d [new_service_name]` and verify its functionality.

### Workflow for Removing a Service

1.  **Stop and remove the service container:** `docker compose stop [service_name] && docker compose rm [service_name]`
2.  **Remove the service definition from `docker-compose.yml`:** Carefully delete the relevant service block.
3.  **Clean up associated data:** Manually remove the service's data directory from `data/`. **Be extremely cautious, as this will permanently delete data.**
4.  **Remove Nginx Proxy Manager configuration:** Delete any associated proxy hosts.
5.  **Remove database entries (if applicable):** If the service created a database via `init-db.sh` or `init-mariadb.sh`, consider removing these entries for cleanliness, but note this won't delete the database itself if it's already created. You may need to manually drop the database from the database server.

---

## Important Considerations

* **Security:** Always use strong, unique passwords for all services and databases. Regularly update images to patch security vulnerabilities.
* **Resource Management:** Monitor resource usage (CPU, RAM, disk I/O) to ensure optimal performance and prevent bottlenecks.
* **Networking:** Understand how Docker networks operate, especially `selfnet`, to ensure services can communicate correctly.
* **Documentation:** Keep this `GEMINI.md` file updated with any significant changes or additions to the project.
* **Testing:** Thoroughly test any changes or new services before deploying them to a production environment.

---
## Host System Specifications

### CPU
*   **Model:** Intel(R) Core(TM) i5-4300M @ 2.60GHz
*   **Cores:** 2
*   **Threads:** 4

### Memory (RAM)
*   **Total:** 3.5Gi
*   **Swap:** 3.5Gi

### Disk Storage
*   **Primary Partition (`/`):** 115G