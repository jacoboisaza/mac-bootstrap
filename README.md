# mac-bootstrap

Reproducible Apple Silicon macOS workstation configuration for software development.

## Design

- `Brewfile` declares command-line tools and desktop applications.
- `uv` owns Python installations; Homebrew does not install Python.
- Volta owns Node.js and pnpm.
- Dotfiles are symlinked only after any existing file is backed up.
- Authentication and secrets remain interactive and outside this repository.
- Every phase is safe to run again.

## First run

Review the repository before executing anything. Then:

```bash
./setup --dry-run
./setup
./doctor
```

The initial run may pause for Xcode Command Line Tools, GitHub authentication,
Docker permissions, and application sign-in. It never stores credentials.

## Commands

```bash
./setup              # Apply the declared workstation state
./setup --dry-run    # Describe actions without changing the machine
./doctor             # Verify the workstation
./update              # Explicitly update Homebrew packages and managed tools
./snapshot            # Report installed Homebrew items for comparison
```

## Bootstrap order on a completely new Mac

1. Sign in to the Mac and enable FileVault.
2. Run `./setup`; approve Xcode Command Line Tools if macOS requests it.
3. Authenticate GitHub with `gh auth login` when prompted.
4. Create a unique SSH key with `./scripts/github-ssh.sh` and add it to GitHub.
5. Open Docker Desktop once and accept its privileged helper installation.
6. Sign in manually to VPN, messaging, AI, and Apple services.
7. Run `./doctor` and resolve any warnings.

## Version policy

Homebrew is intentionally rolling-release and has no Brewfile lockfile. Runtime
versions are declared in `config/versions.env`; projects should additionally
commit `.python-version`, `uv.lock`, `package.json`, and `pnpm-lock.yaml`.

Gemini CLI is version-pinned through Volta to avoid Homebrew installing a second
Node.js. Its upstream Homebrew formula is scheduled for deprecation in favor of
Antigravity CLI, so that migration should be reviewed during a future update.

## Safety

- No automatic `brew bundle cleanup --force`.
- No automatic deletion of files or applications.
- Existing dotfiles are copied to `~/.mac-bootstrap-backups/<timestamp>/`.
- Rosetta 2 is not installed automatically.
- macOS preferences are limited to conservative, reversible developer defaults.
