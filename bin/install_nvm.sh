#!/bin/bash

set -eo pipefail

# Incluir la biblioteca de logging
source ../lib/logging.sh

# Inicializar logs específicos para este script
init_logs "../logs/nvm_install"

log_message "Starting NVM installation script..." "INFO"

# NVM installation directory
export NVM_DIR="$HOME/.nvm"

# Function to download and install NVM
install_nvm() {
  log_message "Installing or updating NVM..." "INFO"

  # Download and run the install script
  if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; then
    log_message "NVM download and installation script executed successfully." "INFO"
  else
    log_message "Failed to download or run the NVM installation script." "ERROR"
    exit 1
  fi

  # Source nvm script to ensure it's available immediately after install
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
    log_message "NVM sourced successfully." "INFO"
  else
    log_message "Failed to source NVM." "ERROR"
    exit 1
  fi

  log_message "NVM installed successfully." "INFO"
}

# Check if NVM is already installed by attempting to load it
if [ -s "$NVM_DIR/nvm.sh" ]; then
  log_message "NVM is already installed." "INFO"
else
  install_nvm
fi

# Adding NVM to shell profiles if not already present
if ! grep -q 'NVM_DIR' ~/.bashrc; then
  echo 'export NVM_DIR="$HOME/.nvm"' >>~/.bashrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >>~/.bashrc
  log_message "NVM loading script added to .bashrc." "INFO"
else
  log_message "NVM loading script already present in .bashrc." "INFO"
fi

if [ -n "$ZSH_VERSION" ]; then
  if ! grep -q 'NVM_DIR' ~/.zshrc; then
    echo 'export NVM_DIR="$HOME/.nvm"' >>~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >>~/.zshrc
    log_message "NVM loading script added to .zshrc." "INFO"
  else
    log_message "NVM loading script already present in .zshrc." "INFO"
  fi
fi

log_message "Installation process complete. Restart your terminal or source your shell profile to start using NVM." "INFO"
