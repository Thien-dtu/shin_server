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

The `selfhost` project leverages **Docker Compose** to orchestrate a suite of self-hosted services. These services, defined in the `docker-compose.yml` file, encompass a range of functionalities including file storage, password management, and personal data management.

### Traffic Flow Architecture

The traffic flow is designed for maximum security and simplified internal management:

1.  **User's Browser** connects to a service via a secure HTTPS domain (e.g., `https://homepage.buiducthen.store`).
2.  **Cloudflare** receives the HTTPS request, handles TLS termination, and applies security policies.
3.  **Cloudflare Tunnel (`cloudflared`)** receives the traffic from Cloudflare's network and forwards it securely into the internal Docker network as a plain HTTP request.
4.  **Caddy** receives the HTTP request from the tunnel. It acts as an internal reverse proxy, reading the host header to route the request to the correct backend service (e.g., `http://homepage:3000`).
5.  The **Backend Service** (e.g., Homepage, Nextcloud) processes the request and sends the response back through the same path.

This architecture offloads all complex SSL/TLS management to Cloudflare, allowing the internal services to communicate exclusively over simple, unencrypted HTTP.

### Key Technologies

* **Docker Compose:** The foundational tool for orchestrating all services.
* **Caddy:** An efficient and easy-to-configure reverse proxy, operating in an **HTTP-only** mode.
* **Portainer:** A web UI for managing Docker environments (running independently).
* **PostgreSQL:** The primary database system utilized by various services.
* **Redis:** Employed for caching by applications such as Paperless and Nextcloud.
* **Cloudflared:** Provides a secure tunnel to expose services safely without opening any ports on the host firewall.
* **Watchtower:** For automatic updates of Docker images.

---

## Services Overview (Current)

This project currently includes the following core services:

* **Caddy:** Handles internal HTTP reverse proxying for all services.
* **PostgreSQL:** Main database server.
* **Immich PostgreSQL:** Dedicated database for Immich.
* **Redis:** In-memory data store for caching.
* **Paperless-ngx:** A document management system.
* **Nextcloud:** A suite of client-server software for creating and using file hosting services.
* **Immich:** A self-hosted photo and video backup solution.
* **Vaultwarden:** An alternative Bitwarden server implementation.
* **Cloudflared:** A tunneling service to expose services to the internet securely.
* **Homepage:** A modern, fully static, fast, secure, and highly customizable application dashboard.
* **File Browser:** A web-based file manager.
* **Watchtower:** A process for automating Docker container base image updates.
* **Portainer:** (Managed via `docker-compose.portainer.yml`) A lightweight management UI for Docker.

---

## Project Structure

* `docker-compose.yml`: The primary Docker Compose file, detailing core services managed via Portainer Stacks.
* `Caddyfile`: The configuration file for the Caddy reverse proxy.
* `data/`: This directory houses all persistent data for every service, with each service having its dedicated subdirectory.
* `media/`: Contains media files, primarily for Paperless after media service removal.
* `init-db.sh`: A script executed upon PostgreSQL startup to facilitate database creation.
* `.env`: Contains all environment variables and secrets.
* `GEMINI.md`: This project guideline document.

---

## Coding Style & Conventions

### Docker Compose

When adding or modifying services in `docker-compose.yml` (via Portainer Stacks):

* Explicitly define `container_name`.
* Set `restart: unless-stopped` for service resilience.
* Assign the service to the `selfnet` network.
* Specify resource limits under `deploy.resources.limits` for efficient resource allocation.
* Include a `healthcheck` where appropriate to monitor service status.

### Shell Scripts

All shell scripts should be written in **Bash** and incorporate `set -e` to ensure the script exits immediately upon encountering an error.

---

## Workflow for Managing Services & Project Evolution (Using Portainer)

### How to Manage Services

All core services (except Portainer itself) are managed via Portainer Stacks:

1.  **Access Portainer:** Open `http://<server_IP>:9000` or `https://<server_IP>:9443` in your browser.
2.  **Navigate to Stacks:** Select your environment, then go to **Stacks**.
3.  **Manage the Main Stack (`selfhost-main`):**
    * **Edit Services:** Click on the stack, go to the **Editor** tab to modify the `docker-compose.yml` content. Add/remove/update services here. Remember to also update the **Environment variables** section if needed. Click **"Update the stack"** to apply changes.
    * **Stop/Start/Restart Services:** Go to **Containers**, find the container, and use the controls.
    * **View Logs:** Go to **Containers**, click on the container name, then click the **Logs** icon.
4.  **Manage Portainer itself:** Use the separate compose file via SSH:
    * `cd /path/to/selfhost`
    * `docker compose -f docker-compose.portainer.yml down/up -d/restart`

### Workflow for Adding New Services (Using Portainer)

1.  **Define the service in `docker-compose.yml` via Portainer Stack Editor:**
    * Map data volumes to `data/[service_name]/`.
2.  **Prepare database (if required):**
    * SSH into the server, edit `init-db.sh`, add the `CREATE DATABASE` command. Run `docker compose exec postgres psql -U admin -d shared_db -f /docker-entrypoint-initdb.d/init-db.sh` or restart the `postgres` container if it's the first time.
3.  **Add Caddy configuration:** Edit the `Caddyfile` (via Portainer Stack Editor or SSH) to add the new HTTP reverse proxy block. Restart the `caddy` container.
4.  **Add Public Hostname on Cloudflare Tunnel:**
    * In the Cloudflare Zero Trust dashboard, create a new public hostname.
    * Set the service **Type** to `HTTP` and the **URL** to `caddy:80`.
5.  **Test the new service:** Access the new Cloudflare domain.

---

## Important Considerations

* **Security:** Keep Portainer access restricted to your local network or via VPN. Use strong passwords. Regularly update images.
* **File Browser Persistence:** Ensure the `filebrowser` service volumes are correctly mapped to `/database` and `/config` inside the container to guarantee user data persistence across restarts.
* **Documentation:** Keep this `GEMINI.md` file updated with any significant changes or additions to the project.

---

## Host System Specifications

### CPU

* **Model:** Intel(R) Core(TM) i5-4300M @ 2.60GHz
* **Cores:** 2
* **Threads:** 4

### Memory (RAM)

* **Total:** 3.5Gi
* **Swap:** 3.5Gi

### Disk Storage

* **Primary Partition (`/`):** 115G
