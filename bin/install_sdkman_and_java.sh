#!/bin/bash

set -eo pipefail

# Obtener la ruta absoluta del directorio del script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Incluir la biblioteca de logging
source "$SCRIPT_DIR/../lib/logging.sh"

# Inicializar logs específicos para este script
init_logs "$SCRIPT_DIR/../logs/sdkman_java_maven"

log_message "Checking required tools..." "INFO"

# Check and install unzip if it's not installed
if ! command -v unzip >/dev/null; then
  log_message "Unzip not found. Installing unzip..." "INFO"
  sudo apt-get update
  sudo apt-get install -y unzip
fi

# Check and install zip if it's not installed
if ! command -v zip >/dev/null; then
  log_message "Zip not found. Installing zip..." "INFO"
  sudo apt-get install -y zip
fi

log_message "Installing SDKMAN..." "INFO"
if [[ -d "$HOME/.sdkman" ]]; then
  log_message "SDKMAN is already installed." "INFO"
else
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Source SDKMAN in all cases to ensure it's properly initialized
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Function to check if a specific Java version is installed
is_java_version_installed() {
  local version="$1"
  sdk list java | grep -E "^\\s*${version}\\s+" >/dev/null
}

# Checking and installing Java versions using SDKMAN
java_versions=("11.0.23-amzn" "17.0.11-amzn" "21.0.3-amzn" "8.0.412-amzn")
for version in "${java_versions[@]}"; do
  log_message "Checking if Java $version is installed..." "INFO"
  if is_java_version_installed "$version"; then
    log_message "Java $version is already installed." "INFO"
  else
    log_message "Installing Java $version..." "INFO"
    sdk install java $version
    # Skip setting it as default
    echo "n" | sdk default java $version
  fi
done

log_message "Installing Maven..." "INFO"
if sdk list maven | grep -q "Not installed"; then
  sdk install maven
else
  log_message "Maven is already installed." "INFO"
fi

log_message "SDKMAN, Java, and Maven installation completed." "INFO"
