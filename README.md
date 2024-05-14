# Init Dev Tools

InitDevTools is a collection of scripts designed to facilitate the initial setup of development environments on multiple operating systems. This project follows design principles like SOLID to ensure maintainable and extensible scripts.

[README: español](https://github.com/JuanTorchia/init-dev-tools/blob/main/READMEes.md) 

InitDevTools has currently been tested on Ubuntu Server 22.04.

## Directory Structure

- **/bin/**: Contains standalone executable scripts for tasks like software installation and service configuration.
- **/config/**: Stores configuration files, separating configuration from code for clarity.
- **/lib/**: Includes common libraries or utilities that help avoid duplication and facilitate updates.
- **/logs/**: Directory for log files, useful for tracking operations and debugging errors.
- **/scripts/**: Contains high-level scripts that coordinate multiple installation and configuration tasks.

## Applied Design Principles

- **Single Responsibility**: Each script in `/bin/` focuses on a single task. For example, `install_git.sh` only installs Git.
- **Open/Closed**: Scripts in `/lib/` can be extended without modifying existing code.
- **Dependency Inversion**: Scripts in `/scripts/` depend on abstractions rather than concrete implementations, facilitating testing and reusability.
- **Separation of Concerns**: The structure separates configuration, utilities, and execution logic to allow independent modifications.

## Installation and Usage

Clone the repository to start using InitDevTools:

## Implementing Logging in New Scripts

### Overview

Logging is crucial for tracking operations, debugging errors, and maintaining a clear record of activities performed by scripts. Each script should include logging to ensure maintainability and ease of troubleshooting.

### Steps to Implement Logging

1. **Include the Logging Library**: Ensure the logging library is sourced at the beginning of your script.
2. **Initialize Logs**: Initialize the logs with a specific directory for your script.
3. **Log Messages**: Use the logging functions to record key events, information, and errors.

### Logging Library

The logging library is located in `/lib/logging.sh`. It provides functions to initialize log files and log messages.

#### Including the Logging Library

Include the logging library at the beginning of your script:
```bash
source ../lib/logging.sh
```

#### Initializing Logs

Initialize logs with a directory specific to your script:
```bash
init_logs "../logs/your_script_name"
```

#### Logging Messages

Use `log_message` to log information, warnings, and errors:
```bash
log_message "Your message here" "INFO"
log_message "Your warning message here" "WARNING"
log_message "Your error message here" "ERROR"
```

### Example Script

Here is an example script with logging implemented:

```bash
#!/bin/bash

set -eo pipefail

# Include the logging library
source ../lib/logging.sh

# Initialize logs for this script
init_logs "../logs/example_script"

log_message "Starting example script..." "INFO"

# Example operation
if ! command -v example_command >/dev/null; then
  log_message "Example command not found. Installing..." "INFO"
  sudo apt-get update
  sudo apt-get install -y example_command
  log_message "Example command installed successfully." "INFO"
else
  log_message "Example command is already installed." "INFO"
fi

log_message "Example script completed successfully." "INFO"
```

### Best Practices

1. **Granular Logging**: Log key steps and decisions in your script to make debugging easier.
2. **Error Handling**: Log errors with clear messages to understand what went wrong.
3. **Consistent Formatting**: Follow a consistent format for log messages to maintain readability.
4. **Directory Structure**: Ensure logs are stored in a dedicated directory under `/logs/`.

By following these guidelines, you can ensure that your scripts are maintainable, extensible, and easy to debug.