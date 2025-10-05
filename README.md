# Minimal Azure TODO App


## Features
- Add new todo items
- View all todo items (newest first)
- Persist data across sessions

### Out of scope
- User authentication
- User management (single user only)
- Edit or delete todo items
- Advanced UI/UX features

## Architecture
A simple TODO app built with:
- React frontend (minimal, see `src/`) hosted as a Static Web App (SWA)
- Python API functions managed by SWA (`api/`)
- Azure Table Storage for persistence



## Local development

### Prerequisites
- Node.js (for frontend and SWA CLI)
- Python 3.10 or 3.11 (for backend)

### One-time setup
Install the Azure Static Web Apps CLI:
```zsh
npm install -g @azure/static-web-apps-cli
```
Install uv (Python package/dependency manager):
```zsh
curl -LsSf https://astral.sh/uv/install.sh | sh
# or, with Homebrew
brew install uv
```

Install frontend dependencies:
```zsh
npm install
```
Install backend dependencies:
```zsh
npm run backend:install
```


### Running locally
From the repo root:
```zsh
npm run app
```
This will automatically start both the frontend and backend, and proxy API requests correctly.



### Running backend tests
From the repo root:
```zsh
npm run backend:test
```

---



## Useful npm scripts

All commands below are run from the repo root:

- `npm run start` – Start React dev server (in `src/`)
- `npm run build` – Build React app (in `src/`)
- `npm run test` – Run React tests (in `src/`)
- `npm run app` – Start full stack locally with SWA CLI
- `npm run deploy` – Build and deploy app with SWA
- `npm run backend:install` – Install Python backend dependencies (uv)
- `npm run backend:test` – Run backend (API) tests (pytest)

---

---

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


## Frontend (React app)

The React frontend lives in `src/` and is built with `react-scripts` (see `package.json`).



## Backend (API) with uv

The Python backend lives in `api/`.
Project dependencies and lockfile (`pyproject.toml`, `uv.lock`) are in the repo root.
Use uv to manage dependencies and run tests.

Note:
- The POST endpoint requires `AzureWebJobsStorage` to be set. Infra deployment wires this in Azure; for local experiments, export a Storage connection string.

---


