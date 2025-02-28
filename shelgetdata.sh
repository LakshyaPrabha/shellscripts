#!/bin/bash

# Check if Docker is Installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing..."
    sudo apt update -y
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installed successfully."
else 
    echo "Docker is already installed."
fi

# Define Container Name
CONTAINER_NAME="flask_container"
HOST_DIR="/home/lakshya/flask_data"

# Create a Persistent Folder on the Host with Proper Permissions
echo "Creating persistent folder at $HOST_DIR..."
sudo mkdir -p "$HOST_DIR"
sudo chmod 777 "$HOST_DIR"

# Check if the Container Exists
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "Container already exists. Removing it..."
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
fi

# Run Flask Container with Persistent Mount
echo "Creating and starting Flask container..."
docker run -dit -p 5000:5000 --name "$CONTAINER_NAME" \
  --mount type=bind,source="$HOST_DIR",target=/app \
  python:3.9-slim tail -f /dev/null

# Install Flask & Requests inside the container
echo "Installing Flask & Requests..."
docker exec "$CONTAINER_NAME" sh -c "pip3 install flask requests"

# Create Flask API Script Inside the Container
echo "Writing Flask API script inside the container..."
cat << EOF | sudo tee "$HOST_DIR/myshelldata.py"
import flask
import requests

app = flask.Flask(__name__)

@app.route("/")
def home():
    return {"message": "Start to fetch data"}

@app.route("/fetch")
def fetch_data():
    url = "https://www.meesho.com/women-clothing/pl/9oo?srsltid=AfmBOoox1whmD_kUerPgJBklWTSu86jJprV7aRIOs6pG86OlWaYpaqCS"
    response = requests.get(url)
    return {"status": response.status_code, "data": response.text}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# Ensure the script is readable inside the container
sudo chmod 777 "$HOST_DIR/myshelldata.py"

# Start the Flask API in the Background
echo "Starting Flask API..."
docker exec -d "$CONTAINER_NAME" python3 /app/myshelldata.py

# Verify If Flask Is Running
sleep 3
if docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "Flask API is running at: http://localhost:5000/fetch"
    echo "Test it using: curl http://localhost:5000/fetch"
else
    echo "❌ Flask container is not running. Check logs using: docker logs $CONTAINER_NAME"
fi
