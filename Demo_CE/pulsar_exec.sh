#!/bin/bash

# Stop any running Docker containers
echo "Stopping any running containers..."
sudo docker compose down

# Remove the entire data directory and everything inside it
echo "Deleting the data directory..."
sudo rm -rf ./data

# Recreate the zookeeper and bookkeeper directories inside data
echo "Recreating zookeeper and bookkeeper directories..."
sudo mkdir -p ./data/zookeeper ./data/bookkeeper

# Set the correct permissions (optional but recommended if you face permission issues)
echo "Setting permissions for data directories..."
sudo chown -R $(whoami):$(whoami) ./data

# Start Docker Compose
echo "Starting Docker Compose..."
sudo docker compose up -d

echo "Setup complete. Docker containers are now running."
