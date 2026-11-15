# Contributing

## Workflow

1. Update your local `main`: `git switch main && git pull`
2. Create a branch for your task: `git switch -c feature/<module>-<task>`
3. Commit small, focused changes.
4. Push and open a pull request into `main`.
5. Get at least **one review** from a teammate, then merge.

## Branch names

`feature/<module>-<task>` for new work and `fix/<module>-<issue>` for bug fixes. Modules: `firmware`, `backend`, `frontend`, `web`, `docs`.

Examples: `feature/frontend-sign-in`, `fix/firmware-fall-detection`

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org): `<type>: <what changed>`

| Type | Use for |
|---|---|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `refactor` | Code change without new behaviour |
| `test` | Tests |
| `chore` | Build, config, dependencies |

Example: `feat: add caregiver linking by family code`

## Before opening a pull request

- **Never commit secrets:** no `.env` files, passwords or API keys.
- **Never commit generated folders:** `venv/`, `build/`, `.pio/`.
- **Backend:** the API starts with `docker compose up`, and `pytest` passes.
- **App:** `flutter analyze` shows no issues.
- **Firmware:** `pio run` builds without errors.
- **Docs:** if you change an API or a data format, update `docs/SUMMARY.md`.
