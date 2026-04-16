# Walkthrough: Git Workflow and Standards

## Overview
As the CAOCAP Azzam project scales, maintaining a clean, readable, and structured Git history is crucial. This walkthrough defines the official Git branching strategy and commit conventions adopted by the project.

## Branching Strategy
We use a streamlined approach based on GitFlow, with a strong emphasis on protecting the `main` branch.

- **`main`**: The primary branch. It is highly protected and represents the stable, deployable state of the application. Commits should only enter `main` via merged pull requests from `develop`.
- **`develop`**: The integration branch. All active development targets this branch. Features are merged here first to be tested collectively before a release to `main`.
- **`feature/<name>`**: Used for building out new features. Branch off `develop`, complete the work, and merge back into `develop`.
- **`fix/<name>`**: Used for bug fixes that address issues in `develop`.
- **`refactor/<name>`**: Used for code restructuring that does not alter behavior.

## Commit Conventions
We enforce **Conventional Commits**. This standardization allows developers and automated tools to easily understand the history of changes.

### Format
Every commit message must follow this format:
```
<type>(<scope>): <subject>

<body>
```

### Types
- `feat:` A new feature.
- `fix:` A bug fix.
- `docs:` Documentation only changes.
- `style:` Changes that do not affect the meaning of the code (white-space, formatting, etc).
- `refactor:` A code change that neither fixes a bug nor adds a feature.
- `perf:` A code change that improves performance.
- `test:` Adding missing tests or correcting existing tests.
- `chore:` Changes to the build process or auxiliary tools.

### Example
```
feat(ui): add animated empty states to projects list

Implemented the new monogram design with haptic feedback when
the projects list is empty, enhancing user engagement.
```

## Setup Instructions
To ensure you are using the correct commit template, run the following in the project root:
```bash
git config commit.template .gitmessage
```
This will automatically load the guidelines when you run `git commit`.
