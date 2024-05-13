#!/bin/bash

set -eo pipefail

setup_docker_repository() {
    echo "Adding Docker's GPG key..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "Setting up the Docker repository..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

install_docker() {
    if ! command -v docker >/dev/null; then
        echo "Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        echo "Verifying Docker installation..."
        sudo docker run hello-world
    else
        echo "Docker is already installed."
    fi
}

main() {
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    setup_docker_repository
    install_docker
    echo "Docker installation completed successfully."
}

main "$@"
