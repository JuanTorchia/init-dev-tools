#!/bin/bash

set -eo pipefail

# Function to add Docker's official GPG key and repository only if Docker is not installed
setup_docker_repository() {
    if ! command -v docker >/dev/null; then
        echo "Adding Docker's GPG key..."
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        echo "Setting up the Docker repository..."
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    else
        echo "Docker is already installed, skipping repository setup."
    fi
}

# Function to install Docker if not already installed
install_docker() {
    if ! command -v docker >/dev/null; then
        echo "Docker not found, proceeding with installation..."
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        echo "Verifying Docker installation..."
        sudo docker run hello-world
    else
        echo "Docker is already installed and operational."
    fi
}

# Main function to orchestrate steps
main() {
    # Initial checks and setup
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    
    # Set up Docker repository and install Docker
    setup_docker_repository
    install_docker
    
    echo "Docker installation script completed successfully."
}

main "$@"
