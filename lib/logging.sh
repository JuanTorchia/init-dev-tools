#!/bin/bash

# Function to initialize logs directory and log files
init_logs() {
  local log_dir="$1"
  mkdir -p "$log_dir"
  export ERROR_LOG="$log_dir/error.log"
  export ACTIVITY_LOG="$log_dir/activity.log"
}

# Function to log messages
log_message() {
  local message="$1"
  local log_type="$2"
  local log_file="${3:-$ACTIVITY_LOG}"

  if [[ "$log_type" == "ERROR" ]]; then
    log_file="$ERROR_LOG"
  fi

  echo "$(date +'%Y-%m-%d %H:%M:%S') - $log_type - $message" | tee -a "$log_file"
}
