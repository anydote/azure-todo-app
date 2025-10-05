#!/usr/bin/env zsh
set -euo pipefail

# Minimal deployment script for infra/main.bicep
# Usage:
#   ./deploy.sh <resource-group> [location] [namePrefix]
# Examples:
#   ./deploy.sh todo-rg westeurope mytodo
#   ./deploy.sh todo-rg

RG_NAME=${1:-}
LOCATION_ARG=${2:-}
NAME_PREFIX_ARG=${3:-}

if [[ -z "$RG_NAME" ]]; then
  echo "Error: resource group name is required"
  echo "Usage: ./deploy.sh <resource-group> [location] [namePrefix]"
  exit 1
fi

# Default location if not provided
LOCATION=${LOCATION_ARG:-westeurope}
NAME_PREFIX=${NAME_PREFIX_ARG:-todo}


# Emit requirements.txt from uv.lock using uv (if available)
if command -v uv >/dev/null 2>&1; then
  if [ -d "api" ]; then
    echo "Emitting requirements.txt from uv.lock using uv..."
    (cd api && uv pip freeze > requirements.txt)
  else
    echo "Warning: api directory not found, skipping requirements.txt emission."
  fi
else
  echo "Warning: uv not found, skipping requirements.txt emission."
fi

BICEP_FILE="infra/main.bicep"

# Create RG if it doesn't exist
if ! az group show -n "$RG_NAME" >/dev/null 2>&1; then
  echo "Creating resource group '$RG_NAME' in '$LOCATION'..."
  az group create -n "$RG_NAME" -l "$LOCATION" >/dev/null
else
  echo "Using existing resource group '$RG_NAME'"
fi

# Deploy bicep
echo "Deploying Bicep template: $BICEP_FILE"
az deployment group create \
  -g "$RG_NAME" \
  -f "$BICEP_FILE" \
  -p location="$LOCATION" namePrefix="$NAME_PREFIX"

# Show outputs
echo "Deployment outputs:"
az deployment group show -g "$RG_NAME" -n $(az deployment group list -g "$RG_NAME" --query '[-1].name' -o tsv) \
  --query 'properties.outputs' -o json
