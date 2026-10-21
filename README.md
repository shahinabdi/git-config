# Git Configuration

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/shahinabdi/git-config/graphs/commit-activity)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![GitHub last commit](https://img.shields.io/github/last-commit/shahinabdi/git-config)
[![GitHub issues](https://img.shields.io/github/issues/shahinabdi/git-config)](https://github.com/shahinabdi/git-config/issues)
[![GitHub stars](https://img.shields.io/github/stars/shahinabdi/git-config)](https://github.com/shahinabdi/git-config/stargazers)
[![Downloads](https://img.shields.io/github/downloads/shahinabdi/git-config/total.svg)](https://github.com/shahinabdi/git-config/releases/)

A professional Git configuration setup with optimized settings, useful aliases, and commit message templates.

## Install directly (no clone required)

```bash
curl -fsSL https://raw.githubusercontent.com/shahinabdi/git-config/main/setup-git-config.sh | bash
```

Or with `wget`:
```bash
wget -qO- https://raw.githubusercontent.com/shahinabdi/git-config/main/setup-git-config.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/shahinabdi/git-config/main/setup-git-config.ps1 | iex
```

The installers ask for your Git name, email, and configuration type. See the direct [Linux/macOS installer](https://raw.githubusercontent.com/shahinabdi/git-config/main/setup-git-config.sh) and [Windows installer](https://raw.githubusercontent.com/shahinabdi/git-config/main/setup-git-config.ps1). Review an installer before running it if you want to inspect what it does.

Installation replaces your existing global `.gitconfig`, `.gitignore_global`, and `.gitmessage`; back up any files you want to keep.

If you prefer to inspect or edit the files locally, clone the repository and run `./setup-git-config.sh` (Linux/macOS) or `.\setup-git-config.ps1` (Windows).

## Features

* Optimized Git configuration
* Global gitignore file
* Commit message template
* Useful Git aliases
* Interactive installers for Linux, macOS, and Windows
* Direct installation without cloning the repository

## Git Aliases

```bash
git st      # status
git lg      # log with graph
git cm      # commit with message
git aa      # add all
git undo    # undo last commit
git pb      # push branch to origin
git cp      # cherry-pick
git ds      # diff staged
git ca      # commit amend
```

## Configuration Highlights
* Automatic rebase on pull
* Optimized diff visualization
* Custom commit message template
* Enhanced logging
* Automatic branch cleanup
* Performance optimizations

## Global Gitignore
* System files (.DS_Store, Thumbs.db)
* IDE/Editor files (.vscode, .idea)
* Language-specific (Python, Node.js)
* Build artifacts and logs

## Commit Message Template
```bash
<type>: <subject>

<detailed description>

<ticket/issue reference>

Types: feat, fix, docs, style, refactor, test, chore
```
## Contributing
1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License
MIT License - See LICENSE file

## Author & Contact

[![GitHub](https://img.shields.io/badge/GitHub-shahinabdi-181717?style=for-the-badge&logo=github)](https://github.com/shahinabdi)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-shahinabdi-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/shahinabdi)