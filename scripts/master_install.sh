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

# Function to print Java SDK versions installed
print_java_versions() {
    if [[ -f /tmp/sdkman_java_versions_installed.txt ]]; then
        printf "Installed Java versions:\n"
        cat /tmp/sdkman_java_versions_installed.txt
    else
        printf "Unable to determine the installed Java versions.\n"
    fi
}

# Main function to coordinate the installation
main() {
    echo "Starting installation of development tools..."

    # Git installation
    ./bin/install_git.sh
    print_git_version

    # Docker installation
    ./bin/install_docker.sh
    print_docker_version

    # SDKMAN, Java, and Maven installation
    ./bin/install_sdkman_and_java.sh
    print_java_versions

    # Create Maven toolchain configuration
    ./bin/create_maven_toolchain.sh

    # Generate SSH keys
    ./bin/generate_ssh_keys.sh

    echo "All installations and configurations completed successfully."
}

main "$@"
