#!/bin/bash

# Ensuring the script exits if any commands fail
set -eo pipefail

# Incluir la biblioteca de logging
source ../lib/logging.sh

# Inicializar logs específicos para este script
init_logs "../logs/ssh_key"

log_message "Starting SSH key generation..." "INFO"

# Asking for user input for email and a custom key name
read -p "Enter your email address: " email
read -p "Enter a custom name for your SSH key (or press enter to use the default): " keyname

# Setting default keyname if not provided
if [[ -z "$keyname" ]]; then
  keyname="id_ed25519" # Default to Ed25519 algorithm
fi

log_message "Using key name: $keyname" "INFO"

# Directory where the SSH key will be stored
ssh_dir="$HOME/.ssh"
mkdir -p "${ssh_dir}" # Ensure the .ssh directory exists
log_message "Ensured .ssh directory exists at $ssh_dir" "INFO"

# Full path to the private key
key_path="${ssh_dir}/${keyname}"

# Generating the SSH key
if [[ ! -f "${key_path}" ]]; then
  ssh-keygen -t ed25519 -C "$email" -f "${key_path}"
  log_message "SSH key generated successfully at $key_path" "INFO"
else
  log_message "SSH key already exists at ${key_path}" "INFO"
fi

# Starting the ssh-agent in the background
eval "$(ssh-agent -s)"

# Adding the SSH key to the ssh-agent
ssh-add "${key_path}"
log_message "SSH key added to ssh-agent" "INFO"

# Printing the public key to the console
echo "Your public SSH key is:"
cat "${key_path}.pub"

# Optional: Saving the public key to the project root as publickey.txt
project_root="/opt/init-dev-tools" # Modify this path to your actual project root
cp "${key_path}.pub" "${project_root}/publickey.txt"
log_message "Public key saved to ${project_root}/publickey.txt" "INFO"

# Instructions for GitHub
echo "Add this public key to your GitHub account to enable SSH access for Git operations."
