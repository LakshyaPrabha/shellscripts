#!/bin/bash

# Update system package
echo "Updating system packages..."
sudo apt update -y

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Installing..."
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker is already installed."
fi

# Check Docker version
echo "Checking Docker version..."
docker --version

# Pull the hello-world image
echo "Pulling Hello World image..."
sudo docker pull hello-world

# Run hello-world container and store the container ID
echo "Running Hello World container..."
container_id=$(sudo docker run -d hello-world)  # Runs in detached mode and stores the container ID

# Wait for a few seconds before starting
sleep 2

# Start the container using dynamic ID
echo "Starting Hello World container..."
sudo docker start "$container_id"

# Display running containers
echo "Listing running containers..."
sudo docker ps -a
