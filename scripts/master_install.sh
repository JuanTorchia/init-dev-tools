#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Función para instalar curl si no está presente
install_curl() {
  if ! command -v curl &> /dev/null; then
    echo "curl not found. Installing curl..."
    sudo apt-get update
    sudo apt-get install -y curl
  fi
}

# Verificar si Node.js está instalado, si no, instalarlo
install_nodejs() {
  if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing Node.js..."
    install_curl
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
}

# Ejecutar la instalación de Node.js
install_nodejs

# Obtener la ruta absoluta del directorio del script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Incluir la biblioteca de logging
source "$SCRIPT_DIR/../lib/logging.sh"

# Inicializar logs específicos para este script
init_logs "$SCRIPT_DIR/../logs/master"

log_message "Starting installation script using Node.js..." "INFO"

# Ejecutar el script de Node.js para presentar el menú interactivo
node "$SCRIPT_DIR/master.js" || log_message "Failed to execute the Node.js script." "ERROR"

log_message "All selected installations and configurations completed successfully." "INFO"
