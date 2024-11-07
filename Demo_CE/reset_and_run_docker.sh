    #!/bin/bash

    # Stop any running Docker containers
    echo "Stopping any running containers..."
    sudo docker compose down

    # Remove the zookeeper and bookkeeper directories
    echo "Deleting zookeeper and bookkeeper directories..."
    sudo rm -rf ./data/zookeeper/*
    sudo rm -rf ./data/bookkeeper/*

    # Check if the directories were deleted, then recreate them if they don’t exist
    if [ -d "./data/zookeeper" ]; then
    sudo rm -rf ./data/zookeeper
    fi

    if [ -d "./data/bookkeeper" ]; then
    sudo rm -rf ./data/bookkeeper
    fi

    # Recreate the zookeeper and bookkeeper directories
    echo "Recreating zookeeper and bookkeeper directories..."
    sudo mkdir -p ./data/zookeeper ./data/bookkeeper

    # Set the correct permissions (optional but recommended if you face permission issues)
    echo "Setting permissions for data directories..."
    sudo chown -R $(whoami):$(whoami) ./data/zookeeper ./data/bookkeeper

    # Start Docker Compose
    echo "Starting Docker Compose..."
    sudo docker compose up -d

    echo "Setup complete. Docker containers are now running."
