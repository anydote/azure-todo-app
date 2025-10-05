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
