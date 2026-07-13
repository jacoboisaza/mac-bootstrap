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

On a clean Mac, follow `STAGE0.md`. After installing Apple's Command Line Tools:

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/mac-bootstrap.git
cd mac-bootstrap
./setup
./doctor
```

`setup` installs Homebrew when missing, presents its plan, and requests
confirmation. It may pause for administrator approval, Docker permissions, and
application sign-in. It never stores credentials.

Long phases print verbose tool output and a heartbeat every 20 seconds, followed
by their duration and final status. On macOS, press `Ctrl+T` at any time to ask
the terminal for foreground-process status without interrupting it.

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
2. Install Xcode Command Line Tools and clone this public repository.
3. Run `./setup`; it installs Homebrew and applies the declared configuration.
4. Optionally authenticate GitHub with `gh auth login`.
5. Create a unique SSH key with `./scripts/github-ssh.sh` and add it to GitHub.
6. Open Docker Desktop once and accept its privileged helper installation.
7. Sign in manually to VPN, messaging, AI, and Apple services.
8. Run `./doctor` and resolve any warnings.

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

## Manual applications

- ExpressVPN: download and open the official macOS installer, then approve its
  privileged helper in the GUI. It is excluded from `Brewfile` because that
  helper can fail under Homebrew's non-interactive cask installation.
- GitHub Copilot in VS Code: use the current built-in Copilot Chat and sign in
  interactively. Legacy `github.copilot*` marketplace entries are excluded to
  prevent attempts to downgrade the built-in extension.
