#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Incluir la biblioteca de logging
source ../lib/logging.sh

# Inicializar logs específicos para este script
init_logs "../logs/master"

log_message "Starting installation script using Node.js..." "INFO"

# Ejecutar el script de Node.js para presentar el menú interactivo
node ../scripts/master.js || log_message "Failed to execute the Node.js script." "ERROR"

log_message "All selected installations and configurations completed successfully." "INFO"
