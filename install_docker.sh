#!/bin/bash

# update system package
sudo apt update -y

# Install docker 
if ! command -v docker &> /dev/null
then
    echo "Docker not found . Installing..."
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
   echo "Docker install already"
fi

echo "Check  docker version"
 docker --version

 # Pull hello-world image
  echo "Pulling Hello-world"
  sudo docker pull hello-world


  echo "Runnig hello-world container..."
  sudo docker run hello-world 



echo "Start hello-world"
sudo docker start 2baf4d7bfe4d  