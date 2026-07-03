# Git Aliases Guide

> Quick reference for all the shortcuts included in this configuration.

---

## Basic Commands

| Alias | Expands To | Usage |
|-------|-----------|-------|
| `git st` | `git status` | See what changed in your project |
| `git co` | `git checkout` | Switch branches or restore files |
| `git br` | `git branch` | List, create, or delete branches |
| `git ci` | `git commit` | Commit (opens editor with template) |
| `git cp` | `git cherry-pick` | Apply a specific commit to current branch |
| `git cl` | `git clone` | Download a repository |
| `git sw` | `git switch` | Switch branches (modern alternative to `co`) |

---

## Status & Diff

| Alias | Expands To | Usage |
|-------|-----------|-------|
| `git sb` | `git status -sb` | Short status with branch info |
| `git ds` | `git diff --staged` | Preview what will be in your next commit |

**Example:**

```bash
git sb
## main...origin/main
 M src/app.js
?? new-file.txt
```

---

## Add & Commit

| Alias | Expands To | Usage |
|-------|-----------|-------|
| `git aa` | `git add --all` | Stage all changes (new, modified, deleted) |
| `git cm` | `git commit -m` | Commit with an inline message |
| `git ca` | `git commit --amend` | Rewrite your last commit (message + content) |
| `git can` | `git commit --amend --no-edit` | Add staged changes to last commit silently |
| `git unstage` | `git reset HEAD --` | Remove a file from staging area |

**Examples:**

```bash
git aa && git cm "feat: add search bar"

# Forgot a file? Add it to the last commit:
git add forgotten.js
git can

# Unstage a file you didn't mean to add:
git unstage secret.env
```

---

## Branch & Merge

| Alias | Expands To | Usage |
|-------|-----------|-------|
| `git ff` | `git merge --ff-only` | Merge only if no divergence (clean history) |
| `git pb` | `git push -u origin HEAD` | Push current branch & set up tracking |
| `git gone` | *(lists stale branches)* | Show local branches whose remote is deleted |

**Examples:**

```bash
# Push a new branch for the first time:
git pb

# After a PR is merged, find leftover branches:
git gone
```

---

## Log (History)

| Alias | Usage |
|-------|-------|
| `git last` | Show only the most recent commit |
| `git lg` | Colored graph log (one line per commit) |
| `git lg1` | Alternative compact graph format |

**Example output of `git lg`:**

```
* a1b2c3d - (HEAD -> main) feat: add dark mode (2 hours ago) <You>
* e4f5g6h - fix: button alignment (5 hours ago) <You>
* i7j8k9l - (origin/main) chore: update deps (1 day ago) <Teammate>
```

---

## Info

| Alias | Usage |
|-------|-------|
| `git tags` | List all tags |
| `git branches` | List all branches (local + remote) |
| `git remotes` | Show configured remotes with URLs |

---

## Undo

| Alias | Expands To | Usage |
|-------|-----------|-------|
| `git undo` | `git reset --soft HEAD~1` | Undo last commit, keep changes staged |
| `git untrack` | `git rm --cached` | Stop tracking a file (doesn't delete it) |

**Examples:**

```bash
# Committed too early? Undo and redo:
git undo
# ... make more changes ...
git aa && git cm "better commit message"

# Accidentally committed a config file with secrets:
git untrack .env
git cm "chore: stop tracking .env"
```

---

## Quick Cheat Sheet

```
┌────────────────────────────────────────────────┐
│              GIT ALIASES CHEAT SHEET           │
├────────────────────────────────────────────────┤
│                                                │
│  EVERYDAY                                      │
│  git st          → what changed?               │
│  git aa          → stage everything            │
│  git cm "msg"    → commit                      │
│  git pb          → push                        │
│                                                │
│  REVIEW                                        │
│  git ds          → what's staged?              │
│  git lg          → pretty history              │
│  git last        → most recent commit          │
│                                                │
│  FIX MISTAKES                                  │
│  git undo        → undo last commit            │
│  git unstage f   → unstage a file              │
│  git can         → amend last commit silently  │
│  git ca          → rewrite last commit message │
│                                                │
│  BRANCHES                                      │
│  git sw -c name  → new branch                  │
│  git sw main     → switch to main              │
│  git branches    → list all                    │
│  git gone        → find stale branches         │
│                                                │
└────────────────────────────────────────────────┘
```
