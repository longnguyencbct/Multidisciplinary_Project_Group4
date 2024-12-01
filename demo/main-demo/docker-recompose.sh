#!/bin/bash

# Define the project name
PROJECT_NAME="multidisciplinary_project_group4"

# Stop and remove all running containers related to the project
docker compose down -v

# Remove the Docker image for the init-setup service
docker rmi ${PROJECT_NAME}-init-setup

# Build and start the containers
docker compose up --build -d