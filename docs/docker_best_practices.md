# Docker Best Practices

This document is based on the [best practices docker docs](https://docs.docker.com/build/building/best-practices/) for creating and managing Docker containers. These guidelines would help us in the creation or handling of efficient, secure, and maintainable Docker images.

## 1. Use of Multi-Stage Builds

The multi-stage builds help reduce the size of the final image by creating a clear separation between the image building process and the final output. By splitting the Dockerfile instructions into distinct stages, we ensure that the resulting output contains only the files necessary to run the application.

📌 hadolint Check
We can use hadolint to check the multi-stage builds in the Dockerfile. Hadolint is a Dockerfile linter that checks for best practices, common mistakes, and errors in Docker files.

```bash
hadolint Dockerfile
```

## 2. Create Reusable Stages

If you have several images sharing common elements, consider creating a reusable stage that contains these shared components, and base your unique stages on that. Docker will only need to build the common stage once.

Here is a GPT Example based on the code:
```Dockerfile
# --- TL;DR ---
# This file is staging the application for development and production, the base stage is designed and it is reusable,
# the common setups steps are shared with development and production stages.


# Base stage for building the application
FROM python:3.13-slim AS base
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc=12.2.0 \
    curl=7.88.1 \
    && rm -rf /var/lib/apt/lists/*

# Set the shell to bash with pipefail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add poetry to PATH
ENV PATH="/root/.local/bin:$PATH"

# Copy poetry files
COPY pyproject.toml poetry.lock ./

# Configure poetry to not create virtual environment
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Development stage
FROM base AS dev
COPY . .
EXPOSE 8000
CMD ["poetry", "run", "uvicorn", "koda.domains.tracking.live.server.__main__:app", "--host", "0.0.0.0", "--port", "8000"]

# Production stage
FROM base AS prod
COPY . .
RUN poetry install --no-dev --no-interaction --no-ansi
EXPOSE 8000
CMD ["poetry", "run", "uvicorn", "domains.tracking.live.server.__main__:app", "--host", "0.0.0.0", "--port", "8000"]

```


## 3. Choose the Right Base Image

Use minimal and trusted / verified base images. Smaller base images offer portability, fast downloads, and minimize the number of vulnerabilities introduced through dependencies.

Example:
```Dockerfile
# Evaluate if the base image may work successfully using shorter versions
FROM python:3.13-slim

```

🔍 Grype Security Check

Grype is a vulnerability scanner for container images. It can be used to scan Docker images for vulnerabilities.

```bash
grype <image-name>
```


## 4. Rebuild Images Often

Docker images are immutable. To keep your images up-to-date and secure, rebuild your image often with updated dependencies. Use the --no-cache option to avoid cache hits.

Example:
```bash
docker build --no-cache -t my-image:my-tag .
```

## 5. Exclude Unnecessary Files

A .dockerignore file excludes irrelevant files to the build structure, without restructuring your source repository.

Example:
```plaintext
# .dockerignore
*.md
node_modules
dist
```

📊 Dive Optimization

Dive is a tool for exploring a Docker image, layer contents, and discovering ways to shrink the image size.

```bash
dive <image-name>
```

## 6. Create Ephemeral Containers

Ensure that your containers are stateless and can be easily replaced without manual intervention. This means that the container can be stopped and destroyed, then rebuilt and replaced with minimal setup and configuration.

## 7. Avoid Installing Unnecessary Packages

Only install the packages that are required for your application to run. Avoid installing extra or unnecessary packages just because they might be nice to have.

Example:
```Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc=12.2.0 \
    curl=7.88.1 \
    && rm -rf /var/lib/apt/lists/*
```

## 8. Decouple Applications

Use separate containers for different concerns (e.g., web server, database, cache) to improve scalability and maintainability.

Example:
```yaml
version: '3.8'

services:
  web:
    image: my-web-app
    ports:
 - "80:80"
  db:
    image: postgres:13
    environment:
 - POSTGRES_USER=user
 - POSTGRES_PASSWORD=password
```

## 9. Sort Multi-Line Arguments

Sort multi-line arguments alphanumerically to make maintenance easier. This helps to avoid duplication of packages and makes the list much easier to update.

## 10. Leverage Build Cache

Understand how Docker's build cache works and optimize your Dockerfile to take advantage of it. Combine RUN instructions and clean up after package installations to reduce the image size.

Example:
```Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    bzr \
    cvs \
    git \
    mercurial \
    subversion \
    && rm -rf /var/lib/apt/lists/*
```

## 11. Pin Base Image Versions

Pin base image versions to specific digests to ensure reproducibility and avoid unexpected changes.

Example:
```Dockerfile
FROM python:3.13-slim@sha256:<digest>
```

## 12. Use Labels

Add labels to your images to provide metadata such as version, maintainer, and other relevant information.

Example:
```Dockerfile
LABEL maintainer="koda"
LABEL version="1.0.0"
LABEL description="Production image for the application"
```

## 13. Optimize RUN Instructions

Combine RUN instructions and clean up after package installations to reduce the image size.

Example:
```Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc=12.2.0 \
    curl=7.88.1 \
    && rm -rf /var/lib/apt/lists/*
```

## 14. Use ENTRYPOINT and CMD Appropriately

Use ENTRYPOINT to define the main command for the container and CMD for default arguments.

Example:
```Dockerfile
ENTRYPOINT ["poetry", "run"]
CMD ["uvicorn", "koda.domains.tracking.live.server.__main__:app", "--host", "0.0.0.0", "--port", "8000"]
```

## 15. Use VOLUME for Persistent Data

Use the VOLUME instruction to define mount points for persistent data.

Example:
```Dockerfile
VOLUME /data
```

## 16. Use Non-Root User

Use the USER instruction to run your application as a non-root user for better security.

Example:
```Dockerfile
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser
```

## 17. Use Absolute Paths for WORKDIR

Always use absolute paths for the WORKDIR instruction to avoid confusion.

Example:
```Dockerfile
WORKDIR /app
```
