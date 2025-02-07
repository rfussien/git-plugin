# Contributing to Git Plugins

Thank you for your interest in contributing to Git Plugins! This document provides guidelines and instructions for contributing.

## Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash:git-branch-cleanup
   git clone git@github.com:your-username/git-plugins.git
   cd git-plugins
   ```

## Code Style Guidelines

### Shell Scripts
- Use `shellcheck` to lint your shell scripts
- Use `set -euo pipefail` in all scripts
- Add comments for complex logic
- Follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

### Commit Messages
Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `test:` for test changes
- `chore:` for maintenance tasks

## Pull Request Process

1. Create a new branch for your feature/fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Make your changes
3. Test your changes
4. Update documentation if needed
5. Submit a pull request
6. Ensure CI passes

## Testing

Run tests using:
```bash
make test
```

## Questions?

Feel free to open an issue for any questions or concerns.
