# mac-bootstrap

Reproducible Apple Silicon macOS workstation configuration for software development.

## Design

- `Brewfile` declares command-line tools and desktop applications.
- `uv` owns Python installations; Homebrew does not install Python.
- `uv` also installs graphify as a version-pinned command-line tool.
- Volta owns Node.js and pnpm.
- Claude Code uses Anthropic's native installer and then updates itself on the
  channel set in `config/versions.sh`.
- Dotfiles are symlinked only after any existing file is backed up.
- Authentication and secrets remain interactive and outside this repository.
- Every phase is safe to run again.

## First run

On a clean Mac, Stage 0 is one command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jacoboisaza/mac-bootstrap/main/stage0)"
```

Stage 0 installs Apple's Command Line Tools when needed, clones the latest public
repository, and starts `setup`. `setup` installs Homebrew when missing, presents
its plan, and requests confirmation. It may pause for administrator approval,
Docker permissions, and application sign-in. It never stores credentials.

Long phases print verbose tool output and a heartbeat every 20 seconds, followed
by their duration and final status. On macOS, press `Ctrl+T` at any time to ask
the terminal for foreground-process status without interrupting it.

## Commands

```bash
./setup                         # Apply all phases and verify
./setup --dry-run               # Describe all actions without changing state
./setup --only apps             # Resume or repair a single phase
./setup --yes --only runtimes   # Non-interactive confirmation for a reviewed phase
./doctor                        # Verify declared state and exact runtime pins
./update                        # Intentionally upgrade rolling dependencies
./snapshot                      # Capture installed packages and version evidence
./tests/smoke.sh                # Static checks plus a zero-write clean-Mac dry run
```

The same smoke test runs in GitHub Actions on every push and pull request.

`doctor` initializes the standard Apple Silicon Homebrew and Volta paths itself,
so it also works from fresh, non-interactive, and SSH shells.

Available setup phases are `packages`, `apps`, `vscode`, `shell`, `runtimes`,
`dotfiles`, `macos`, and `doctor`. An optional app or editor-extension failure is
reported after all phases finish; it does not prevent runtimes or dotfiles from
being configured. Normal runs write timestamped output under `logs/`.

## Bootstrap order on a completely new Mac

1. Sign in to the Mac and enable FileVault.
2. Run the one-command Stage 0 from `STAGE0.md`.
3. Stage 0 installs Command Line Tools, clones the repository, and starts `setup`.
4. Optionally authenticate GitHub with `gh auth login`.
5. Create a unique SSH key with `./scripts/github-ssh.sh` and add it to GitHub.
6. Open Docker Desktop once and accept its privileged helper installation.
7. Sign in manually to VPN, messaging, AI, and Apple services.
8. Run `./doctor` and resolve any warnings.

## Rebuilding a Mac that is in use

Stage 0 restores only what this repository declares and what is pushed to it.
Before erasing a Mac it set up, save what exists only on that Mac:

1. Branches with unpushed commits and stashes in every repository: push them or
   keep a `git bundle`.
2. Folders outside Git and each project's `.env` files. They never go in this
   repository.
3. The `~/.claude` files: `CLAUDE.md`, any baseline files, `settings.json`, and
   the `projects/*/memory` folders. Copy `settings.json` as a file; it can hold
   tokens. Memory folder names follow each checkout's path, so restore the same
   user name and checkout paths.
4. SSH keys, or a plan to create new ones and authorize them on every server.
5. Docker Desktop resources (Settings > Resources), to set them again.
6. Any machine role this repository does not manage, such as a self-hosted CI
   runner, restored from its own private runbook.

Do not copy Docker volumes that hold production data; restore them from their
source instead.

## Version policy

Homebrew is intentionally rolling-release and has no Brewfile lockfile. Runtime
versions are declared in `config/versions.sh`; projects should additionally
commit `.python-version`, `uv.lock`, `package.json`, and `pnpm-lock.yaml`.

On the first runtime phase, channel selections such as Node 24 and Python 3.13
are resolved to exact patch versions and written to `config/runtime-lock.sh`.
Commit that generated file. Later Macs source it automatically and reproduce the
same Node, pnpm, Python, and Gemini CLI versions. To intentionally refresh the
lock, remove it in a reviewed commit, change channels if desired, and rerun the
runtime phase.

Homebrew state is separated into `brew/Brewfile.core`, `brew/Brewfile.apps`, and
`brew/Brewfile.vscode` so optional installers cannot block the required toolchain.
The root `Brewfile` aggregates all three for standard `brew bundle` commands.

Oh My Zsh is cloned directly and checked out at the exact reviewed commit in
`config/versions.sh`. Its own automatic updater is disabled; updates are made
by intentionally changing that pin.

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
