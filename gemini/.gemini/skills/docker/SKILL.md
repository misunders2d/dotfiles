---
name: docker
description: A comprehensive guide for using Docker, including building images, writing Dockerfiles, managing containers, and writing docker-compose.yml files. Use when you need to containerize applications, manage docker containers, or work with docker-compose.
---

# Docker Skill

This skill provides procedural knowledge and best practices for working with Docker. It helps you containerize applications, manage Docker images and containers, and orchestrate multi-container setups using Docker Compose.

## Core Workflows

### 1. Writing Dockerfiles
When creating a `Dockerfile` for an application, always refer to the best practices guide.
See [references/dockerfile_best_practices.md](references/dockerfile_best_practices.md) for patterns like multi-stage builds, caching, and security (running as non-root).

### 2. Docker Compose
When creating or updating `docker-compose.yml` files for orchestrating multiple containers, refer to the compose patterns.
See [references/docker_compose_patterns.md](references/docker_compose_patterns.md) for network, volume, and service configuration examples.

### 3. Common Docker Commands

#### Build & Run
- Build an image: `docker build -t <image-name>:<tag> .`
- Run a container: `docker run -d -p <host-port>:<container-port> --name <container-name> <image-name>`
- Run with volume: `docker run -v /host/path:/container/path <image-name>`

#### Container Management
- List running containers: `docker ps`
- List all containers: `docker ps -a`
- Stop a container: `docker stop <container-id>`
- Remove a container: `docker rm <container-id>`
- Remove an image: `docker rmi <image-id>`

#### Debugging
- View logs: `docker logs <container-id> -f`
- Execute a command inside a running container: `docker exec -it <container-id> /bin/sh` or `/bin/bash`
- Check container resource usage: `docker stats`

#### System Maintenance
- Remove unused data (containers, networks, images, volumes): `docker system prune -a --volumes`

### Guidelines
- **Always be mindful of security**: Do not run containers as root unless absolutely necessary.
- **Keep images small**: Use Alpine or other minimal base images where applicable.
- **Cache efficiently**: Order `Dockerfile` instructions from least frequently changed (e.g., system dependencies) to most frequently changed (e.g., application source code).
