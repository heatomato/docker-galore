#!/bin/bash

# Stop all running containers
docker stop $(docker ps -a -q)

# Remove all containers
docker rm $(docker ps -a -q)

# Remove all images
docker rmi $(docker images -q)

# Remove all volumes
docker volume rm $(docker volume ls -q)

# Remove all networks
docker network rm $(docker network ls -q)

# Remove all dangling images
docker rmi $(docker images -f "dangling=true" -q)

# Remove all dangling volumes
docker volume rm $(docker volume ls -f "dangling=true" -q)

# Remove all dangling networks
docker network rm $(docker network ls -f "dangling=true" -q)

# Remove all dangling containers
docker rm $(docker ps -a -f "status=exited" -q)

# Remove all dangling images
docker rmi $(docker images -f "dangling=true" -q)

