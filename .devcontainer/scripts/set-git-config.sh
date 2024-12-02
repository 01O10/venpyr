#!/bin/bash

# Load environment variables from /root/.env, skipping comments and empty lines
if [ -f /root/.env ]; then
  # Using awk to filter out lines that are empty or start with #
  export $(grep -v '^#' /root/.env | xargs)
fi

# Set git config using environment variables
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

echo "Git configuration set for user: $GIT_USER_NAME"
