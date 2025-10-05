# Minimal Azure TODO App

## Requirements
- Add new todo items
- View all todo items (newest first)
- Persist data across sessions

### Out of scope:
- User authentication
- User management (single user only)
- Edit or delete todo items
- Advanced UI/UX features

## Architecture
A simple TODO app built with:
- React frontend hosted as a Static Web App (SWA)
- Python API functions managed by SWA
- Azure Table Storage for persistence

## Deploy infrastructure

From the repo root:

```zsh
./infra/deploy.sh <resource-group> [location] [namePrefix]
```

Examples:

```zsh
./infra/deploy.sh todo-rg
./infra/deploy.sh todo-rg eastus2 mytodo
```

This provisions:
- Azure Static Web App (backend under `/api`)
- Azure Storage account with a `todos` Table

## Backend (API) with uv


The Python backend lives in `api/`.
Project dependencies and lockfile (`pyproject.toml`, `uv.lock`) are now in the repo root.
Use uv to manage dependencies and run tests.

### Prereqs
- Python 3.10 or 3.11 available on your machine
- uv installed

Install uv (one-time):

```zsh
curl -LsSf https://astral.sh/uv/install.sh | sh
# or, with Homebrew
brew install uv
```

### Setup and tests
From the repo root:

```zsh
# Create/refresh the virtual env from pyproject + uv.lock
uv sync

# Run unit tests
uv run pytest -q
```

Notes:
- The POST endpoint requires `AzureWebJobsStorage` to be set. Infra deployment wires this in Azure; for local experiments, export a Storage connection string.
- Azure builds can use `api/requirements.txt` directly; uv is for local dev convenience.
