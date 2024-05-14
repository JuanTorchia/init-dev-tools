#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Obtener la ruta absoluta del directorio del script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Incluir la biblioteca de logging
source "$SCRIPT_DIR/../lib/logging.sh"

# Inicializar logs específicos para este script
init_logs "$SCRIPT_DIR/../logs/git"

log_message "Starting Git installation..." "INFO"

# Function to install Git
install_git() {
  if ! command -v git &>/dev/null; then
    log_message "Git not found. Installing Git..." "INFO"
    sudo apt-get update
    sudo apt-get install -y git
    log_message "Git installed successfully." "INFO"
  else
    log_message "Git is already installed." "INFO"
  fi
}

# Function to check and save the Git version
check_and_save_git_version() {
  local git_version
  git_version=$(git --version | awk '{print $3}')
  log_message "Installed Git version: $git_version" "INFO"
  echo "$git_version" >/tmp/git_installed_version.txt
}

# Main function to control the script flow
main() {
  install_git
  check_and_save_git_version
}

main
