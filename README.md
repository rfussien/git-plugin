# Git Plugins

[![CI Status](https://github.com/rfussien/git-plugins/workflows/Tests/badge.svg)](https://github.com/rfussien/git-plugins/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/rfussien/git-plugins)](https://github.com/rfussien/git-plugins/releases)
[![ShellCheck](https://github.com/rfussien/git-plugins/workflows/ShellCheck/badge.svg)](https://github.com/rfussien/git-plugins/actions?query=workflow%3AShellCheck)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)

A collection of useful Git plugins to enhance your Git workflow. These plugins help automate common tasks and maintain a consistent development environment.

[Features](#-features) •
[Installation](#-installation) •
[Usage](#-usage) •
[Contributing](#-contributing) •
[License](#-license)

## 🚀 Features

- **git-autocommit**: Create standardized commit messages automatically
- **git-branch-cleanup**: Clean up merged branches efficiently
- **git-get**: Organize repositories in a standardized structure (Go-style)

## 📦 Installation

### Via Homebrew (Recommended)

```bash
# Add the tap
brew tap rfussien/git-plugins https://github.com/rfussien/git-plugins

# Install individual plugins
brew install rfussien/git-plugins/git-autocommit
brew install rfussien/git-plugins/git-branch-cleanup
brew install rfussien/git-plugins/git-get
```

### Manual Installation

```bash
# Replace [plugin-name] with: git-autocommit, git-branch-cleanup, or git-get
curl -L https://raw.githubusercontent.com/rfussien/git-plugins/main/[plugin-name] -o /usr/local/bin/[plugin-name]
chmod +x /usr/local/bin/[plugin-name]
```

## 🛠 Usage

### git-autocommit

Automatically create standardized commit messages based on your branch name.

```bash
git autocommit [COMMIT_TYPE]

# Examples
git autocommit          # Creates "feat: #branch name"
git autocommit fix      # Creates "fix: #branch name"
git autocommit docs     # Creates "docs: #branch name"
```

### git-branch-cleanup

Keep your repository tidy by cleaning up merged branches.

```bash
git branch-cleanup

# Safe by default - won't delete protected branches:
# - master
# - main
# - develop
# - dev
```

### git-get

Clone and organize repositories in a standardized directory structure.

```bash
git get [OPTIONS] <repository>

# Examples
git get git@github.com:user/repo.git
git get https://github.com/user/repo
git get user/repo
git get --path /custom/path user/repo
GIT_GET_PATH=/custom/path git get user/repo

# Options
-p, --path      # Specify custom base path
```

The base path can be configured in three ways (in order of precedence):
1. Command line argument: `--path /custom/path`
2. Environment variable: `GIT_GET_PATH=/custom/path`
3. Default: `~/src`

## 🔧 Common Options

All plugins support these standard options:
```bash
-h, --help      # Show help message
--version       # Show version information
```

## 📁 Directory Structure

When using `git-get`, repositories are organized following this structure:
```
[base_path]/
├── github.com/
│   ├── username/
│   │   └── project/
│   └── organization/
│       └── project/
└── gitlab.com/
    └── username/
        └── project/
```

Where `base_path` is determined by (in order of precedence):
1. The `--path` command line option
2. The `GIT_GET_PATH` environment variable
3. Default value of `~/src`

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Version History

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and versions.

## ⭐️ Show Your Support

If you find these plugins useful, please consider giving the repository a star!
