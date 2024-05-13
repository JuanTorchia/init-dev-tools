#!/bin/bash

set -eo pipefail

# Ensure the .m2 directory exists
mkdir -p "$HOME/.m2"

# Toolchains file path
toolchains_file="$HOME/.m2/toolchains.xml"

# Start the toolchains.xml content
echo "<toolchains>" > "$toolchains_file"

# Source SDKMAN in all cases to ensure it's properly initialized
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
else
    echo "SDKMAN is not installed correctly or the init script is missing."
    exit 1
fi

# Including all Java versions available in SDKMAN
java_versions=("11.0.23-amzn" "17.0.11-amzn" "21.0.3-amzn" "8.0.412-amzn")

for version in "${java_versions[@]}"; do
    jdk_home=$(sdk home java "$version")
    java_version_major=$(echo "$version" | grep -oP '^\d+')

    echo "Adding Java $version to toolchains..."
    cat <<EOF >> "$toolchains_file"
      <toolchain>
        <type>jdk</type>
        <provides>
          <version>$java_version_major</version>
          <vendor>Amazon</vendor>
        </provides>
        <configuration>
          <jdkHome>$jdk_home</jdkHome>
        </configuration>
      </toolchain>
EOF
done

# Close the toolchains.xml content
echo "</toolchains>" >> "$toolchains_file"

echo "Maven toolchain configuration created at $toolchains_file."
