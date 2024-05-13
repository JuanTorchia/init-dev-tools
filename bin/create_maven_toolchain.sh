#!/bin/bash

set -eo pipefail

# Ensure the .m2 directory exists
mkdir -p "$HOME/.m2"

# Toolchains file path
toolchains_file="$HOME/.m2/toolchains.xml"

# Start the toolchains.xml content
echo "<toolchains>" > "$toolchains_file"

# Adding each Java version to the toolchains.xml
java_versions=("11.0.20-amzn" "17.0.8-amzn" "21.0.1-amzn" "8.0.372-amzn")
for version in "${java_versions[@]}"; do
    jdk_home=$(sdk home java "$version")
    java_version_major=$(echo "$version" | cut -d. -f1 | cut -d- -f1)
    
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
