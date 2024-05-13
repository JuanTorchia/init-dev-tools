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

# Main function
main() {
    ./bin/install_git.sh
    print_git_version
}

main
