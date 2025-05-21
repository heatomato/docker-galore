# Want to create a docker image for the consumer service
# This is the Dockerfile for the consumer service
# The consumer service is a python service that listens to the kafka topic and processes the messages


# Use the official Python image
FROM python:3.13-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Modify this based on your actual project structure
ENV PYTHONPATH="/app/domains/tracking/live/consumer/src:/app/domains/tracking/live/consumer:/domains/tracking/live/consumer"


# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
ENV POETRY_VERSION=1.4.0
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Set the working directory in the container
WORKDIR /app
#WORKDIR /app/domains/tracking/live/consumer/src

# Copy Poetry configuration files
COPY pyproject.toml poetry.lock  ./

# Debugging Step: List the files in the current directory
RUN echo "$(ls -la)"

# Check for valid poetry file
RUN poetry check

# Configure Poetry to not create virtual environments
#RUN poetry config virtualenvs.create false
# Install dependencies using
RUN poetry install --no-dev --no-interaction --no-ansi

# Copy the consumer service code into the container
COPY domains/tracking/live/consumer domains/tracking/live/consumer


#RUN cat /app/pyproject.toml
#RUN cat /app/poetry.lock

# Run the consumer service
CMD ["poetry", "run", "python", "-m", "domains.tracking.live.consumer.src.main"]

