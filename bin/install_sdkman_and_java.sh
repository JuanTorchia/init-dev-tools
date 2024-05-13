#!/bin/bash

set -eo pipefail

echo "Checking required tools..."
if ! command -v unzip >/dev/null; then
    echo "Unzip not found. Please install unzip using your package manager."
    exit 1
fi

echo "Installing SDKMAN..."
if [[ -d "$HOME/.sdkman" ]]; then
    echo "SDKMAN is already installed."
else
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Installing specific Java versions using SDKMAN
java_versions=("11.0.20-amzn" "17.0.8-amzn" "21.0.1-amzn" "8.0.372-amzn")
for version in "${java_versions[@]}"; do
    if sdk list java | grep -q "$version"; then
        echo "Java $version is already installed."
    else
        echo "Installing Java $version..."
        sdk install java "$version"
    fi
done

echo "Installing Maven..."
if sdk list maven | grep -q "Not installed"; then
    sdk install maven
else
    echo "Maven is already installed."
fi

echo "SDKMAN, Java, and Maven installation completed."