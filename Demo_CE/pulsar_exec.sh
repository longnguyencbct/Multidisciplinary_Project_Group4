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
sudo chmod -R 777 ./data

# Start Docker Compose
echo "Starting Docker Compose..."
sudo docker compose up -d

# Wait until the directory ./data/bookkeeper/ledgers/current is created
TARGET_DIR="./data/bookkeeper/ledgers/current"
echo "Waiting for $TARGET_DIR to be created..."

while [ ! -d "$TARGET_DIR" ]; do
    sleep 1  # Check every 1 second
done

echo "$TARGET_DIR has been created."

# Check and enforce a 100MB size limit on data/bookkeeper/ledgers/current
MAX_SIZE=102400 # 100MB in KB

echo "Checking if $TARGET_DIR exceeds $MAX_SIZE KB..."
CURRENT_SIZE=$(du -sk "$TARGET_DIR" | awk '{print $1}')

if [ "$CURRENT_SIZE" -gt "$MAX_SIZE" ]; then
    echo "Exceeded 100MB limit. Cleaning up older files in $TARGET_DIR..."
    find "$TARGET_DIR" -type f -exec rm {} +
    echo "Cleanup complete. Freed space in $TARGET_DIR."
else
    echo "$TARGET_DIR is within the size limit."
fi

echo "Setup complete. Docker containers are now running."

cd ../Demo_CS
python setup.py build_ext --inplace