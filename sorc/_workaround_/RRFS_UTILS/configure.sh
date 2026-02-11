#!/usr/bin/env bash
#
# shellcheck disable=SC1091

usage() {
  echo "Usage: source ${BASH_SOURCE[0]} config_file.yaml [dot.path.to.config.commands]"
}

# Make sure the script is sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  usage
  exit 1
fi

# Check for at least one argument
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage
  # Allow for error checking by the caller when sourced
  return 1 2>/dev/null
fi

run_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Read the YAML configuration
config=$("${run_dir}/readyaml" "$1" "$2" 2>&1)
if [ $? -ne 0 ]; then
    echo "Error: Failed to read YAML configuration."
    echo "${config}" | sed 's/^/    /'
    # Allow for error checking by the caller when sourced
    return 1 2>/dev/null
else
    # Source the configuration
    echo Loading config $2 from $1:
    echo "-----------------"
    echo "${config}"
    echo "-----------------"
    source <(echo "$config")
fi
