#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

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
