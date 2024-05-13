#!/bin/bash

set -eo pipefail

echo "Installing SDKMAN..."
curl -s "https://get.sdkman.io" | bash

# Initializing SDKMAN in the current shell script
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Installing specific Java versions using SDKMAN
java_versions=("11.0.20-amzn" "17.0.8-amzn" "21.0.1-amzn" "8.0.372-amzn")
for version in "${java_versions[@]}"; do
    echo "Installing Java $version..."
    sdk install java "$version"
done

# Install Maven with SDKMAN
echo "Installing Maven..."
sdk install maven

echo "SDKMAN, Java, and Maven installation completed."
