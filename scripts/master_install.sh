#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Function to print Git version installed
print_git_version() {
    if [[ -f /tmp/git_installed_version.txt ]]; then
        local installed_version
        installed_version=$(cat /tmp/git_installed_version.txt)
        printf "Git version %s is installed.\n" "$installed_version"
    else
        printf "Unable to determine the installed Git version.\n"
    fi
}

# Function to print Docker version installed
print_docker_version() {
    if [[ -f /tmp/docker_installed_version.txt ]]; then
        local installed_version
        installed_version=$(cat /tmp/docker_installed_version.txt)
        printf "Docker version %s is installed.\n" "$installed_version"
    else
        printf "Unable to determine the installed Docker version.\n"
    fi
}

# Main function
main() {
    ./bin/install_git.sh
    print_git_version
    ./bin/install_docker.sh
    print_docker_version
}

main
