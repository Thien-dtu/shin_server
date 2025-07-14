#!/bin/bash

# This script finds all *.yml files in the current directory and passes them
# to the docker compose command.

# Find all .yml files and build the command
COMPOSE_FILES=$(find . -maxdepth 1 -name "*.yml" -print0 | xargs -0 -I {} echo -n "-f {} ")

# Execute the docker compose command with all found files and passed arguments
docker compose $COMPOSE_FILES "$@"
