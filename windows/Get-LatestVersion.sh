#!/usr/bin/env bash
function get-latest-version {
  local repo="$1"
  local verbose=0

  # Check for verbose switch
  if [[ "$2" == "-v" || "$2" == "--verbose" || "$2" == "--show-repo" ]]; then
    verbose=1
  fi

  local repo_name=$(basename "$repo") # Extract the repository name
  local latest_version=$(curl --silent "https://api.github.com/repos/$repo/releases/latest" | 
    grep '"tag_name":' | 
    sed -E 's/.*"([^"]+)".*/\1/')

  if [ "$verbose" -eq 1 ]; then
    echo "Latest $repo_name version: $latest_version"
  else
    echo "$latest_version"
  fi
}

# Example usage without verbose switch:
# version=$(get-latest-version "rustdesk/rustdesk-server-pro")
# echo "Latest version: $version"

# Example usage with verbose switch:
# get-latest-version "rustdesk/rustdesk-server-pro" -v
