#!/bin/bash

# Define the project name
PROJECT_NAME="multidisciplinary_project_group4"

# Stop and remove all running containers related to the project
docker compose down

# Remove the Docker image for the init-setup service
docker rmi ${PROJECT_NAME}-init-setup

# Remove all stopped containers related to the project
docker ps -a --filter "name=${PROJECT_NAME}" --format "{{.ID}}" | xargs -r docker rm

# Remove all unused images related to the project
docker images --filter "reference=${PROJECT_NAME}*" --format "{{.ID}}" | xargs -r docker rmi

# Remove all unused volumes related to the project
docker volume ls --filter "name=${PROJECT_NAME}" --format "{{.Name}}" | xargs -r docker volume rm

# Remove all unused networks related to the project
docker network ls --filter "name=${PROJECT_NAME}" --format "{{.ID}}" | xargs -r docker network rm

# Build and start the containers
docker compose up --build -d