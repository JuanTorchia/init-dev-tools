#!/bin/bash

set -eo pipefail

# Incluir la biblioteca de logging
source ../lib/logging.sh

# Inicializar logs específicos para este script
init_logs "../logs/docker"

# Function to add Docker's official GPG key and repository only if Docker is not installed
setup_docker_repository() {
  if ! command -v docker >/dev/null; then
    log_message "Adding Docker's GPG key..." "INFO"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    log_message "Setting up the Docker repository..." "INFO"
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  else
    log_message "Docker is already installed, skipping repository setup." "INFO"
  fi
}

# Function to install Docker if not already installed
install_docker() {
  if ! command -v docker >/dev/null; then
    log_message "Docker not found, proceeding with installation..." "INFO"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    log_message "Verifying Docker installation..." "INFO"
    sudo docker run hello-world || log_message "Docker installation verification failed." "ERROR"
  else
    log_message "Docker is already installed and operational." "INFO"
  fi
}

# Main function to orchestrate steps
main() {
  # Initial checks and setup
  log_message "Updating package list..." "INFO"
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg lsb-release

  # Set up Docker repository and install Docker
  setup_docker_repository
  install_docker

  log_message "Docker installation script completed successfully." "INFO"
}

main "$@"
