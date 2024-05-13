#!/bin/bash

# Ensuring the script exits if any commands fail
set -eo pipefail

# Asking for user input for email and a custom key name
read -p "Enter your email address: " email
read -p "Enter a custom name for your SSH key (or press enter to use the default): " keyname

# Setting default keyname if not provided
if [[ -z "$keyname" ]]; then
    keyname="id_ed25519"  # Default to Ed25519 algorithm
fi

# Directory where the SSH key will be stored
ssh_dir="$HOME/.ssh"
mkdir -p "${ssh_dir}"  # Ensure the .ssh directory exists

# Full path to the private key
key_path="${ssh_dir}/${keyname}"

# Generating the SSH key
if [[ ! -f "${key_path}" ]]; then
    ssh-keygen -t ed25519 -C "$email" -f "${key_path}"
    echo "SSH key generated successfully."
else
    echo "SSH key already exists at ${key_path}."
fi

# Starting the ssh-agent in the background
eval "$(ssh-agent -s)"

# Adding the SSH key to the ssh-agent
ssh-add "${key_path}"

# Printing the public key to the console
echo "Your public SSH key is:"
cat "${key_path}.pub"

# Optional: Saving the public key to the project root as publickey.txt
project_root="/opt/init-dev-tools"  # Modify this path to your actual project root
cp "${key_path}.pub" "${project_root}/publickey.txt"
echo "Public key also saved to ${project_root}/publickey.txt."

# Instructions for GitHub
echo "Add this public key to your GitHub account to enable SSH access for Git operations."
