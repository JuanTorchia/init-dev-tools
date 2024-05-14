#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Incluir la biblioteca de logging
source ../lib/logging.sh

# Inicializar logs específicos para este script
init_logs "../logs/master"

# Function to print Git version installed
print_git_version() {
  if [[ -f /tmp/git_installed_version.txt ]]; then
    local installed_version
    installed_version=$(cat /tmp/git_installed_version.txt)
    log_message "Git version $installed_version is installed." "INFO"
  else
    log_message "Unable to determine the installed Git version." "ERROR"
  fi
}

# Function to print Docker version installed
print_docker_version() {
  if [[ -f /tmp/docker_installed_version.txt ]]; then
    local installed_version
    installed_version=$(cat /tmp/docker_installed_version.txt)
    log_message "Docker version $installed_version is installed." "INFO"
  else
    log_message "Unable to determine the installed Docker version." "ERROR"
  fi
}

# Function to print Java SDK versions installed
print_java_versions() {
  if [[ -f /tmp/sdkman_java_versions_installed.txt ]]; then
    log_message "Installed Java versions:" "INFO"
    cat /tmp/sdkman_java_versions_installed.txt | while read -r line; do
      log_message "$line" "INFO"
    done
  else
    log_message "Unable to determine the installed Java versions." "ERROR"
  fi
}

# Main function to coordinate the installation
main() {
  log_message "Starting installation of development tools..." "INFO"

  # Git installation
  ./bin/install_git.sh || log_message "Failed to install Git." "ERROR"
  print_git_version

  # Docker installation
  ./bin/install_docker.sh || log_message "Failed to install Docker." "ERROR"
  print_docker_version

  # SDKMAN, Java, and Maven installation
  ./bin/install_sdkman_and_java.sh || log_message "Failed to install SDKMAN and Java." "ERROR"
  print_java_versions

  # Create Maven toolchain configuration
  ./bin/create_maven_toolchain.sh || log_message "Failed to create Maven toolchain configuration." "ERROR"

  # Generate SSH keys
  ./bin/generate_ssh_key.sh || log_message "Failed to generate SSH keys." "ERROR"

  log_message "All installations and configurations completed successfully." "INFO"
}

main "$@"
