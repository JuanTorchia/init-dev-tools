#!/bin/bash

set -eo pipefail

# Function to install required packages and add Docker's official GPG key
setup_docker_repository() {
    echo "Updating package information..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    echo "Adding Docker's GPG key..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "Setting up the repository..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

# Function to install Docker Engine, CLI, and Compose
install_docker() {
    echo "Installing Docker Engine, CLI, and Compose..."
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Verifying Docker installation by running the hello-world image..."
    sudo docker run hello-world

    # Save the installed Docker version to a file
    docker_version=$(docker --version)
    echo "$docker_version" > /tmp/docker_installed_version.txt
    echo "Docker version $docker_version has been installed and recorded."
}

# Main function to control the flow
main() {
    setup_docker_repository
    install_docker
    echo "Docker installation completed successfully."
}

main "$@"
