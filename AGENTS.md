# Agent instructions

This repository configures a real developer workstation. Treat it as production infrastructure.

## Required workflow

1. On a clean Mac, follow only the public-repository instructions in `STAGE0.md` first.
2. Read `README.md`, `Brewfile`, and every script affected by the requested change.
3. Inspect the current machine before proposing changes.
4. Present a concise plan and identify commands requiring authentication, admin approval, logout, or restart.
5. Run `./setup --dry-run` before applying changes.
6. Never print, copy, commit, or request secret values.
7. Back up an existing configuration file before replacing or linking it.
8. Apply the smallest relevant phase with `./setup --only <phase>`; do not upgrade unrelated packages.
9. Preserve and cite the timestamped log when diagnosing a failed phase.
10. Run `./doctor` and report passed, failed, warning, and manual checks.

## Prohibited without explicit user approval

- Removing applications or Homebrew packages
- Running `brew bundle cleanup --force`
- Deleting or replacing SSH keys
- Changing firewall, FileVault, VPN, DNS, proxy, or corporate security settings
- Installing Rosetta 2
- Enabling Kubernetes in Docker Desktop
- Modifying repositories outside this bootstrap repository
- Uploading keys, tokens, configuration, logs, or source code

## Ownership boundaries

- Homebrew: native CLI packages and macOS applications
- uv: Python interpreters and Python command-line tools
- Volta: Node.js and pnpm
- Project repositories: language dependencies and lockfiles
- Apple Keychain: credentials
- Human: Apple ID, VPN, Docker, GitHub, and AI-service authentication

Keep scripts POSIX-aware, but Bash 3.2 compatibility is not required because the
scripts invoke `/bin/bash` and avoid features newer than macOS Bash where practical.
