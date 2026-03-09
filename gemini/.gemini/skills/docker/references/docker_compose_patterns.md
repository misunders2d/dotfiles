# Docker Compose Patterns

## General Guidelines
1. **Version**: The `version` attribute is deprecated in newer Compose specifications. It's safe to omit it.
2. **Environment Variables**: Use an `.env` file and reference variables using `${VAR_NAME}`.
3. **Named Volumes**: Use named volumes to persist database or application data.
4. **Networks**: By default, Compose sets up a single network for your app. Define custom networks if you need isolation.
5. **Depends On**: Use `depends_on` to control the startup order of services.

## Example: Full-Stack Application

```yaml
services:
  frontend:
    build: 
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://backend:8000
    depends_on:
      - backend
    networks:
      - app-network

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
    depends_on:
      db:
        condition: service_healthy
    networks:
      - app-network

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=${POSTGRES_USER:-postgres}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-password}
      - POSTGRES_DB=${POSTGRES_DB:-myapp}
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-myapp}"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  pgdata:

networks:
  app-network:
    driver: bridge
```