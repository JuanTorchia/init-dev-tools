#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Install Git
install_git() {
    if ! command -v git &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y git
        printf "Git installed successfully.\n"
    else
        printf "Git is already installed.\n"
    fi
}

# Check the installed version of Git
check_git_version() {
    local git_version
    git_version=$(git --version | awk '{print $3}')
    printf "Installed Git version: %s\n" "$git_version"
    echo "$git_version" > /tmp/git_installed_version.txt
}

# Main function to control the script flow
main() {
    install_git
    check_git_version
}

main
