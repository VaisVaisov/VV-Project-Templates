# Contributing to VV-Project-Templates

Thank you for your interest in contributing! This document explains the process for contributing to this repository.

## How to Contribute

### Reporting Issues

- Check [existing issues](../../issues) before creating a new one
- Use a clear, descriptive title
- Include steps to reproduce (for bugs) or detailed description (for features)

### Submitting Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Make your changes following the conventions below
4. Commit using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat: add new template for X`
   - `fix: correct broken CI step in Y`
   - `docs: update README with Z`
   - `chore: bump dependency versions`
5. Push and open a Pull Request

### Commit Message Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

### Code Style

- Follow the existing patterns in each template
- All CI workflows must pass before merging
- Pre-commit hooks must be satisfied locally

### Adding a New Template

1. Copy the most relevant existing template directory
2. Update `platformio.ini` / `CMakeLists.txt` / `pyproject.toml` for the new target
3. Update CI workflow with correct build commands and environment names
4. Add `wokwi.toml` + `diagram.json` if it's a firmware project
5. Update the root `README.md` to reference the new template

## Development Environment

Use the provided `.devcontainer/` for a consistent environment:
```sh
# VS Code: Reopen in Container
# Or manually:
docker build -t dev .devcontainer/
docker run -it -v $(pwd):/workspaces dev
```

## Questions

Open a [Discussion](../../discussions) or an [Issue](../../issues).
