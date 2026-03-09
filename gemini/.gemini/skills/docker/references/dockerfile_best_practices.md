# Dockerfile Best Practices

## General Guidelines

1. **Use Multi-stage Builds**: This minimizes the final image size by separating the build environment from the runtime environment.
2. **Order Matters**: Put commands that change frequently (like `COPY . .`) towards the bottom of the Dockerfile to maximize Docker's layer caching.
3. **Use `.dockerignore`**: Prevent unnecessary files from being sent to the Docker daemon context.
4. **Run as Non-Root User**: For security, create a specific user and switch to it using the `USER` instruction.
5. **Minimize Layers**: Combine `RUN` commands using `&&` to reduce the number of layers in the image.

## Example: Multi-Stage Build for a Node.js App

```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and install dependencies first to leverage caching
COPY package*.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production Runtime
FROM node:18-alpine

WORKDIR /app

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy built assets and dependencies from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Change ownership to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

EXPOSE 3000

CMD ["npm", "start"]
```

## Example: Python (FastAPI/Flask)

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Prevent Python from writing pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies if required
# RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser && chown -R appuser /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```