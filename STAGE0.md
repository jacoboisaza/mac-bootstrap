# Stage 0 — clean Mac and public repository

Stage 0 exists only to obtain and start the public `mac-bootstrap` repository.

## 1. Install Apple's command-line tools

```bash
xcode-select --install
```

Wait for the installer to finish. This is the only separate prerequisite.

## 2. Clone and run

Replace the GitHub username, then paste:

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/mac-bootstrap.git &&
cd mac-bootstrap &&
./setup
```

`setup` shows its plan and requests confirmation before changing the workstation.
When it finishes, run:

```bash
./doctor
```

Stage 0 must not install applications, change preferences, or handle credentials.
Homebrew and the complete workstation configuration belong to `setup`.
