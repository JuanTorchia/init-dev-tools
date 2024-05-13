# Init Dev Tools

InitDevTools is a collection of scripts designed to facilitate the initial setup of development environments on multiple operating systems. This project follows design principles like SOLID to ensure maintainable and extensible scripts.

[README: español](https://github.com/JuanTorchia/init-dev-tools/blob/main/READMEes.md) 


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
