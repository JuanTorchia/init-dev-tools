#!/bin/bash

set -eo pipefail

# Obtener la ruta absoluta del directorio del script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Incluir la biblioteca de logging
source "$SCRIPT_DIR/../lib/logging.sh"

# Inicializar logs específicos para este script
init_logs "$SCRIPT_DIR/../logs/toolchains"

log_message "Starting Maven toolchain configuration..." "INFO"

# Ensure the .m2 directory exists
mkdir -p "$HOME/.m2"
log_message "Ensured .m2 directory exists at $HOME/.m2" "INFO"

# Toolchains file path
toolchains_file="$HOME/.m2/toolchains.xml"

# Start the toolchains.xml content
echo "<toolchains>" >"$toolchains_file"

# Source SDKMAN in all cases to ensure it's properly initialized
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
else
  log_message "SDKMAN is not installed correctly or the init script is missing." "ERROR"
  exit 1
fi

# Including all Java versions available in SDKMAN
java_versions=("11.0.23-amzn" "17.0.11-amzn" "21.0.3-amzn" "8.0.412-amzn")

for version in "${java_versions[@]}"; do
  jdk_home=$(sdk home java "$version")
  java_version_major=$(echo "$version" | grep -oP '^\d+')

  log_message "Adding Java $version to toolchains..." "INFO"
  cat <<EOF >>"$toolchains_file"
      <toolchain>
        <type>jdk</type>
        <provides>
          <version>$java_version_major</version>
          <vendor>Oracle</vendor>
        </provides>
        <configuration>
          <jdkHome>$jdk_home</jdkHome>
        </configuration>
      </toolchain>
EOF
done

# Close the toolchains.xml content
echo "</toolchains>" >>"$toolchains_file"
log_message "Maven toolchain configuration created at $toolchains_file" "INFO"
